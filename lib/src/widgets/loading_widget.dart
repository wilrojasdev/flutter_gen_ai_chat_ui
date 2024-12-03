import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:async';
import '../utils/font_helper.dart';
import '../providers/theme_provider.dart';

class LoadingWidget extends StatefulWidget {
  final List<String>? texts;
  final Duration? interval;
  final TextStyle? textStyle; // Add this line

  const LoadingWidget({
    super.key,
    this.texts,
    this.interval,
    this.textStyle, // Add this line
  });

  /// Shows a loading dialog with custom texts and interval
  static Future<void> show(
    BuildContext context, {
    List<String>? texts,
    Duration? interval,
    bool barrierDismissible = true,
    TextStyle? textStyle, // Add this line
  }) {
    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => Stack(
        children: [
          Center(
            child: LoadingWidget(
              texts: texts,
              interval: interval,
              textStyle: textStyle,
            ),
          ),
          Positioned(
            right: 8,
            top: 8,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white70),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }

  /// Shows a loading overlay as a modal bottom sheet
  static Future<void> showAsBottomSheet(
    BuildContext context, {
    List<String>? texts,
    Duration? interval,
    TextStyle? textStyle, // Add this line
  }) {
    return showModalBottomSheet(
      context: context,
      builder: (context) => SizedBox(
        height: 100,
        child: Center(
          child: LoadingWidget(
            texts: texts,
            interval: interval,
            textStyle: textStyle, // Add this line
          ),
        ),
      ),
    );
  }

  @override
  _LoadingWidgetState createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget>
    with SingleTickerProviderStateMixin {
  late final List<String> loadingTexts;
  late final Duration intervalDuration;
  int currentIndex = 0;
  late Timer timer;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    loadingTexts = widget.texts ??
        [
          'Loading...',
          'Please wait...',
          'Almost there...',
          'Just a moment...',
          'Fetching data...'
        ];
    intervalDuration = widget.interval ?? const Duration(seconds: 5);

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();

    timer = Timer.periodic(intervalDuration, (Timer t) {
      setState(() {
        currentIndex = (currentIndex + 1) % loadingTexts.length;
        _controller.forward(from: 0.0);
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context).extension<CustomThemeExtension>() ??
        ThemeProvider.lightTheme.extension<CustomThemeExtension>()!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final defaultStyle = TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w500,
      color: customTheme.messageTextColor,
    );

    return Material(
      color: Colors.transparent,
      child: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Shimmer.fromColors(
              baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
              highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
              child: Text(
                loadingTexts[currentIndex],
                style: FontHelper.getAppropriateFont(
                  text: loadingTexts[currentIndex],
                  baseStyle: widget.textStyle ?? defaultStyle,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildShimmerText() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Text(
          loadingTexts[currentIndex],
          style: FontHelper.getAppropriateFont(
            text: loadingTexts[currentIndex],
            baseStyle: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.grey[800],
            ),
          ),
        ),
      ),
    );
  }
}
