import 'package:flutter/material.dart';

/// Custom theme extension for the chat UI
class CustomThemeExtension extends ThemeExtension<CustomThemeExtension> {
  const CustomThemeExtension({
    required this.chatBackground,
    required this.backToBottomButtonColor,
    required this.messageBubbleColor,
    required this.userBubbleColor,
    required this.messageTextColor,
    required this.inputBackgroundColor,
    required this.inputBorderColor,
    required this.inputTextColor,
    required this.hintTextColor,
    required this.sendButtonColor,
    required this.sendButtonIconColor,
  });

  final Color chatBackground;
  final Color backToBottomButtonColor;
  final Color messageBubbleColor;
  final Color userBubbleColor;
  final Color messageTextColor;
  final Color inputBackgroundColor;
  final Color inputBorderColor;
  final Color inputTextColor;
  final Color hintTextColor;
  final Color sendButtonColor;
  final Color sendButtonIconColor;

  @override
  ThemeExtension<CustomThemeExtension> copyWith({
    Color? chatBackground,
    Color? backToBottomButtonColor,
    Color? messageBubbleColor,
    Color? userBubbleColor,
    Color? messageTextColor,
    Color? inputBackgroundColor,
    Color? inputBorderColor,
    Color? inputTextColor,
    Color? hintTextColor,
    Color? sendButtonColor,
    Color? sendButtonIconColor,
  }) {
    return CustomThemeExtension(
      chatBackground: chatBackground ?? this.chatBackground,
      backToBottomButtonColor:
          backToBottomButtonColor ?? this.backToBottomButtonColor,
      messageBubbleColor: messageBubbleColor ?? this.messageBubbleColor,
      userBubbleColor: userBubbleColor ?? this.userBubbleColor,
      messageTextColor: messageTextColor ?? this.messageTextColor,
      inputBackgroundColor: inputBackgroundColor ?? this.inputBackgroundColor,
      inputBorderColor: inputBorderColor ?? this.inputBorderColor,
      inputTextColor: inputTextColor ?? this.inputTextColor,
      hintTextColor: hintTextColor ?? this.hintTextColor,
      sendButtonColor: sendButtonColor ?? this.sendButtonColor,
      sendButtonIconColor: sendButtonIconColor ?? this.sendButtonIconColor,
    );
  }

  @override
  ThemeExtension<CustomThemeExtension> lerp(
    covariant ThemeExtension<CustomThemeExtension>? other,
    double t,
  ) {
    if (other is! CustomThemeExtension) {
      return this;
    }
    return CustomThemeExtension(
      chatBackground: Color.lerp(chatBackground, other.chatBackground, t)!,
      backToBottomButtonColor: Color.lerp(
          backToBottomButtonColor, other.backToBottomButtonColor, t)!,
      messageBubbleColor:
          Color.lerp(messageBubbleColor, other.messageBubbleColor, t)!,
      userBubbleColor: Color.lerp(userBubbleColor, other.userBubbleColor, t)!,
      messageTextColor:
          Color.lerp(messageTextColor, other.messageTextColor, t)!,
      inputBackgroundColor:
          Color.lerp(inputBackgroundColor, other.inputBackgroundColor, t)!,
      inputBorderColor:
          Color.lerp(inputBorderColor, other.inputBorderColor, t)!,
      inputTextColor: Color.lerp(inputTextColor, other.inputTextColor, t)!,
      hintTextColor: Color.lerp(hintTextColor, other.hintTextColor, t)!,
      sendButtonColor: Color.lerp(sendButtonColor, other.sendButtonColor, t)!,
      sendButtonIconColor:
          Color.lerp(sendButtonIconColor, other.sendButtonIconColor, t)!,
    );
  }
}
