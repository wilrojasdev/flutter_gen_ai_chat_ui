import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'chat/models.dart';
import 'example_question_config.dart';
import 'input_options.dart';
import 'welcome_message_config.dart';

/// Configuration class for customizing the AI chat interface.
///
/// This class provides extensive customization options for the chat UI,
/// including themes, animations, input styling, and message display options.
/// All configurations should be passed through this class to maintain
/// a single source of configuration.
class AiChatConfig {
  const AiChatConfig({
    this.userName = 'User',
    required this.aiName,
    this.hintText,
    this.maxWidth,
    this.padding,
    this.enableAnimation = true,
    this.showTimestamp = true,
    this.exampleQuestions = const [],
    // Welcome message configuration
    this.welcomeMessageConfig,
    this.exampleQuestionConfig,
    // Chat options
    InputOptions? inputOptions,
    this.messageOptions,
    this.messageListOptions,
    this.quickReplyOptions,
    this.scrollToBottomOptions,
    this.readOnly = false,
    this.typingUsers,
    // UI options
    @Deprecated('Use inputOptions.inputTextStyle instead') this.inputTextStyle,
    @Deprecated('Use inputOptions.inputDecoration instead')
    this.inputDecoration,
    this.messageBuilder,
    this.scrollToBottomBuilder,
    @Deprecated('Use inputOptions.sendButtonBuilder instead')
    this.sendButtonBuilder,
    @Deprecated('Use inputOptions.inputDecoration.suffixIcon instead')
    this.sendButtonIcon,
    @Deprecated('Configure through inputOptions.inputDecoration.suffixIcon')
    this.sendButtonIconSize,
    @Deprecated('Configure through inputOptions.inputDecoration.suffixIcon')
    this.sendButtonPadding,
    // Pagination options
    this.paginationConfig = const PaginationConfig(),
    // Callbacks
    this.callbackConfig = const CallbackConfig(),
    // Loading state
    this.loadingConfig = const LoadingConfig(),
    this.enableMarkdownStreaming = true,
    this.streamingDuration = const Duration(milliseconds: 30),
    this.markdownStyleSheet,
  }) : inputOptions = inputOptions ?? const InputOptions();

  /// The name of the user in the chat interface.
  final String userName;

  /// The name of the AI assistant in the chat interface.
  final String aiName;

  /// Placeholder text for the input field.
  final String? hintText;

  /// Maximum width of the chat interface. If null, takes full width.
  final double? maxWidth;

  /// Padding around the chat interface.
  final EdgeInsets? padding;

  /// Whether to enable message animations. Defaults to true.
  /// This controls both message appearance and typing animations.
  final bool enableAnimation;

  /// Whether to show message timestamps. Defaults to true.
  final bool showTimestamp;

  /// List of example questions to show in the welcome message.
  final List<ExampleQuestion>? exampleQuestions;

  /// Configuration for the welcome message section
  final WelcomeMessageConfig? welcomeMessageConfig;

  /// Default configuration for example questions
  final ExampleQuestionConfig? exampleQuestionConfig;

  /// Custom options for the input field.
  /// Use this to customize the input behavior and appearance.
  /// For example: alwaysShowSend, sendOnEnter, etc.
  final InputOptions inputOptions;

  /// Custom options for message display.
  final MessageOptions? messageOptions;

  /// Custom options for the message list.
  final MessageListOptions? messageListOptions;

  /// Custom options for quick replies.
  final QuickReplyOptions? quickReplyOptions;

  /// Custom options for the scroll-to-bottom button.
  final ScrollToBottomOptions? scrollToBottomOptions;

  /// Whether the chat is in read-only mode. Defaults to false.
  final bool readOnly;

  /// List of users currently typing.
  final List<ChatUser>? typingUsers;

  /// @deprecated Use inputOptions.inputTextStyle instead
  @Deprecated('Use inputOptions.inputTextStyle instead')
  final TextStyle? inputTextStyle;

