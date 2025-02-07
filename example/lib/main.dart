import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'custom_styling_example.dart';
import 'detailed_example.dart';
import 'markdown_example.dart';
import 'pagination_example.dart';
import 'streaming_example.dart';
import 'simple_chat_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Gen AI Chat UI Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.amber,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: _themeMode,
      home: ExamplesNavigator(
        onThemeToggle: _toggleTheme,
        isDark: _themeMode == ThemeMode.dark,
      ),
    );
  }
}

class ExamplesNavigator extends StatefulWidget {
  const ExamplesNavigator({
    super.key,
    required this.onThemeToggle,
    required this.isDark,
  });

  final VoidCallback onThemeToggle;
  final bool isDark;

  @override
  State<ExamplesNavigator> createState() => _ExamplesNavigatorState();
}

class _ExamplesNavigatorState extends State<ExamplesNavigator> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = [
    const SimpleChatScreen(),
    const CustomStylingExample(),
    const DetailedExample(),
    const MarkdownExample(),
    const PaginationExample(),
    const StreamingExample(),
  ];

  static const List<String> _titles = [
    'Basic Example',
    'Custom Styling',
    'Detailed Example',
    'Markdown Example',
    'Pagination Example',
    'Streaming Example',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Theme(
      data: theme.copyWith(
        colorScheme: colorScheme.copyWith(
          primary: const Color(0xFF6750A4),
          secondary: const Color(0xFF7B61FF),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: colorScheme.surface,
          title: Text(
            _titles[_selectedIndex],
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.5,
            ),
          ),
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu_rounded),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                icon: Icon(
                  widget.isDark
                      ? Icons.light_mode_rounded
                      : Icons.dark_mode_rounded,
                  color: widget.isDark ? Colors.white : colorScheme.onSurface,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: widget.isDark
                      ? const Color(0xFF7B61FF).withAlpha(50)
                      : colorScheme.surfaceContainerHighest
                          .withValues(alpha: 26),
                ),
                onPressed: widget.onThemeToggle,
              ),
            ),
          ],
        ),
        body: _pages[_selectedIndex],
        drawer: NavigationDrawer(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) {
            setState(() {
              _selectedIndex = index;
            });
            Navigator.pop(context); // Close drawer after selection
          },
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 16, 16, 10),
              child: Text(
                'Examples',
                style: TextStyle(
                  color: colorScheme.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.15,
                ),
              ),
            ),
            const Divider(indent: 28, endIndent: 28),
            ...List.generate(
              _titles.length,
              (index) => NavigationDrawerDestination(
                icon: Icon(
                  index == _selectedIndex
                      ? Icons.chat_rounded
                      : Icons.chat_outlined,
                ),
                label: Text(_titles[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
