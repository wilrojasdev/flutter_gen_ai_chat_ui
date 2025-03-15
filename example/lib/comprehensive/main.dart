import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/app_state.dart';
import 'screens/chat_screen.dart';

/// Comprehensive example demonstrating advanced features of Flutter Gen AI Chat UI
void main() {
  runApp(const ComprehensiveExample());
}

class ComprehensiveExample extends StatelessWidget {
  const ComprehensiveExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(),
      child: Consumer<AppState>(
        builder: (context, appState, _) {
          return MaterialApp(
            title: 'Flutter Gen AI Chat UI - Comprehensive',
            themeMode: appState.themeMode,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.indigo,
                brightness: Brightness.light,
              ),
              useMaterial3: true,
            ),
            darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.indigo,
                brightness: Brightness.dark,
              ),
            ),
            debugShowCheckedModeBanner: false,
            home: const ChatScreen(),
          );
        },
      ),
    );
  }
}
