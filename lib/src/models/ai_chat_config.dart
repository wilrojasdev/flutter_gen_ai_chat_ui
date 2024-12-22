import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';

/// Configuration class for customizing the AI chat interface.
///
/// This class provides extensive customization options for the chat UI,
/// including themes, animations, input styling, and message display options.
class AiChatConfig {
  const AiChatConfig({
    this.userName,
    this.aiName,
    this.hintText,
    this.maxWidth,
    this.padding,
    this.enableAnimation = true,
    this.showTimestamp = true,
    this.exampleQuestions,
    // DashChat options
    this.inputOptions,
    this.messageOptions,
    this.messageListOptions,
    this.quickReplyOptions,
    this.scrollToBottomOptions,
    this.readOnly = false,
    this.typingUsers,
    // UI options
    this.inputTextStyle,
    this.inputDecoration,
    this.messageBuilder,
    this.scrollToBottomBuilder,
    this.sendButtonBuilder,
    this.sendButtonIcon,
    this.sendButtonIconSize,
    this.sendButtonPadding,
    // Pagination options
    this.enablePagination = false,
    this.paginationLoadingIndicatorOffset = 100,
    this.loadMoreIndicator,
    this.onSendButtonPressed,
    this.onClearButtonPressed,
    this.onStopButtonPressed,
  });

  /// The name of the user in the chat interface.
  final String? userName;

  /// The name of the AI assistant in the chat interface.
  final String? aiName;

  /// Placeholder text for the input field.
  final String? hintText;

  /// Maximum width of the chat interface. If null, takes full width.
  final double? maxWidth;

  /// Padding around the chat interface.
  final EdgeInsets? padding;

  /// Whether to enable message animations. Defaults to true.
  final bool enableAnimation;

  /// Whether to show message timestamps. Defaults to true.
  final bool showTimestamp;

  /// List of example questions to show in the welcome message.
  final List<ChatExample>? exampleQuestions;

  /// Custom options for the input field.
  final InputOptions? inputOptions;

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

  /// Custom style for the input text.
  final TextStyle? inputTextStyle;

  /// Custom decoration for the input field.
  final InputDecoration? inputDecoration;

  /// Custom builder for message bubbles.
  final Widget Function(ChatMessage message)? messageBuilder;

  /// Custom builder for the scroll-to-bottom button.
  final Widget Function(ScrollController)? scrollToBottomBuilder;

  /// Custom builder for the send button.
  final Widget Function(void Function() onSend)? sendButtonBuilder;

  /// Custom icon for the send button.
  final IconData? sendButtonIcon;

  /// Custom size for the send button icon.
  final double? sendButtonIconSize;

  /// Custom padding for the send button.
  final EdgeInsets? sendButtonPadding;

  /// Whether to enable message pagination. Defaults to false.
  final bool enablePagination;

  /// Offset to trigger pagination loading.
  final double paginationLoadingIndicatorOffset;

  /// Custom builder for the pagination loading indicator.
  final Widget Function({bool isLoading})? loadMoreIndicator;

  /// Callback function when the send button is pressed
  final void Function(String message)? onSendButtonPressed;

  /// Callback function when the clear button is pressed
  final void Function()? onClearButtonPressed;

  /// Callback function when the stop button is pressed
  final void Function()? onStopButtonPressed;

  // Create a copy with method for easy modification
  AiChatConfig copyWith({
    final String? userName,
    final String? aiName,
    final String? hintText,
    final double? maxWidth,
    final EdgeInsets? padding,
    final bool? enableAnimation,
    final bool? showTimestamp,
    final List<ChatExample>? exampleQuestions,
    final InputOptions? inputOptions,
    final MessageOptions? messageOptions,
    final MessageListOptions? messageListOptions,
    final QuickReplyOptions? quickReplyOptions,
    final ScrollToBottomOptions? scrollToBottomOptions,
    final bool? readOnly,
    final List<ChatUser>? typingUsers,
    final TextStyle? inputTextStyle,
    final InputDecoration? inputDecoration,
    final Widget Function(ChatMessage message)? messageBuilder,
    final Widget Function(ScrollController)? scrollToBottomBuilder,
    final Widget Function(void Function() onSend)? sendButtonBuilder,
    final IconData? sendButtonIcon,
    final double? sendButtonIconSize,
    final EdgeInsets? sendButtonPadding,
    final bool? enablePagination,
    final double? paginationLoadingIndicatorOffset,
    final Widget Function({bool isLoading})? loadMoreIndicator,
    final void Function(String message)? onSendButtonPressed,
    final void Function()? onClearButtonPressed,
    final void Function()? onStopButtonPressed,
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
      );
}
