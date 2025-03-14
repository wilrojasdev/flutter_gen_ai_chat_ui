import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'models/app_state.dart';
import 'screens/chat_screen.dart';
import 'theme/app_theme.dart';

/// Entry point for the comprehensive AI Chat example
///
/// To run this example independently, use:
/// ```
/// flutter run -t lib/comprehensive/main.dart
/// ```
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set system UI style
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
      child: const ProfessionalAiApp(),
    ),
  );
}

/// Main app with theme configuration and state management
class ProfessionalAiApp extends StatelessWidget {
  const ProfessionalAiApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return MaterialApp(
      title: 'Professional AI Assistant',
      debugShowCheckedModeBanner: false,
      themeMode: appState.themeMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: const ChatScreen(),
    );
  }
}
