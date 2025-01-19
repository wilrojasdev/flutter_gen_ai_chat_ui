import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechService {
  final SpeechToText speechToText = SpeechToText();
  bool _speechEnabled = false;
  LocaleName? preferredLocale;

  Future<bool> initializeStt() async {
    try {
      _speechEnabled = await speechToText.initialize(
        onError: (final error) {
          debugPrint('Speech recognition error: ${error.errorMsg}');
          // Check for specific iOS errors
          if (error.errorMsg.contains('Retry') ||
              error.errorMsg.contains('network')) {
            _speechEnabled = false;
            speechToText.cancel();
          }
        },
      );

      if (_speechEnabled) {
        final systemLocale = await speechToText.systemLocale();
        final availableLocales = await speechToText.locales();

        preferredLocale = availableLocales.firstWhere(
          (final locale) =>
              locale.localeId.startsWith('en_') ||
              locale.localeId.startsWith('en-'),
          orElse: () => systemLocale ?? availableLocales.first,
        );
      }

      return _speechEnabled;
    } catch (e) {
      debugPrint('Failed to initialize speech recognition: $e');
      return false;
    }
  }

  void dispose() {
    speechToText.cancel();
  }
}

/// A button widget that handles speech-to-text functionality
class SpeechToTextButton extends StatefulWidget {
  const SpeechToTextButton({
    super.key,
    required this.onResult,
    this.icon,
    this.activeIcon,
    this.locale,
    this.customBuilder,
    this.onSpeechStart,
    this.onSpeechEnd,
    this.onSpeechError,
    this.onRequestPermission,
  });

  /// Callback when speech is recognized
  final void Function(String text) onResult;

  /// Icon for the inactive state
  final IconData? icon;

  /// Icon for the active state
  final IconData? activeIcon;

  /// Locale for speech recognition
  final String? locale;

  /// Custom builder for the button
  final Widget Function(bool isListening, VoidCallback onPressed)?
      customBuilder;

  /// Callback when speech recognition starts
  final Future<void> Function()? onSpeechStart;

  /// Callback when speech recognition ends
  final Future<void> Function()? onSpeechEnd;

  /// Callback when speech recognition has an error
  final void Function(String error)? onSpeechError;

  /// Callback to handle speech recognition permissions
  final Future<bool> Function()? onRequestPermission;

  @override
  State<SpeechToTextButton> createState() => _SpeechToTextButtonState();
}

class _SpeechToTextButtonState extends State<SpeechToTextButton>
    with SingleTickerProviderStateMixin {
  late final SpeechService _speechService;
  bool _isListening = false;
  double _soundLevel = 0;
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _speechService = SpeechService();
    _initSpeechToText();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.95, end: 1.2)
            .chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.2, end: 0.95)
            .chain(CurveTween(curve: Curves.easeInCubic)),
        weight: 50,
      ),
    ]).animate(_pulseController);

    _fadeAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.3, end: 0.7)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.7, end: 0.3)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 50,
      ),
    ]).animate(_pulseController);

    _pulseController.repeat();
  }

  Future<void> _initSpeechToText() async {
    try {
      final initialized = await _speechService.initializeStt();
      if (!initialized) {
        widget.onSpeechError?.call('Failed to initialize speech recognition');
      }
    } catch (e) {
      debugPrint('Speech recognition initialization error: $e');
      widget.onSpeechError?.call(e.toString());
    }
  }

  Future<void> _toggleListening() async {
    if (_isListening) {
      await _stopListening();
    } else {
      await _startListening();
    }
  }

  Future<void> _startListening() async {
    var hasPermission = true;
    if (widget.onRequestPermission != null) {
      hasPermission = await widget.onRequestPermission!();
    }

    if (!hasPermission) {
      widget.onSpeechError?.call('Permission denied');
      return;
    }

    setState(() {
      _isListening = true;
      _soundLevel = 0.0;
    });
    widget.onSpeechStart?.call();

    try {
      await _speechService.speechToText.listen(
        onResult: (final result) {
          if (result.finalResult) {
            if (result.recognizedWords.isNotEmpty) {
              widget.onResult(result.recognizedWords);
            }
            _stopListening();
          }
        },
        localeId: widget.locale ?? _speechService.preferredLocale?.localeId,
        onSoundLevelChange: (final level) {
          if (mounted) {
            setState(() {
              _soundLevel = level;
            });
          }
        },
      );
    } catch (e) {
      debugPrint('Error starting speech recognition: $e');
      widget.onSpeechError?.call(e.toString());
      await _stopListening();
    }
  }

  Future<void> _stopListening() async {
    try {
      await _speechService.speechToText.stop();
    } catch (e) {
      debugPrint('Error stopping speech recognition: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isListening = false;
          _soundLevel = 0.0;
        });
      }
      widget.onSpeechEnd?.call();
    }
  }

  @override
  Widget build(final BuildContext context) {
    if (widget.customBuilder != null) {
      return widget.customBuilder!(_isListening, _toggleListening);
    }

    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final primaryColor = theme.primaryColor;
    final activeColor = isDarkMode ? Colors.white : primaryColor;

    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (_isListening) ...[
            // Outer pulse
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) => Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: activeColor
                        .withAlpha((_fadeAnimation.value * 255).toInt()),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            // Inner pulse
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) => Transform.scale(
                scale: _pulseAnimation.value * 0.85,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: activeColor
                        .withAlpha((_fadeAnimation.value * 255 * 0.7).toInt()),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            // Sound level indicator
            CustomPaint(
              size: const Size(40, 40),
              painter: SoundLevelPainter(
                level: _soundLevel,
                color: activeColor,
              ),
            ),
          ],
          // Main button with background
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _isListening
                  ? activeColor.withAlpha(isDarkMode ? 77 : 26)
                  : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(
                _isListening
                    ? (widget.activeIcon ?? Icons.mic)
                    : (widget.icon ?? Icons.mic_none),
                color: _isListening
                    ? activeColor
                    : (isDarkMode ? Colors.white : Colors.black54),
                size: 22,
              ),
              onPressed: _toggleListening,
              tooltip: _isListening ? 'Stop listening' : 'Start listening',
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _speechService.dispose();
    super.dispose();
  }
}

class SoundLevelPainter extends CustomPainter {
  // Minimum height to show a bar

  SoundLevelPainter({required this.level, required this.color});
  final double level;
  final Color color;
  static const double minBarHeight = 5;

  @override
  void paint(final Canvas canvas, final Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5
      ..strokeCap = StrokeCap.round;

    // Draw sound level bars
    const maxBars = 8;
    const barWidth = 1.0;
    final maxHeight = radius - 6; // Reduced max height to prevent edge touching
    final normalizedLevel = (level / 100) * maxHeight;

    if (normalizedLevel > 0) {
      // Only draw if there's actual sound
      for (var i = 0; i < maxBars; i++) {
        final barHeight = (normalizedLevel * (i + 1) / maxBars)
            .clamp(minBarHeight, maxHeight);

        // Only draw if bar height is above minimum
        if (barHeight > minBarHeight) {
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromCenter(
                center: center.translate(0, -barHeight / 2),
                width: barWidth,
                height: barHeight,
              ),
              const Radius.circular(1),
            ),
            paint,
          );
        }

        canvas.rotate(2 * 3.14159 / maxBars);
      }
    } else {
      // Draw a simple circle when not detecting sound
      canvas.drawCircle(
        center,
        radius - 4,
        paint..style = PaintingStyle.stroke,
      );
    }
  }

  @override
  bool shouldRepaint(final SoundLevelPainter oldDelegate) =>
      level != oldDelegate.level;
}