  /// @deprecated Use inputOptions.inputDecoration instead
  @Deprecated('Use inputOptions.inputDecoration instead')
  final InputDecoration? inputDecoration;

  /// Custom builder for message bubbles.
  final Widget Function(ChatMessage message)? messageBuilder;

  /// Custom builder for the scroll-to-bottom button.
  final Widget Function(ScrollController)? scrollToBottomBuilder;

  /// @deprecated Use inputOptions.sendButtonBuilder instead
  @Deprecated('Use inputOptions.sendButtonBuilder instead')
  final Widget Function(void Function() onSend)? sendButtonBuilder;

  /// @deprecated Use inputOptions.inputDecoration.suffixIcon instead
  @Deprecated('Use inputOptions.inputDecoration.suffixIcon instead')
  final IconData? sendButtonIcon;

  /// @deprecated Configure through inputOptions.inputDecoration.suffixIcon
  @Deprecated('Configure through inputOptions.inputDecoration.suffixIcon')
  final double? sendButtonIconSize;

  /// @deprecated Configure through inputOptions.inputDecoration.suffixIcon
  @Deprecated('Configure through inputOptions.inputDecoration.suffixIcon')
  final EdgeInsets? sendButtonPadding;

  /// Configuration for pagination
  final PaginationConfig paginationConfig;

  /// Configuration for callbacks
  final CallbackConfig callbackConfig;

  /// Configuration for loading states
  final LoadingConfig loadingConfig;

  final bool enableMarkdownStreaming;
  final Duration streamingDuration;
  final MarkdownStyleSheet? markdownStyleSheet;

  /// Creates a copy of this config with the given fields replaced with new values
  AiChatConfig copyWith({
    String? userName,
    String? aiName,
    String? hintText,
    double? maxWidth,
    EdgeInsets? padding,
    bool? enableAnimation,
    bool? showTimestamp,
    List<ExampleQuestion>? exampleQuestions,
    WelcomeMessageConfig? welcomeMessageConfig,
    ExampleQuestionConfig? exampleQuestionConfig,
    InputOptions? inputOptions,
    MessageOptions? messageOptions,
    MessageListOptions? messageListOptions,
    QuickReplyOptions? quickReplyOptions,
    ScrollToBottomOptions? scrollToBottomOptions,
    bool? readOnly,
    List<ChatUser>? typingUsers,
    TextStyle? inputTextStyle,
    InputDecoration? inputDecoration,
    Widget Function(ChatMessage message)? messageBuilder,
    Widget Function(ScrollController)? scrollToBottomBuilder,
    Widget Function(void Function() onSend)? sendButtonBuilder,
    IconData? sendButtonIcon,
    double? sendButtonIconSize,
    EdgeInsets? sendButtonPadding,
    PaginationConfig? paginationConfig,
    CallbackConfig? callbackConfig,
    LoadingConfig? loadingConfig,
    bool? enableMarkdownStreaming,
    Duration? streamingDuration,
    MarkdownStyleSheet? markdownStyleSheet,
  }) =>
      AiChatConfig(
        userName: userName ?? this.userName,
        aiName: aiName ?? this.aiName,
        hintText: hintText ?? this.hintText,
        maxWidth: maxWidth ?? this.maxWidth,
        padding: padding ?? this.padding,
        enableAnimation: enableAnimation ?? this.enableAnimation,
        showTimestamp: showTimestamp ?? this.showTimestamp,
        exampleQuestions: exampleQuestions ?? this.exampleQuestions,
        welcomeMessageConfig: welcomeMessageConfig ?? this.welcomeMessageConfig,
        exampleQuestionConfig:
            exampleQuestionConfig ?? this.exampleQuestionConfig,
        inputOptions: inputOptions ?? this.inputOptions,
        messageOptions: messageOptions ?? this.messageOptions,
        messageListOptions: messageListOptions ?? this.messageListOptions,
        quickReplyOptions: quickReplyOptions ?? this.quickReplyOptions,
        scrollToBottomOptions:
            scrollToBottomOptions ?? this.scrollToBottomOptions,
        readOnly: readOnly ?? this.readOnly,
        typingUsers: typingUsers ?? this.typingUsers,
        inputTextStyle: inputTextStyle ?? this.inputTextStyle,
        inputDecoration: inputDecoration ?? this.inputDecoration,
        messageBuilder: messageBuilder ?? this.messageBuilder,
        scrollToBottomBuilder:
            scrollToBottomBuilder ?? this.scrollToBottomBuilder,
        sendButtonBuilder: sendButtonBuilder ?? this.sendButtonBuilder,
        sendButtonIcon: sendButtonIcon ?? this.sendButtonIcon,
        sendButtonIconSize: sendButtonIconSize ?? this.sendButtonIconSize,
        sendButtonPadding: sendButtonPadding ?? this.sendButtonPadding,
        paginationConfig: paginationConfig ?? this.paginationConfig,
        callbackConfig: callbackConfig ?? this.callbackConfig,
        loadingConfig: loadingConfig ?? this.loadingConfig,
        enableMarkdownStreaming:
            enableMarkdownStreaming ?? this.enableMarkdownStreaming,
        streamingDuration: streamingDuration ?? this.streamingDuration,
        markdownStyleSheet: markdownStyleSheet ?? this.markdownStyleSheet,
      );
}

