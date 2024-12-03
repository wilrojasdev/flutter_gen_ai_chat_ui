import 'package:flutter/material.dart';

class AnimatedBubble extends StatefulWidget {
  final Widget child;
  final bool animate;
  final bool isUser; // Add this parameter

  const AnimatedBubble({
    Key? key,
    required this.child,
    required this.isUser, // Make it required
    this.animate = false,
  }) : super(key: key);

  @override
  State<AnimatedBubble> createState() => _AnimatedBubbleState();
}

class _AnimatedBubbleState extends State<AnimatedBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _initializeAnimations();
      _isInitialized = true;
    }
  }

  void _initializeAnimations() {
    bool isRTL = Directionality.of(context) == TextDirection.rtl;
    double startOffset =
        widget.isUser ? (isRTL ? -0.3 : 0.3) : (isRTL ? 0.3 : -0.3);

    _slideAnimation = Tween<Offset>(
      begin: Offset(startOffset, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutQuart,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    if (widget.animate) {
      _controller.forward();
    } else {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: widget.child,
      ),
    );
  }
}
