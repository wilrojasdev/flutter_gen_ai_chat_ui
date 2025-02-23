import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDark = false;
  bool get isDark => _isDark;

  ThemeData get theme => _isDark ? darkTheme : lightTheme;

  static ThemeData get lightTheme =>
      ThemeData.light(useMaterial3: true).copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        extensions: <ThemeExtension<dynamic>>[
          CustomThemeExtension(
            chatBackground: Colors.grey[50]!,
            messageBubbleColor: Colors.white,
            userBubbleColor: const Color(0xFFE3F2FD),
            messageTextColor: Colors.black87,
            inputBackgroundColor: Colors.white,
            inputBorderColor: Colors.grey[300]!,
            inputTextColor: Colors.black87,
            hintTextColor: Colors.black54,
            backToBottomButtonColor: Colors.blue[600]!,
            sendButtonColor: Colors.transparent,
            sendButtonIconColor: Colors.blue[600]!,
            typingIndicatorColor: Colors.grey[200]!,
            typingIndicatorDotColor: Colors.grey[600]!,
            messageTimeColor: Colors.grey[600]!,
            messageStatusColor: Colors.grey[600]!,
            messageDividerColor: Colors.grey[300]!,
            elevation: 1.0,
            borderRadius: 16.0,
          ),
        ],
      );

  static ThemeData get darkTheme => ThemeData.dark(useMaterial3: true).copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        extensions: <ThemeExtension<dynamic>>[
          CustomThemeExtension(
            chatBackground: const Color(0xFF171717),
            messageBubbleColor: const Color(0xFF262626),
            userBubbleColor: const Color(0xFF1A4B8F),
            messageTextColor: Colors.grey[100]!,
            inputBackgroundColor: const Color(0xFF262626),
            inputBorderColor: const Color(0xFF404040),
            inputTextColor: Colors.white,
            hintTextColor: Colors.grey[400]!,
            backToBottomButtonColor: Colors.blue[400]!,
            sendButtonColor: Colors.transparent,
            sendButtonIconColor: Colors.blue[400]!,
            typingIndicatorColor: const Color(0xFF262626),
            typingIndicatorDotColor: Colors.grey[400]!,
            messageTimeColor: Colors.grey[400]!,
            messageStatusColor: Colors.grey[400]!,
            messageDividerColor: Colors.grey[800]!,
            elevation: 2.0,
            borderRadius: 16.0,
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
    required this.typingIndicatorColor,
    required this.typingIndicatorDotColor,
    required this.messageTimeColor,
    required this.messageStatusColor,
    required this.messageDividerColor,
    required this.elevation,
    required this.borderRadius,
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
  final Color typingIndicatorColor;
  final Color typingIndicatorDotColor;
  final Color messageTimeColor;
  final Color messageStatusColor;
  final Color messageDividerColor;
  final double elevation;
  final double borderRadius;

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
    Color? typingIndicatorColor,
    Color? typingIndicatorDotColor,
    Color? messageTimeColor,
    Color? messageStatusColor,
    Color? messageDividerColor,
    double? elevation,
    double? borderRadius,
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
        typingIndicatorColor: typingIndicatorColor ?? this.typingIndicatorColor,
        typingIndicatorDotColor:
            typingIndicatorDotColor ?? this.typingIndicatorDotColor,
        messageTimeColor: messageTimeColor ?? this.messageTimeColor,
        messageStatusColor: messageStatusColor ?? this.messageStatusColor,
        messageDividerColor: messageDividerColor ?? this.messageDividerColor,
        elevation: elevation ?? this.elevation,
        borderRadius: borderRadius ?? this.borderRadius,
      );

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
      typingIndicatorColor:
          Color.lerp(typingIndicatorColor, other.typingIndicatorColor, t)!,
      typingIndicatorDotColor: Color.lerp(
          typingIndicatorDotColor, other.typingIndicatorDotColor, t)!,
      messageTimeColor:
          Color.lerp(messageTimeColor, other.messageTimeColor, t)!,
      messageStatusColor:
          Color.lerp(messageStatusColor, other.messageStatusColor, t)!,
      messageDividerColor:
          Color.lerp(messageDividerColor, other.messageDividerColor, t)!,
      elevation: t * other.elevation + (1 - t) * elevation,
      borderRadius: t * other.borderRadius + (1 - t) * borderRadius,
    );
  }
}