/// Configuration for pagination behavior
class PaginationConfig {
  const PaginationConfig({
    this.enabled = true,
    this.messagesPerPage = 20,
    this.loadingDelay = const Duration(milliseconds: 500),
    this.scrollThreshold = 0.9,
    this.loadEarlierBuilder,
    this.noMoreMessagesBuilder,
    this.loadingBuilder,
    this.loadEarlierButtonStyle,
    this.loadEarlierIcon = const Icon(Icons.history),
    this.loadEarlierText = 'Load Earlier Messages',
    this.noMoreMessagesText = 'No more messages',
    this.loadingText = 'Loading more messages...',
    this.retryText = 'Retry loading messages',
    this.errorBuilder,
    this.cacheExtent = 1000.0,
    this.keepAliveMessages = true,
    this.reverseOrder = true,
    this.autoLoadOnScroll = true,
    this.distanceToTriggerLoadPixels = 200.0,
    this.enableHapticFeedback = true,
    this.loadMoreDebounceTime = const Duration(milliseconds: 300),
    this.earlierMessagesPosition = EarlierMessagesPosition.top,
  });

  /// Whether pagination is enabled. Defaults to true.
  final bool enabled;

  /// The number of messages to load per page. Defaults to 20.
  final int messagesPerPage;

  /// The delay before loading more messages after triggering. Defaults to 500ms.
  final Duration loadingDelay;

  /// The scroll threshold as a ratio (0.0 to 1.0) to trigger loading more messages.
  /// A value of 0.9 means loading will trigger when the user has scrolled 90% of the way.
  /// Only used when autoLoadOnScroll is true and distanceToTriggerLoadPixels is null.
  final double scrollThreshold;

  /// Custom builder for the "load earlier messages" button.
  final Widget Function(void Function() onLoad, bool isLoading)?
      loadEarlierBuilder;

  /// Custom builder for the "no more messages" indicator.
  final Widget Function()? noMoreMessagesBuilder;

  /// Custom builder for the loading indicator.
  final Widget Function()? loadingBuilder;

  /// Custom style for the "load earlier messages" button.
  final ButtonStyle? loadEarlierButtonStyle;

  /// Icon for the "load earlier messages" button. Defaults to history icon.
  final Icon loadEarlierIcon;

  /// Text for the "load earlier messages" button. Defaults to "Load Earlier Messages".
  final String loadEarlierText;

  /// Text for the "no more messages" indicator. Defaults to "No more messages".
  final String noMoreMessagesText;

  /// Text for the loading indicator. Defaults to "Loading more messages...".
  final String loadingText;

