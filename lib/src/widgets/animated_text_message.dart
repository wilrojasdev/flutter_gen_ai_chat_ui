import 'dart:async';
import 'package:flutter/material.dart';

/// A widget that animates text appearing character by character
class AnimatedTextMessage extends StatefulWidget {
  const AnimatedTextMessage({
    super.key,
    required this.text,
    required this.style,
    required this.animate,
    required this.isUser,
    this.isStreaming = false,
    this.textBuilder,
  });

  final String text;
  final TextStyle style;
  final bool animate;
  final bool isUser;
  final bool isStreaming;
  final Widget Function(String text, TextStyle style)? textBuilder;

  @override
  State<AnimatedTextMessage> createState() => _AnimatedTextMessageState();
}

class _AnimatedTextMessageState extends State<AnimatedTextMessage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  String _displayText = '';
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    if (widget.animate && !widget.isUser) {
      _startAnimation();
    } else {
      _displayText = widget.text;
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(AnimatedTextMessage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.text != oldWidget.text) {
      if (widget.animate && !widget.isUser) {
        _startAnimation();
      } else {
        _displayText = widget.text;
        _controller.value = 1.0;
      }
    }
  }

  void _startAnimation() {
    _displayText = '';
    _currentIndex = 0;
    _controller.reset();
    _controller.forward();

    const duration = Duration(milliseconds: 30);
    _timer?.cancel();
    _timer = Timer.periodic(duration, (timer) {
      if (_currentIndex < widget.text.length) {
        setState(() {
          _displayText += widget.text[_currentIndex];
          _currentIndex++;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
        opacity: _animation,
        child: widget.textBuilder?.call(_displayText, widget.style) ??
            Text(
              _displayText,
              style: widget.style,
            ),
      );

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }
}
