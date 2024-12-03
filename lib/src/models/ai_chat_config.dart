import 'package:flutter/material.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';

class AiChatConfig {
  final String? userName;
  final String? aiName;
  final String? hintText;
  final List<ChatExample>? exampleQuestions;
  final Future<String> Function(String message)? onAiResponse;
  final ThemeData? theme;
  final Widget Function(ScrollController)? scrollToBottomBuilder;
  final Widget Function(ChatMessage)? messageBuilder;
  final Widget? loadingIndicator;
  final InputDecoration? inputDecoration;
  final TextStyle? inputTextStyle;
  final bool enableAnimation;
  final bool showTimestamp;
  final EdgeInsets? padding;
  final double? maxWidth;
  final InputOptions? inputOptions;
  final MessageOptions? messageOptions;
  final MessageListOptions? messageListOptions;
  final QuickReplyOptions? quickReplyOptions;
  final ScrollToBottomOptions? scrollToBottomOptions;
  final bool readOnly;
  final List<ChatUser>? typingUsers;

  const AiChatConfig({
    this.userName,
    this.aiName,
    this.hintText,
    this.exampleQuestions,
    this.onAiResponse,
    this.theme,
    this.scrollToBottomBuilder,
    this.messageBuilder,
    this.loadingIndicator,
    this.inputDecoration,
    this.inputTextStyle,
    this.enableAnimation = true,
    this.showTimestamp = true,
    this.padding,
    this.maxWidth,
    this.inputOptions,
    this.messageOptions,
    this.messageListOptions,
    this.quickReplyOptions,
    this.scrollToBottomOptions,
    this.readOnly = false,
    this.typingUsers,
  });
}
