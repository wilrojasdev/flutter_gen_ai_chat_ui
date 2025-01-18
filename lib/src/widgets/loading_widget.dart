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
    this.shimmerBaseColor,
    this.shimmerHighlightColor,
  });

  /// The list of texts to cycle through.
  final List<String> texts;

  /// The interval between text changes.
  final Duration interval;

  /// The text style for the loading text.
  final TextStyle? textStyle;

  /// The base color for the shimmer effect.
  final Color? shimmerBaseColor;

  /// The highlight color for the shimmer effect.
  final Color? shimmerHighlightColor;

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
    _timer = Timer.periodic(widget.interval, (final timer) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % widget.texts.length;
      });
    });
  }

  @override
  Widget build(final BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    final baseColor = widget.shimmerBaseColor ??
        (isDark ? const Color(0xFF141414) : const Color(0xFFD8D8D8));
    final highlightColor = widget.shimmerHighlightColor ??
        (isDark ? primaryColor.withAlpha(179) : primaryColor.withAlpha(102));

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        period: const Duration(milliseconds: 1000),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: Text(
            widget.texts[_currentIndex],
            key: ValueKey<String>(widget.texts[_currentIndex]),
            style: widget.textStyle ??
                TextStyle(
                  color: isDark
                      ? Colors.white
                      : Theme.of(context).colorScheme.onSurface,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                  height: 1.4,
                ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
