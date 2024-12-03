import 'package:flutter/material.dart';
import 'package:flutter_gen_ai_chat_ui/src/providers/theme_provider.dart';
import 'dart:math' as math;
import '../utils/font_helper.dart';

class AnimatedTextMessage extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final bool animate; // Add this flag
  final bool isUser; // Add this property

  const AnimatedTextMessage({
    Key? key,
    required this.text,
    this.style,
    this.animate = false, // Default to false
    required this.isUser, // Add this parameter
  }) : super(key: key);

  @override
  State<AnimatedTextMessage> createState() => _AnimatedTextMessageState();
}

class _AnimatedTextMessageState extends State<AnimatedTextMessage>
    with TickerProviderStateMixin {
  List<String> _words = [];
  List<Animation<double>> _fadeAnimations = [];
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _words = widget.text.split(' ');
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
          milliseconds: math.min(_words.length * 120, 800)), // Faster animation
    );

    // Fix animation intervals
    _fadeAnimations = _words.asMap().entries.map((entry) {
      final double startTime = entry.key / _words.length;
      final double endTime = math.min((entry.key + 1) / _words.length, 1.0);

      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            startTime,
            endTime,
            curve: Curves.easeOut,
          ),
        ),
      );
    }).toList();

    if (widget.animate) {
      _controller.forward();
    } else {
      _controller.value = 1.0; // Instantly show text if not animating
    }
  }

  @override
  void didUpdateWidget(AnimatedTextMessage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.text != oldWidget.text) {
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context).extension<CustomThemeExtension>() ??
        ThemeProvider.lightTheme.extension<CustomThemeExtension>()!;

    return Directionality(
      textDirection: _detectTextDirection(widget.text),
      child: Wrap(
        alignment: WrapAlignment.start,
        children: _words.asMap().entries.map((entry) {
          int idx = entry.key;
          String word = entry.value;
          return FadeTransition(
            opacity: _fadeAnimations[idx],
            child: SelectableText(
              '$word ',
              style: FontHelper.getAppropriateFont(
                text: word,
                baseStyle: widget.style?.copyWith(
                  color: customTheme.messageTextColor,
                  fontSize: widget.style?.fontSize ?? 15,
                ),
              ),
              // Add these properties for better selection experience
              enableInteractiveSelection: true,
              showCursor: true,
              cursorColor: customTheme.messageTextColor.withOpacity(0.5),
              toolbarOptions: const ToolbarOptions(
                copy: true,
                selectAll: true,
                cut: false,
                paste: false,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  TextDirection _detectTextDirection(String text) {
    if (text.isEmpty) return TextDirection.ltr;
    // Use Unicode ranges to detect Arabic/Persian/Kurdish text
    final RegExp arabicRegex = RegExp(
        r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]');
    return arabicRegex.hasMatch(text) ? TextDirection.rtl : TextDirection.ltr;
  }

  bool _isArabic(String text) {
    final RegExp arabicRegex = RegExp(
        r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]');
    return arabicRegex.hasMatch(text);
  }
}