  /// Text for retry button when loading fails. Defaults to "Retry loading messages".
  final String retryText;

  /// Custom builder for error state.
  final Widget Function(String errorMessage, void Function() retry)?
      errorBuilder;

  /// The extent to which the list will cache off-screen items for smoother scrolling.
  /// A higher value means more items will be cached but uses more memory.
  /// Defaults to 1000.0.
  final double cacheExtent;

  /// Whether to keep messages alive when they are offscreen to prevent rebuilding.
  /// Improves performance but uses more memory. Defaults to true.
  final bool keepAliveMessages;

  /// Whether to display messages in reverse order (newest first).
  /// In a chat UI, this is typically true where new messages appear at the bottom.
  /// Defaults to true.
  final bool reverseOrder;

  /// Whether to automatically load more messages when the user scrolls to the
  /// threshold. When false, a button will be shown instead.
  /// Defaults to true.
  final bool autoLoadOnScroll;

  /// The distance in pixels from the edge of the list that triggers loading more messages.
  /// If set, overrides the scrollThreshold percentage.
  /// Defaults to 200.0 pixels.
  final double distanceToTriggerLoadPixels;

  /// Whether to provide haptic feedback when loading more messages.
  /// Defaults to true.
  final bool enableHapticFeedback;

  /// The debounce time for loading more messages to prevent multiple consecutive loads.
  /// Defaults to 300ms.
  final Duration loadMoreDebounceTime;

  /// Where to position earlier messages in the list.
  /// Defaults to EarlierMessagesPosition.top.
  final EarlierMessagesPosition earlierMessagesPosition;

  /// Creates a copy of this configuration with the given fields replaced with new values.
  PaginationConfig copyWith({
    bool? enabled,
    int? messagesPerPage,
    Duration? loadingDelay,
    double? scrollThreshold,
    Widget Function(void Function() onLoad, bool isLoading)? loadEarlierBuilder,
    Widget Function()? noMoreMessagesBuilder,
    Widget Function()? loadingBuilder,
    ButtonStyle? loadEarlierButtonStyle,
    Icon? loadEarlierIcon,
    String? loadEarlierText,
    String? noMoreMessagesText,
    String? loadingText,
    String? retryText,
    Widget Function(String errorMessage, void Function() retry)? errorBuilder,
    double? cacheExtent,
    bool? keepAliveMessages,
    bool? reverseOrder,
    bool? autoLoadOnScroll,
    double? distanceToTriggerLoadPixels,
    bool? enableHapticFeedback,
    Duration? loadMoreDebounceTime,
    EarlierMessagesPosition? earlierMessagesPosition,
  }) =>
      PaginationConfig(
        enabled: enabled ?? this.enabled,
        messagesPerPage: messagesPerPage ?? this.messagesPerPage,
        loadingDelay: loadingDelay ?? this.loadingDelay,
        scrollThreshold: scrollThreshold ?? this.scrollThreshold,
        loadEarlierBuilder: loadEarlierBuilder ?? this.loadEarlierBuilder,
        noMoreMessagesBuilder:
            noMoreMessagesBuilder ?? this.noMoreMessagesBuilder,
        loadingBuilder: loadingBuilder ?? this.loadingBuilder,
        loadEarlierButtonStyle:
            loadEarlierButtonStyle ?? this.loadEarlierButtonStyle,
        loadEarlierIcon: loadEarlierIcon ?? this.loadEarlierIcon,
        loadEarlierText: loadEarlierText ?? this.loadEarlierText,
        noMoreMessagesText: noMoreMessagesText ?? this.noMoreMessagesText,
        loadingText: loadingText ?? this.loadingText,
        retryText: retryText ?? this.retryText,
        errorBuilder: errorBuilder ?? this.errorBuilder,
        cacheExtent: cacheExtent ?? this.cacheExtent,
        keepAliveMessages: keepAliveMessages ?? this.keepAliveMessages,
        reverseOrder: reverseOrder ?? this.reverseOrder,
        autoLoadOnScroll: autoLoadOnScroll ?? this.autoLoadOnScroll,
        distanceToTriggerLoadPixels:
            distanceToTriggerLoadPixels ?? this.distanceToTriggerLoadPixels,
        enableHapticFeedback: enableHapticFeedback ?? this.enableHapticFeedback,
        loadMoreDebounceTime: loadMoreDebounceTime ?? this.loadMoreDebounceTime,
        earlierMessagesPosition:
            earlierMessagesPosition ?? this.earlierMessagesPosition,
      );
}

