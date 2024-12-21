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
        inputTextColor: Colors.black87,
        hintTextColor: Colors.grey[400]!,
        backToBottomButtonColor: Colors.grey[800]!,
        sendButtonColor: Colors.grey[800]!,
        sendButtonIconColor: Colors.white,
      ),
    ],
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF1A1A1A),
      foregroundColor: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.black26,
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    scaffoldBackgroundColor: const Color(0xFF1A1A1A),
    extensions: [
      CustomThemeExtension(
        chatBackground: const Color(0xFF1A1A1A),
        messageBubbleColor: const Color(0xFF2A2A2A),
        userBubbleColor: const Color(0xFF0D47A1),
        messageTextColor: const Color(0xFFEEEEEE),
        inputBackgroundColor: const Color(0xFF242424),
        inputBorderColor: const Color(0xFF3D3D3D),
        inputTextColor: const Color(0xFFE5E5E5),
        hintTextColor: const Color(0xFF9E9E9E),
        backToBottomButtonColor: const Color(0xFF64B5F6),
        sendButtonColor: const Color(0xFF64B5F6),
        sendButtonIconColor: Colors.white,
      ),
    ],
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF0D47A1),
        foregroundColor: Colors.white,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
      ),
    ),
    cardTheme: CardTheme(
      color: const Color(0xFF242424),
      elevation: 4,
      shadowColor: Colors.black38,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
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
  final Color inputTextColor;
  final Color hintTextColor;
  final Color backToBottomButtonColor;
  final Color sendButtonColor;
  final Color sendButtonIconColor;

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

  @override
  ThemeExtension<CustomThemeExtension> copyWith({
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
  ThemeExtension<CustomThemeExtension> lerp(
    ThemeExtension<CustomThemeExtension>? other,
    double t,
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
          backToBottomButtonColor, other.backToBottomButtonColor, t)!,
      sendButtonColor: Color.lerp(sendButtonColor, other.sendButtonColor, t)!,
      sendButtonIconColor:
          Color.lerp(sendButtonIconColor, other.sendButtonIconColor, t)!,
    );
  }
}
