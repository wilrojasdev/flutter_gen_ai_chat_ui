import 'package:flutter/material.dart';
import '../ai_chat_config.dart';

/// Options for customizing message appearance and behavior
class MessageOptions {
  /// Style for the message text
  final TextStyle? textStyle;

  /// Padding around the message bubble
  final EdgeInsets? padding;

  /// Decoration for the message bubble
  final BoxDecoration? decoration;

  /// Whether to show message timestamp
  final bool showTime;

  /// Style for the timestamp text
  final TextStyle? timeTextStyle;

  const MessageOptions({
    this.textStyle,
    this.padding,
    this.decoration,
    this.showTime = true,
    this.timeTextStyle,
  });

  MessageOptions copyWith({
    TextStyle? textStyle,
    EdgeInsets? padding,
    BoxDecoration? decoration,
    bool? showTime,
    TextStyle? timeTextStyle,
  }) =>
      MessageOptions(
        textStyle: textStyle ?? this.textStyle,
        padding: padding ?? this.padding,
        decoration: decoration ?? this.decoration,
        showTime: showTime ?? this.showTime,
        timeTextStyle: timeTextStyle ?? this.timeTextStyle,
      );
}

/// Options for customizing the message list
class MessageListOptions {
  /// Custom scroll controller for the message list
  final ScrollController? scrollController;

  /// Custom scroll physics for the message list
  final ScrollPhysics? scrollPhysics;

  /// Builder for date separator between messages
  final Widget Function(DateTime)? dateSeparatorBuilder;

  /// Widget to show while loading more messages
  final Widget? loadingWidget;

  /// Callback when loading earlier messages via button
  final Future<void> Function()? onLoadEarlier;

  /// Pagination configuration for message loading
  final PaginationConfig paginationConfig;

  /// Whether more messages are currently loading
  final bool isLoadingMore;

  /// Whether there are more messages to load
  final bool hasMoreMessages;

  /// Callback when automatic loading more messages is triggered by scroll
  final Future<void> Function()? onLoadMore;

  const MessageListOptions({
    this.scrollController,
    this.scrollPhysics,
    this.dateSeparatorBuilder,
    this.loadingWidget,
    this.onLoadEarlier,
    this.paginationConfig = const PaginationConfig(),
    this.isLoadingMore = false,
    this.hasMoreMessages = true,
    this.onLoadMore,
  });

  MessageListOptions copyWith({
    ScrollController? scrollController,
    ScrollPhysics? scrollPhysics,
    Widget Function(DateTime)? dateSeparatorBuilder,
    Widget? loadingWidget,
    Future<void> Function()? onLoadEarlier,
    PaginationConfig? paginationConfig,
    bool? isLoadingMore,
    bool? hasMoreMessages,
    Future<void> Function()? onLoadMore,
  }) =>
      MessageListOptions(
        scrollController: scrollController ?? this.scrollController,
        scrollPhysics: scrollPhysics ?? this.scrollPhysics,
        dateSeparatorBuilder: dateSeparatorBuilder ?? this.dateSeparatorBuilder,
        loadingWidget: loadingWidget ?? this.loadingWidget,
        onLoadEarlier: onLoadEarlier ?? this.onLoadEarlier,
        paginationConfig: paginationConfig ?? this.paginationConfig,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
        hasMoreMessages: hasMoreMessages ?? this.hasMoreMessages,
        onLoadMore: onLoadMore ?? this.onLoadMore,
      );
}

/// Options for customizing quick replies
class QuickReplyOptions {
  /// List of quick reply options
  final List<String>? quickReplies;

  /// Callback when a quick reply is tapped
  final void Function(String)? onQuickReplyTap;

  /// Decoration for quick reply buttons
  final BoxDecoration? decoration;

  /// Text style for quick reply buttons
  final TextStyle? textStyle;

  const QuickReplyOptions({
    this.quickReplies,
    this.onQuickReplyTap,
    this.decoration,
    this.textStyle,
  });

  QuickReplyOptions copyWith({
    List<String>? quickReplies,
    void Function(String)? onQuickReplyTap,
    BoxDecoration? decoration,
    TextStyle? textStyle,
  }) =>
      QuickReplyOptions(
        quickReplies: quickReplies ?? this.quickReplies,
        onQuickReplyTap: onQuickReplyTap ?? this.onQuickReplyTap,
        decoration: decoration ?? this.decoration,
        textStyle: textStyle ?? this.textStyle,
      );
}

/// Options for customizing scroll to bottom button
class ScrollToBottomOptions {
  /// Whether to disable the scroll to bottom button
  final bool disabled;

  /// Whether to always show the scroll to bottom button
  final bool alwaysVisible;

  /// Callback when scroll to bottom button is pressed
  final VoidCallback? onScrollToBottomPress;

  /// Custom builder for scroll to bottom button
  final Widget Function(ScrollController)? scrollToBottomBuilder;

  const ScrollToBottomOptions({
    this.disabled = false,
    this.alwaysVisible = false,
    this.onScrollToBottomPress,
    this.scrollToBottomBuilder,
  });

  ScrollToBottomOptions copyWith({
    bool? disabled,
    bool? alwaysVisible,
    VoidCallback? onScrollToBottomPress,
    Widget Function(ScrollController)? scrollToBottomBuilder,
  }) =>
      ScrollToBottomOptions(
        disabled: disabled ?? this.disabled,
        alwaysVisible: alwaysVisible ?? this.alwaysVisible,
        onScrollToBottomPress:
            onScrollToBottomPress ?? this.onScrollToBottomPress,
        scrollToBottomBuilder:
            scrollToBottomBuilder ?? this.scrollToBottomBuilder,
      );
}
