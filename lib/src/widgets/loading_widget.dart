import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// A loading widget that displays a shimmer effect with customizable text.
class LoadingWidget extends StatefulWidget {
  /// Creates a loading widget with optional text cycling.
  const LoadingWidget({
    super.key,
    this.texts = const ['Loading...'],
    this.interval = const Duration(seconds: 2),
    this.textStyle,
  });

  /// The list of texts to cycle through.
  final List<String> texts;

  /// The interval between text changes.
  final Duration interval;

  /// The text style for the loading text.
  final TextStyle? textStyle;

  @override
  State<LoadingWidget> createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget> {
  late Timer _timer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(widget.interval, (final t) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % widget.texts.length;
      });
    });
  }

  @override
  Widget build(final BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLoadingIndicator(),
            const SizedBox(height: 16),
            _buildLoadingText(),
          ],
        ),
      );

  Widget _buildLoadingIndicator() => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50),
          ),
        ),
      );

  Widget _buildLoadingText() => AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (final child, final animation) => FadeTransition(
          opacity: animation,
          child: child,
        ),
        child: Text(
          widget.texts[_currentIndex],
          key: ValueKey<String>(widget.texts[_currentIndex]),
          style: widget.textStyle ??
              const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
        ),
      );
}
