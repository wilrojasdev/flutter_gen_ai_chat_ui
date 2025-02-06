import 'package:flutter/material.dart';

@immutable
class CustomThemeExtension extends ThemeExtension<CustomThemeExtension> {
  final Color? chatBackground;
  final Color? messageBubbleColor;
  final Color? userBubbleColor;
  final Color? messageTextColor;
  final Color? inputBackgroundColor;
  final Color? inputBorderColor;
  final Color? inputTextColor;
  final Color? hintTextColor;
  final Color? backToBottomButtonColor;
  final Color? sendButtonColor;
  final Color? sendButtonIconColor;

  const CustomThemeExtension({
    this.chatBackground,
    this.messageBubbleColor,
    this.userBubbleColor,
    this.messageTextColor,
    this.inputBackgroundColor,
    this.inputBorderColor,
    this.inputTextColor,
    this.hintTextColor,
    this.backToBottomButtonColor,
    this.sendButtonColor,
    this.sendButtonIconColor,
  });

  @override
  CustomThemeExtension copyWith({
    Color? chatBackground,
    Color? messageBubbleColor,
    Color? userBubbleColor,
    Color? messageTextColor,
    Color? inputBackgroundColor,
    Color? inputBorderColor,
    Color? inputTextColor,
    Color? hintTextColor,
    Color? backToBottomButtonColor,
    Color? sendButtonColor,
    Color? sendButtonIconColor,
  }) {
    return CustomThemeExtension(
      chatBackground: chatBackground ?? this.chatBackground,
      messageBubbleColor: messageBubbleColor ?? this.messageBubbleColor,
      userBubbleColor: userBubbleColor ?? this.userBubbleColor,
      messageTextColor: messageTextColor ?? this.messageTextColor,
      inputBackgroundColor: inputBackgroundColor ?? this.inputBackgroundColor,
      inputBorderColor: inputBorderColor ?? this.inputBorderColor,
      inputTextColor: inputTextColor ?? this.inputTextColor,
      hintTextColor: hintTextColor ?? this.hintTextColor,
      backToBottomButtonColor:
          backToBottomButtonColor ?? this.backToBottomButtonColor,
      sendButtonColor: sendButtonColor ?? this.sendButtonColor,
      sendButtonIconColor: sendButtonIconColor ?? this.sendButtonIconColor,
    );
  }

  @override
  CustomThemeExtension lerp(
      ThemeExtension<CustomThemeExtension>? other, double t) {
    if (other is! CustomThemeExtension) return this;
    return CustomThemeExtension(
      chatBackground: Color.lerp(chatBackground, other.chatBackground, t),
      messageBubbleColor:
          Color.lerp(messageBubbleColor, other.messageBubbleColor, t),
      userBubbleColor: Color.lerp(userBubbleColor, other.userBubbleColor, t),
      messageTextColor: Color.lerp(messageTextColor, other.messageTextColor, t),
      inputBackgroundColor:
          Color.lerp(inputBackgroundColor, other.inputBackgroundColor, t),
      inputBorderColor: Color.lerp(inputBorderColor, other.inputBorderColor, t),
      inputTextColor: Color.lerp(inputTextColor, other.inputTextColor, t),
      hintTextColor: Color.lerp(hintTextColor, other.hintTextColor, t),
      backToBottomButtonColor:
          Color.lerp(backToBottomButtonColor, other.backToBottomButtonColor, t),
      sendButtonColor: Color.lerp(sendButtonColor, other.sendButtonColor, t),
      sendButtonIconColor:
          Color.lerp(sendButtonIconColor, other.sendButtonIconColor, t),
    );
  }
}
