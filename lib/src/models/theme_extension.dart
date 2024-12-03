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

  CustomThemeExtension({
    required this.messageBubbleColor,
    required this.userBubbleColor,
    required this.messageTextColor,
    required this.inputBackgroundColor,
    required this.inputBorderColor,
    required this.hintTextColor,
    required this.chatBackground,
    required this.backToBottomButtonColor,
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
    );
  }

  static final CustomThemeExtension defaultTheme = CustomThemeExtension(
    messageBubbleColor: const Color(0xFFEEEEEE),
    userBubbleColor: const Color(0xFFBBDEFB),
    messageTextColor: const Color(0xFF212121),
    inputBackgroundColor: Colors.white,
    inputBorderColor: const Color(0xFFE0E0E0),
    hintTextColor: const Color(0xFF757575),
    chatBackground: Colors.white,
    backToBottomButtonColor: Colors.blue,
  );

  static CustomThemeExtension light = CustomThemeExtension(
    messageBubbleColor: const Color(0xFFEEEEEE),
    userBubbleColor: const Color(0xFFBBDEFB),
    messageTextColor: const Color(0xFF212121),
    inputBackgroundColor: Colors.white,
    inputBorderColor: const Color(0xFFE0E0E0),
    hintTextColor: const Color(0xFF757575),
    chatBackground: Colors.white,
    backToBottomButtonColor: Colors.blue,
  );

  static CustomThemeExtension dark = CustomThemeExtension(
    messageBubbleColor: const Color(0xFF424242),
    userBubbleColor: const Color(0xFF0D47A1),
    messageTextColor: Colors.white,
    inputBackgroundColor: const Color(0xFF212121),
    inputBorderColor: const Color(0xFF616161),
    hintTextColor: const Color(0xFFBDBDBD),
    chatBackground: Colors.black,
    backToBottomButtonColor: const Color(0xFF1976D2),
  );
}
