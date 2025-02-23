import 'package:flutter/material.dart';
import 'custom_theme_extension.dart';

/// Provider class for theme-related functionality
class ThemeProvider extends ChangeNotifier {
  bool _isDark = false;
  bool get isDark => _isDark;

  ThemeData get theme => _isDark ? darkTheme : lightTheme;

  static ThemeData get lightTheme =>
      ThemeData.light(useMaterial3: true).copyWith(
        extensions: <ThemeExtension<dynamic>>[
          const CustomThemeExtension(
            chatBackground: Colors.white,
            messageBubbleColor: Colors.white,
            userBubbleColor: Color(0xFFE3F2FD),
            messageTextColor: Colors.black87,
            inputBackgroundColor: Colors.white,
            inputBorderColor: Color(0xFFE0E0E0),
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
          const CustomThemeExtension(
            chatBackground: Color(0xFF171717),
            messageBubbleColor: Color(0xFF262626),
            userBubbleColor: Color(0xFF1A4B8F),
            messageTextColor: Color(0xFFE5E5E5),
            inputBackgroundColor: Color(0xFF262626),
            inputBorderColor: Color(0xFF404040),
            inputTextColor: Colors.white,
            hintTextColor: Color(0xFF9CA3AF),
            backToBottomButtonColor: Color(0xFF60A5FA),
            sendButtonColor: Colors.transparent,
            sendButtonIconColor: Color(0xFF60A5FA),
          ),
        ],
      );

  void toggleTheme() {
    _isDark = !_isDark;
    notifyListeners();
  }
}
