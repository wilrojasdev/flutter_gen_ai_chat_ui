import 'package:flutter/material.dart';

/// A custom theme extension for the chat UI.
class CustomThemeExtension extends ThemeExtension<CustomThemeExtension> {
  /// Creates a custom theme extension.
  const CustomThemeExtension({
    required this.chatBackground,
    required this.messageBubbleColor,
    required this.userBubbleColor,
    required this.messageTextColor,
    required this.inputBackgroundColor,
    required this.inputBorderColor,
    required this.inputTextColor,
    required this.hintTextColor,
    required this.backToBottomButtonColor,
    required this.sendButtonColor,
    required this.sendButtonIconColor,
  });

  /// The color of the chat background.
  final Color chatBackground;

  /// The color of the message bubbles.
  final Color messageBubbleColor;

  /// The color of the user's message bubbles.
  final Color userBubbleColor;

  /// The color of the message text.
  final Color messageTextColor;

  /// The color of the input field background.
  final Color inputBackgroundColor;

  /// The color of the input field border.
  final Color inputBorderColor;

  /// The color of the input field text.
  final Color inputTextColor;

  /// The color of the hint text.
  final Color hintTextColor;

  /// The color of the back-to-bottom button.
  final Color backToBottomButtonColor;

  /// The color of the send button.
  final Color sendButtonColor;

  /// The color of the send button icon.
  final Color sendButtonIconColor;

  /// Light theme colors.
  static const light = CustomThemeExtension(
    chatBackground: Colors.white,
    messageBubbleColor: Color(0xFFF7F7F8),
    userBubbleColor: Color(0xFF10A37F),
    messageTextColor: Color(0xFF111111),
    inputBackgroundColor: Color(0xFFF7F7F8),
    inputBorderColor: Color(0xFFE5E5E7),
    inputTextColor: Color(0xFF111111),
    hintTextColor: Color(0xFF6B6C7B),
    backToBottomButtonColor: Color(0xFF10A37F),
    sendButtonColor: Color(0xFF10A37F),
    sendButtonIconColor: Colors.white,
  );

  /// Dark theme colors.
  static const dark = CustomThemeExtension(
    chatBackground: Color(0xFF1F1F28),
    messageBubbleColor: Color(0xFF2A2B32),
    userBubbleColor: Color(0xFF10A37F),
    messageTextColor: Color(0xFFECECF1),
    inputBackgroundColor: Color(0xFF2A2B32),
    inputBorderColor: Color(0xFF40414F),
    inputTextColor: Color(0xFFECECF1),
    hintTextColor: Color(0xFF8E8EA0),
    backToBottomButtonColor: Color(0xFF10A37F),
    sendButtonColor: Color(0xFF10A37F),
    sendButtonIconColor: Colors.white,
  );

  @override
  ThemeExtension<CustomThemeExtension> copyWith({
    final Color? chatBackground,
    final Color? messageBubbleColor,
    final Color? userBubbleColor,
    final Color? messageTextColor,
    final Color? inputBackgroundColor,
    final Color? inputBorderColor,
    final Color? inputTextColor,
    final Color? hintTextColor,
    final Color? backToBottomButtonColor,
    final Color? sendButtonColor,
    final Color? sendButtonIconColor,
  }) =>
      CustomThemeExtension(
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

  @override
  ThemeExtension<CustomThemeExtension> lerp(
    covariant final ThemeExtension<CustomThemeExtension>? other,
    final double t,
  ) {
    if (other is! CustomThemeExtension) {
      return this;
    }

    return CustomThemeExtension(
      chatBackground: Color.lerp(chatBackground, other.chatBackground, t)!,
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
      backToBottomButtonColor: Color.lerp(
        backToBottomButtonColor,
        other.backToBottomButtonColor,
        t,
      )!,
      sendButtonColor: Color.lerp(sendButtonColor, other.sendButtonColor, t)!,
      sendButtonIconColor:
          Color.lerp(sendButtonIconColor, other.sendButtonIconColor, t)!,
    );
  }
}