/// Defines where earlier messages are positioned in the list.
enum EarlierMessagesPosition {
  /// Earlier messages are at the top of the list (standard chat behavior).
  top,

  /// Earlier messages are at the bottom of the list (reverse chat behavior).
  bottom,
}

/// Configuration for loading states in the chat
class LoadingConfig {
  const LoadingConfig({
    this.isLoading = false,
    this.loadingIndicator,
    this.typingIndicatorColor,
    this.typingIndicatorSize = 24.0,
    this.typingIndicatorSpacing = 4.0,
  });

  /// Whether the chat is in loading state
  final bool isLoading;

  /// Custom loading indicator widget
  final Widget? loadingIndicator;

  /// Color of the typing indicator dots
  final Color? typingIndicatorColor;

  /// Size of the typing indicator dots
  final double typingIndicatorSize;

  /// Spacing between typing indicator dots
  final double typingIndicatorSpacing;

  /// Creates a copy with the given fields replaced with new values
  LoadingConfig copyWith({
    bool? isLoading,
    Widget? loadingIndicator,
    Color? typingIndicatorColor,
    double? typingIndicatorSize,
    double? typingIndicatorSpacing,
  }) =>
      LoadingConfig(
        isLoading: isLoading ?? this.isLoading,
        loadingIndicator: loadingIndicator ?? this.loadingIndicator,
        typingIndicatorColor: typingIndicatorColor ?? this.typingIndicatorColor,
        typingIndicatorSize: typingIndicatorSize ?? this.typingIndicatorSize,
        typingIndicatorSpacing:
            typingIndicatorSpacing ?? this.typingIndicatorSpacing,
      );
}

/// Configuration for chat callbacks
class CallbackConfig {
  const CallbackConfig({
    this.onSendButtonPressed,
    this.onClearButtonPressed,
    this.onStopButtonPressed,
    this.onMessageLongPress,
    this.onMessageTap,
    this.onLoadMore,
  });

  /// Called when the send button is pressed
  final void Function(String message)? onSendButtonPressed;

  /// Called when the clear button is pressed
  final void Function()? onClearButtonPressed;

  /// Called when the stop button is pressed
  final void Function()? onStopButtonPressed;

  /// Called when a message is long pressed
  final void Function(ChatMessage message)? onMessageLongPress;

  /// Called when a message is tapped
  final void Function(ChatMessage message)? onMessageTap;

  /// Called when more messages need to be loaded
  final Future<void> Function()? onLoadMore;

  /// Creates a copy with the given fields replaced with new values
  CallbackConfig copyWith({
    void Function(String message)? onSendButtonPressed,
    void Function()? onClearButtonPressed,
    void Function()? onStopButtonPressed,
    void Function(ChatMessage message)? onMessageLongPress,
    void Function(ChatMessage message)? onMessageTap,
    Future<void> Function()? onLoadMore,
  }) =>
      CallbackConfig(
        onSendButtonPressed: onSendButtonPressed ?? this.onSendButtonPressed,
        onClearButtonPressed: onClearButtonPressed ?? this.onClearButtonPressed,
        onStopButtonPressed: onStopButtonPressed ?? this.onStopButtonPressed,
        onMessageLongPress: onMessageLongPress ?? this.onMessageLongPress,
        onMessageTap: onMessageTap ?? this.onMessageTap,
        onLoadMore: onLoadMore ?? this.onLoadMore,
      );
}
