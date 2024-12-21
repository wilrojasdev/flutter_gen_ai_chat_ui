import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:async';
import '../utils/font_helper.dart';
import '../providers/theme_provider.dart';

class LoadingWidget extends StatefulWidget {
  final List<String>? texts;
  final Duration? interval;
  final TextStyle? textStyle;
  final bool show;
  final Color? baseColor;
  final Color? highlightColor;
  final Duration? shimmerDuration;

  const LoadingWidget({
    super.key,
    this.texts,
    this.interval,
    this.textStyle,
    this.show = true,
    this.baseColor,
    this.highlightColor,
    this.shimmerDuration,
  });

  @override
  _LoadingWidgetState createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget> {
  late final List<String> loadingTexts;
  late final Duration intervalDuration;
  int currentIndex = 0;
  Timer? timer;

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
    intervalDuration = widget.interval ?? const Duration(seconds: 2);

    timer = Timer.periodic(intervalDuration, (Timer t) {
      if (mounted) {
        setState(() {
          currentIndex = (currentIndex + 1) % loadingTexts.length;
        });
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    timer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context).extension<CustomThemeExtension>() ??
        ThemeProvider.lightTheme.extension<CustomThemeExtension>()!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final defaultStyle = TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.2,
      color: customTheme.messageTextColor,
    );

    // Default shimmer colors based on theme
    final defaultBaseColor = isDark
        ? customTheme.messageBubbleColor.withOpacity(0.7)
        : const Color(0xFFE0E0E0);
    final defaultHighlightColor = isDark
        ? customTheme.inputBackgroundColor.withOpacity(0.5)
        : const Color(0xFFF5F5F5);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 2000),
      transitionBuilder: (Widget child, Animation<double> animation) {
        final offsetAnimation = Tween<Offset>(
          begin: const Offset(0, -0.2),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        ));

        final fadeAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOut,
          reverseCurve: Curves.easeIn,
        );

        return SlideTransition(
          position: offsetAnimation,
          child: FadeTransition(
            opacity: fadeAnimation,
            child: child,
          ),
        );
      },
      child: widget.show
          ? Material(
              key: ValueKey<bool>(widget.show),
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 20.0),
                child: Shimmer.fromColors(
                  period: widget.shimmerDuration ??
                      const Duration(milliseconds: 3000),
                  baseColor: widget.baseColor ?? defaultBaseColor,
                  highlightColor:
                      widget.highlightColor ?? defaultHighlightColor,
                  child: Text(
                    loadingTexts[currentIndex],
                    style: FontHelper.getAppropriateFont(
                      text: loadingTexts[currentIndex],
                      baseStyle: widget.textStyle ?? defaultStyle,
                    ),
                  ),
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
