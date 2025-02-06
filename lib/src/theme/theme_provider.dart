import 'package:flutter/material.dart';
import 'package:flutter_gen_ai_chat_ui/src/theme/custom_theme.dart';

/// Provider class for theme-related functionality
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void toggleTheme() {
    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    if (_themeMode != mode) {
      _themeMode = mode;
      notifyListeners();
    }
  }

  static ThemeData get lightTheme => ThemeData.light().copyWith(
        extensions: [
          CustomThemeExtension(
            chatBackground: Colors.white,
            backToBottomButtonColor: Colors.grey[800]!,
            messageBubbleColor: const Color(0xFFF7F7F8),
            userBubbleColor: const Color(0xFF10A37F),
            messageTextColor: const Color(0xFF353740),
            inputBackgroundColor: Colors.white,
            inputBorderColor: const Color(0xFFD9D9E3),
            inputTextColor: const Color(0xFF353740),
            hintTextColor: const Color(0xFF8E8EA0),
            sendButtonColor: Colors.transparent,
            sendButtonIconColor: const Color(0xFF10A37F),
          ),
        ],
      );

  static ThemeData get darkTheme => ThemeData.dark().copyWith(
        extensions: [
          CustomThemeExtension(
            chatBackground: const Color(0xFF1A1A1A),
            backToBottomButtonColor: Colors.grey[300]!,
            messageBubbleColor: const Color(0xFF2A2A2A),
            userBubbleColor: Colors.blue,
            messageTextColor: Colors.white,
            inputBackgroundColor: const Color(0xFF2A2A2A),
            inputBorderColor: Colors.grey[700]!,
            inputTextColor: Colors.white,
            hintTextColor: Colors.grey[400]!,
            sendButtonColor: Colors.transparent,
            sendButtonIconColor: Colors.blue,
          ),
        ],
      );
}
