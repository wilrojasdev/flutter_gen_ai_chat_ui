import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';
import 'package:provider/provider.dart';

import 'models/app_state.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return MaterialApp(
      title: 'AI Chat Demo',
      debugShowCheckedModeBanner: false,
      themeMode: appState.themeMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: const HomeScreen(),
    );
  }
}

// Light theme extension for the chat UI
final lightThemeExtension = CustomThemeExtension(
  chatBackground: Colors.grey[50],
  messageBubbleColor: Colors.grey[200],
  userBubbleColor: Colors.blue[50],
  messageTextColor: Colors.black87,
  inputBackgroundColor: Colors.white,
  inputBorderColor: Colors.grey[300],
  inputTextColor: Colors.black87,
  hintTextColor: Colors.grey[500],
  backToBottomButtonColor: Colors.blue[100],
  sendButtonColor: Colors.blue,
  sendButtonIconColor: Colors.white,
);

// Dark theme extension for the chat UI
final darkThemeExtension = CustomThemeExtension(
  chatBackground: Colors.grey[900],
  messageBubbleColor: Colors.grey[800],
  userBubbleColor: Colors.blue[900],
  messageTextColor: Colors.white,
  inputBackgroundColor: Colors.grey[850],
  inputBorderColor: Colors.grey[700],
  inputTextColor: Colors.white,
  hintTextColor: Colors.grey[400],
  backToBottomButtonColor: Colors.blue[800],
  sendButtonColor: Colors.blue[600],
  sendButtonIconColor: Colors.white,
);
