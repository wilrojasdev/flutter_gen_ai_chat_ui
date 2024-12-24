import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDark = false;
  bool get isDark => _isDark;

  ThemeData get theme => _isDark ? darkTheme : lightTheme;

  static ThemeData get lightTheme =>
      ThemeData.light(useMaterial3: true).copyWith(
        extensions: <ThemeExtension<dynamic>>[
          CustomThemeExtension(
            chatBackground: Colors.white,
            messageBubbleColor: Colors.white,
            userBubbleColor: const Color(0xFFE3F2FD),
            messageTextColor: Colors.black87,
            inputBackgroundColor: Colors.white,
            inputBorderColor: const Color(0xFFE0E0E0),
            inputTextColor: Colors.black87,
            hintTextColor: Colors.black54,
            backToBottomButtonColor: Colors.blue,
            sendButtonColor: Colors.transparent,
            sendButtonIconColor: Colors.blue,
          ),
        ],
      );

  static ThemeData get darkTheme => ThemeData.dark(useMaterial3: true).copyWith(
        extensions: <ThemeExtension<dynamic>>[
          CustomThemeExtension(
            chatBackground: const Color(0xFF171717),
            messageBubbleColor: const Color(0xFF262626),
            userBubbleColor: const Color(0xFF1A4B8F),
            messageTextColor: const Color(0xFFE5E5E5),
            inputBackgroundColor: const Color(0xFF262626),
            inputBorderColor: const Color(0xFF404040),
            inputTextColor: Colors.white,
            hintTextColor: const Color(0xFF9CA3AF),
            backToBottomButtonColor: const Color(0xFF60A5FA),
            sendButtonColor: Colors.transparent,
            sendButtonIconColor: const Color(0xFF60A5FA),
          ),
        ],
      );

  void toggleTheme() {
    _isDark = !_isDark;
    notifyListeners();
  }
}

class CustomThemeExtension extends ThemeExtension<CustomThemeExtension> {
  CustomThemeExtension({
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
  final Color chatBackground;
  final Color messageBubbleColor;
  final Color userBubbleColor;
  final Color messageTextColor;
  final Color inputBackgroundColor;
  final Color inputBorderColor;
  final Color inputTextColor;
  final Color hintTextColor;
  final Color backToBottomButtonColor;
  final Color sendButtonColor;
  final Color sendButtonIconColor;

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
    final ThemeExtension<CustomThemeExtension>? other,
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
