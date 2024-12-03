import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDark = false;
  bool get isDark => _isDark;

  ThemeData get theme => _isDark ? darkTheme : lightTheme;

  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black87),
    ),
    scaffoldBackgroundColor: Colors.white,
    extensions: [
      CustomThemeExtension(
        chatBackground: Colors.white,
        messageBubbleColor: const Color(0xFFF0F0F0),
        userBubbleColor: const Color(0xFFE3F2FD),
        messageTextColor: Colors.black87,
        inputBackgroundColor: const Color(0xFFF5F5F5),
        inputBorderColor: const Color(0xFFE0E0E0),
        hintTextColor: Colors.grey[400]!,
        backToBottomButtonColor: Colors.grey[800]!,
      ),
    ],
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1A1A1A),
      foregroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
    ),
    scaffoldBackgroundColor: const Color(0xFF1A1A1A),
    extensions: [
      CustomThemeExtension(
        chatBackground: const Color(0xFF1A1A1A),
        messageBubbleColor: const Color(0xFF2D2D2D),
        userBubbleColor: const Color(0xFF1E3A5F),
        messageTextColor: Colors.white,
        inputBackgroundColor: const Color(0xFF2D2D2D),
        inputBorderColor: const Color(0xFF404040),
        hintTextColor: Colors.grey[600]!,
        backToBottomButtonColor: Colors.grey[300]!,
      ),
    ],
  );

  void toggleTheme() {
    _isDark = !_isDark;
    notifyListeners();
  }
}

class CustomThemeExtension extends ThemeExtension<CustomThemeExtension> {
  final Color chatBackground;
  final Color messageBubbleColor;
  final Color userBubbleColor;
  final Color messageTextColor;
  final Color inputBackgroundColor;
  final Color inputBorderColor;
  final Color hintTextColor;
  final Color backToBottomButtonColor;

  CustomThemeExtension({
    required this.chatBackground,
    required this.messageBubbleColor,
    required this.userBubbleColor,
    required this.messageTextColor,
    required this.inputBackgroundColor,
    required this.inputBorderColor,
    required this.hintTextColor,
    required this.backToBottomButtonColor,
  });

  @override
  ThemeExtension<CustomThemeExtension> copyWith({
    Color? chatBackground,
    Color? messageBubbleColor,
    Color? userBubbleColor,
    Color? messageTextColor,
    Color? inputBackgroundColor,
    Color? inputBorderColor,
    Color? hintTextColor,
    Color? backToBottomButtonColor,
  }) {
    return CustomThemeExtension(
      chatBackground: chatBackground ?? this.chatBackground,
      messageBubbleColor: messageBubbleColor ?? this.messageBubbleColor,
      userBubbleColor: userBubbleColor ?? this.userBubbleColor,
      messageTextColor: messageTextColor ?? this.messageTextColor,
      inputBackgroundColor: inputBackgroundColor ?? this.inputBackgroundColor,
      inputBorderColor: inputBorderColor ?? this.inputBorderColor,
      hintTextColor: hintTextColor ?? this.hintTextColor,
      backToBottomButtonColor:
          backToBottomButtonColor ?? this.backToBottomButtonColor,
    );
  }

  @override
  ThemeExtension<CustomThemeExtension> lerp(
    ThemeExtension<CustomThemeExtension>? other,
    double t,
  ) {
    if (other is! CustomThemeExtension) return this;
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
      hintTextColor: Color.lerp(hintTextColor, other.hintTextColor, t)!,
      backToBottomButtonColor: Color.lerp(
          backToBottomButtonColor, other.backToBottomButtonColor, t)!,
    );
  }
}
