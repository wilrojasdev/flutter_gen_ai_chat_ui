import 'package:dash_chat_2/dash_chat_2.dart' as dash;
import 'package:flutter/material.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';

/// Configuration class for customizing the AI chat interface.
///
/// This class provides extensive customization options for the chat UI,
/// including themes, animations, input styling, and message display options.
/// All configurations should be passed through this class to maintain
/// a single source of configuration.
class AiChatConfig {
  const AiChatConfig({
    this.userName = 'User',
    this.aiName = 'AI',
    this.hintText = 'Type a message...',
    this.maxWidth,
    this.padding,
    this.enableAnimation = true,
    this.showTimestamp = true,
    this.exampleQuestions = const [],
    // Welcome message configuration
    this.welcomeMessageConfig,
    this.exampleQuestionConfig,
    // DashChat options
    this.inputOptions,
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
    @Deprecated('Use paginationConfig instead') this.enablePagination = false,
    @Deprecated('Use paginationConfig instead')
    this.paginationLoadingIndicatorOffset = 100,
    @Deprecated('Use paginationConfig instead') this.loadMoreIndicator,
    this.paginationConfig = const PaginationConfig(),
    @Deprecated('Use callbackConfig.onSendButtonPressed instead')
    this.onSendButtonPressed,
    @Deprecated('Use callbackConfig.onClearButtonPressed instead')
    this.onClearButtonPressed,
    @Deprecated('Use callbackConfig.onStopButtonPressed instead')
    this.onStopButtonPressed,
    // Loading state
    @Deprecated('Use loadingConfig.isLoading instead') this.isLoading = false,
    @Deprecated('Use loadingConfig.loadingIndicator instead')
    this.loadingIndicator,
    this.loadingConfig = const LoadingConfig(),
    this.callbackConfig = const CallbackConfig(),
  });

  /// The name of the user in the chat interface.
  final String userName;

  /// The name of the AI assistant in the chat interface.
  final String aiName;

  /// Placeholder text for the input field.
  final String hintText;

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
  final dash.InputOptions? inputOptions;

  /// Custom options for message display.
  final dash.MessageOptions? messageOptions;

  /// Custom options for the message list.
  final dash.MessageListOptions? messageListOptions;

  /// Custom options for quick replies.
  final dash.QuickReplyOptions? quickReplyOptions;

  /// Custom options for the scroll-to-bottom button.
  final dash.ScrollToBottomOptions? scrollToBottomOptions;

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

  /// @deprecated Use paginationConfig.enabled instead
  @Deprecated('Use paginationConfig.enabled instead')
  final bool enablePagination;

  /// @deprecated Use paginationConfig.loadingIndicatorOffset instead
  @Deprecated('Use paginationConfig.loadingIndicatorOffset instead')
  final double paginationLoadingIndicatorOffset;

  /// @deprecated Use paginationConfig.loadMoreIndicator instead
  @Deprecated('Use paginationConfig.loadMoreIndicator instead')
  final Widget Function({bool isLoading})? loadMoreIndicator;

  /// Configuration for callbacks
  final CallbackConfig callbackConfig;

  /// @deprecated Use callbackConfig.onSendButtonPressed instead
  @Deprecated('Use callbackConfig.onSendButtonPressed instead')
  final void Function(String message)? onSendButtonPressed;

  /// @deprecated Use callbackConfig.onClearButtonPressed instead
  @Deprecated('Use callbackConfig.onClearButtonPressed instead')
  final void Function()? onClearButtonPressed;

  /// @deprecated Use callbackConfig.onStopButtonPressed instead
  @Deprecated('Use callbackConfig.onStopButtonPressed instead')
  final void Function()? onStopButtonPressed;

  /// Configuration for loading states
  final LoadingConfig loadingConfig;

  /// @deprecated Use loadingConfig.isLoading instead
  @Deprecated('Use loadingConfig.isLoading instead')
  final bool isLoading;

  /// @deprecated Use loadingConfig.loadingIndicator instead
  @Deprecated('Use loadingConfig.loadingIndicator instead')
  final Widget? loadingIndicator;

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
    dash.InputOptions? inputOptions,
    dash.MessageOptions? messageOptions,
    dash.MessageListOptions? messageListOptions,
    dash.QuickReplyOptions? quickReplyOptions,
    dash.ScrollToBottomOptions? scrollToBottomOptions,
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
    bool? enablePagination,
    double? paginationLoadingIndicatorOffset,
    Widget Function({bool isLoading})? loadMoreIndicator,
    void Function(String message)? onSendButtonPressed,
    void Function()? onClearButtonPressed,
    void Function()? onStopButtonPressed,
    bool? isLoading,
    Widget? loadingIndicator,
    LoadingConfig? loadingConfig,
    CallbackConfig? callbackConfig,
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
        enablePagination: enablePagination ?? this.enablePagination,
        paginationLoadingIndicatorOffset: paginationLoadingIndicatorOffset ??
            this.paginationLoadingIndicatorOffset,
        loadMoreIndicator: loadMoreIndicator ?? this.loadMoreIndicator,
        onSendButtonPressed: onSendButtonPressed ?? this.onSendButtonPressed,
        onClearButtonPressed: onClearButtonPressed ?? this.onClearButtonPressed,
        onStopButtonPressed: onStopButtonPressed ?? this.onStopButtonPressed,
        isLoading: isLoading ?? this.isLoading,
        loadingIndicator: loadingIndicator ?? this.loadingIndicator,
        loadingConfig: loadingConfig ?? this.loadingConfig,
        callbackConfig: callbackConfig ?? this.callbackConfig,
      );
}

/// Configuration for chat message pagination
class PaginationConfig {
  const PaginationConfig({
    this.enabled = false,
    this.loadingIndicatorOffset = 100,
    this.loadMoreIndicator,
  });

  /// Whether pagination is enabled
  final bool enabled;

  /// Offset from bottom to trigger pagination loading
  final double loadingIndicatorOffset;

  /// Custom loading indicator widget builder
  final Widget Function({bool isLoading})? loadMoreIndicator;

  /// Creates a copy with the given fields replaced with new values
  PaginationConfig copyWith({
    bool? enabled,
    double? loadingIndicatorOffset,
    Widget Function({bool isLoading})? loadMoreIndicator,
  }) =>
      PaginationConfig(
        enabled: enabled ?? this.enabled,
        loadingIndicatorOffset:
            loadingIndicatorOffset ?? this.loadingIndicatorOffset,
        loadMoreIndicator: loadMoreIndicator ?? this.loadMoreIndicator,
      );
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
