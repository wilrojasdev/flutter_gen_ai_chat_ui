import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechService {
  final SpeechToText speechToText = SpeechToText();
  bool _speechEnabled = false;
  LocaleName? preferredLocale;

  Future<bool> initializeStt() async {
    try {
      _speechEnabled = await speechToText.initialize(
        onError: (error) {
          debugPrint('Speech recognition error: ${error.errorMsg}');
          // Check for specific iOS errors
          if (error.errorMsg.contains('Retry') ||
              error.errorMsg.contains('network')) {
            _speechEnabled = false;
            speechToText.cancel();
          }
        },
        finalTimeout: const Duration(seconds: 2),
      );

      if (_speechEnabled) {
        var systemLocale = await speechToText.systemLocale();
        var availableLocales = await speechToText.locales();

        preferredLocale = availableLocales.firstWhere(
          (locale) =>
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
  double _soundLevel = 0.0;
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _speechService = SpeechService();
    _initSpeechToText();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    )..addListener(() {
        setState(() {});
      });

    _pulseController.repeat(reverse: true);
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
    bool hasPermission = true;
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
        onResult: (result) {
          if (result.finalResult) {
            if (result.recognizedWords.isNotEmpty) {
              widget.onResult(result.recognizedWords);
            }
            _stopListening();
          }
        },
        localeId: widget.locale ?? _speechService.preferredLocale?.localeId,
        cancelOnError: false,
        partialResults: true,
        listenMode: ListenMode.confirmation,
        onSoundLevelChange: (level) {
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
  Widget build(BuildContext context) {
    if (widget.customBuilder != null) {
      return widget.customBuilder!(_isListening, _toggleListening);
    }

    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final primaryColor = theme.primaryColor;

    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (_isListening) ...[
            // Outer pulse animation
            Transform.scale(
              scale: _pulseAnimation.value,
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            // Sound level indicator
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.2),
                shape: BoxShape.circle,
                border: Border.all(
                  color: primaryColor.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: CustomPaint(
                painter: SoundLevelPainter(
                  level: _soundLevel,
                  color: primaryColor,
                ),
              ),
            ),
          ],
          // Main button
          IconButton(
            icon: Icon(
              _isListening
                  ? (widget.activeIcon ?? Icons.mic)
                  : (widget.icon ?? Icons.mic_none),
              color: _isListening
                  ? primaryColor
                  : (isDarkMode ? Colors.white70 : Colors.black54),
              size: 24,
            ),
            onPressed: _toggleListening,
            tooltip: _isListening ? 'Stop listening' : 'Start listening',
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
  final double level;
  final Color color;
  static const double minBarHeight = 5.0; // Minimum height to show a bar

  SoundLevelPainter({required this.level, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5
      ..strokeCap = StrokeCap.round;

    // Draw sound level bars
    final maxBars = 8;
    final barWidth = 1.0;
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
  bool shouldRepaint(SoundLevelPainter oldDelegate) =>
      level != oldDelegate.level;
}
