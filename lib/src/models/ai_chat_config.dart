import 'package:flutter/material.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';

class AiChatConfig {
  // Basic configuration
  final String? userName;
  final String? aiName;
  final String? hintText;
  final double? maxWidth;
  final EdgeInsets? padding;
  final bool enableAnimation;
  final bool showTimestamp;
  final List<ChatExample>? exampleQuestions;

  // DashChat specific configurations
  final InputOptions? inputOptions;
  final MessageOptions? messageOptions;
  final MessageListOptions? messageListOptions;
  final QuickReplyOptions? quickReplyOptions;
  final ScrollToBottomOptions? scrollToBottomOptions;
  final bool readOnly;
  final List<ChatUser>? typingUsers;

  // UI Customization
  final TextStyle? inputTextStyle;
  final InputDecoration? inputDecoration;
  final Widget Function(ChatMessage message)? messageBuilder;
  final Widget Function(ScrollController)? scrollToBottomBuilder;

  // Pagination configuration
  final bool enablePagination;
  final double paginationLoadingIndicatorOffset;
  final Widget Function(bool isLoading)?
      loadMoreIndicator; // Changed to match dash_chat_2's API

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
    // Pagination options
    this.enablePagination = false,
    this.paginationLoadingIndicatorOffset = 100,
    this.loadMoreIndicator,
  });

  // Create a copy with method for easy modification
  AiChatConfig copyWith({
    // Add all properties here
    String? userName,
    String? aiName,
    String? hintText,
    double? maxWidth,
    EdgeInsets? padding,
    bool? enableAnimation,
    bool? showTimestamp,
    List<ChatExample>? exampleQuestions,
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
    bool? enablePagination,
    double? paginationLoadingIndicatorOffset,
    Widget Function(bool isLoading)?
        loadMoreIndicator, // Changed to match dash_chat_2's API
  }) {
    return AiChatConfig(
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
      enablePagination: enablePagination ?? this.enablePagination,
      paginationLoadingIndicatorOffset: paginationLoadingIndicatorOffset ??
          this.paginationLoadingIndicatorOffset,
      loadMoreIndicator: loadMoreIndicator ?? this.loadMoreIndicator,
    );
  }
}
