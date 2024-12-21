import 'package:flutter/material.dart';

class CustomThemeExtension extends ThemeExtension<CustomThemeExtension> {
  final Color messageBubbleColor;
  final Color userBubbleColor;
  final Color messageTextColor;
  final Color inputBackgroundColor;
  final Color inputBorderColor;
  final Color hintTextColor;
  final Color chatBackground;
  final Color backToBottomButtonColor;
  final Color sendButtonColor;
  final Color sendButtonIconColor;

  CustomThemeExtension({
    required this.messageBubbleColor,
    required this.userBubbleColor,
    required this.messageTextColor,
    required this.inputBackgroundColor,
    required this.inputBorderColor,
    required this.hintTextColor,
    required this.chatBackground,
    required this.backToBottomButtonColor,
    required this.sendButtonColor,
    required this.sendButtonIconColor,
  });

  @override
  ThemeExtension<CustomThemeExtension> copyWith({
    Color? messageBubbleColor,
    Color? userBubbleColor,
    Color? messageTextColor,
    Color? inputBackgroundColor,
    Color? inputBorderColor,
    Color? hintTextColor,
    Color? chatBackground,
    Color? backToBottomButtonColor,
    Color? sendButtonColor,
    Color? sendButtonIconColor,
  }) {
    return CustomThemeExtension(
      messageBubbleColor: messageBubbleColor ?? this.messageBubbleColor,
      userBubbleColor: userBubbleColor ?? this.userBubbleColor,
      messageTextColor: messageTextColor ?? this.messageTextColor,
      inputBackgroundColor: inputBackgroundColor ?? this.inputBackgroundColor,
      inputBorderColor: inputBorderColor ?? this.inputBorderColor,
      hintTextColor: hintTextColor ?? this.hintTextColor,
      chatBackground: chatBackground ?? this.chatBackground,
      backToBottomButtonColor:
          backToBottomButtonColor ?? this.backToBottomButtonColor,
      sendButtonColor: sendButtonColor ?? this.sendButtonColor,
      sendButtonIconColor: sendButtonIconColor ?? this.sendButtonIconColor,
    );
  }

  @override
  ThemeExtension<CustomThemeExtension> lerp(
    ThemeExtension<CustomThemeExtension>? other,
    double t,
  ) {
    if (other is! CustomThemeExtension) {
      return this;
    }
    return CustomThemeExtension(
      messageBubbleColor:
          Color.lerp(messageBubbleColor, other.messageBubbleColor, t)!,
      userBubbleColor: Color.lerp(userBubbleColor, other.userBubbleColor, t)!,
      messageTextColor:
          Color.lerp(messageTextColor, other.messageTextColor, t)!,
      inputBackgroundColor:
          Color.lerp(inputBackgroundColor, other.inputBackgroundColor, t)!,
      inputBorderColor:
          Color.lerp(inputBorderColor, other.inputBorderColor, t)!,
      hintTextColor: Color.lerp(hintTextColor, other.hintTextColor, t)!,
      chatBackground: Color.lerp(chatBackground, other.chatBackground, t)!,
      backToBottomButtonColor: Color.lerp(
          backToBottomButtonColor, other.backToBottomButtonColor, t)!,
      sendButtonColor: Color.lerp(sendButtonColor, other.sendButtonColor, t)!,
      sendButtonIconColor:
          Color.lerp(sendButtonIconColor, other.sendButtonIconColor, t)!,
    );
  }

  static final CustomThemeExtension defaultTheme = CustomThemeExtension(
    messageBubbleColor: const Color(0xFF2C2C2E),
    userBubbleColor: const Color(0xFF0A84FF).withOpacity(0.2),
    messageTextColor: Colors.white.withOpacity(0.95),
    inputBackgroundColor: const Color(0xFF1C1C1E),
    inputBorderColor: const Color(0xFF3C3C3E),
    hintTextColor: Colors.white.withOpacity(0.6),
    chatBackground: const Color(0xFF000000),
    backToBottomButtonColor: const Color(0xFF0A84FF),
    sendButtonColor: Colors.transparent,
    sendButtonIconColor: const Color(0xFF0A84FF),
  );

  static CustomThemeExtension light = CustomThemeExtension(
    messageBubbleColor: const Color(0xFFF7F7F8),
    userBubbleColor: const Color(0xFFEEEEF0),
    messageTextColor: const Color(0xFF111111),
    inputBackgroundColor: Colors.white,
    inputBorderColor: const Color(0xFFE5E5E7),
    hintTextColor: const Color(0xFF6B6C7B),
    chatBackground: Colors.white,
    backToBottomButtonColor: const Color(0xFF10A37F),
    sendButtonColor: Colors.transparent,
    sendButtonIconColor: const Color(0xFF10A37F),
  );

  static CustomThemeExtension dark = CustomThemeExtension(
    messageBubbleColor: const Color(0xFF2A2B32),
    userBubbleColor: const Color(0xFF343541),
    messageTextColor: const Color(0xFFECECF1),
    inputBackgroundColor: const Color(0xFF343541),
    inputBorderColor: const Color(0xFF40414F),
    hintTextColor: const Color(0xFF8E8EA0),
    chatBackground: const Color(0xFF1F1F28),
    backToBottomButtonColor: const Color(0xFF10A37F),
    sendButtonColor: Colors.transparent,
    sendButtonIconColor: const Color(0xFF10A37F),
  );
}
