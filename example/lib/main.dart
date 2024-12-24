import 'package:flutter/material.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
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
  bool _isDark = false;

  void toggleTheme() {
    setState(() {
      _isDark = !_isDark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Chat Demo',
      themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4),
          brightness: Brightness.light,
        ).copyWith(
          surface: Colors.white,
        ),
        textTheme: GoogleFonts.interTextTheme(),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4),
          brightness: Brightness.dark,
        ).copyWith(
          surface: const Color(0xFF1A1A1A),
        ),
        textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
      ),
      home: ExamplesNavigator(onThemeToggle: toggleTheme, isDark: _isDark),
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
    const MyHomePage(title: 'Basic Example'),
    const CustomStylingExample(),
    const DetailedExample(),
    const MarkdownExample(),
    const PaginationExample(),
    const StreamingExample(),
    const SimpleChatScreen(),
  ];

  static const List<String> _titles = [
    'Basic Example',
    'Custom Styling',
    'Detailed Example',
    'Markdown Example',
    'Pagination Example',
    'Streaming Example',
    'Simple Chat',
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
                  color: colorScheme.onSurface,
                ),
                style: IconButton.styleFrom(
                  backgroundColor:
                      colorScheme.surfaceContainerHighest.withOpacity(0.3),
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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ChatMessagesController _controller = ChatMessagesController();
  final ChatUser _currentUser = ChatUser(id: '1', firstName: 'User');
  final ChatUser _aiUser = ChatUser(id: '2', firstName: 'AI');
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
      ),
      child: AiChatWidget(
        config: AiChatConfig(
          userName: 'User',
          aiName: 'AI Assistant',
          hintText: 'Type your message...',
          enableAnimation: true,
          showTimestamp: true,
          exampleQuestions: [
            ChatExample(
              question: 'What can you help me with?',
              onTap: (controller) {
                controller.handleExampleQuestion(
                  'What can you help me with?',
                  _currentUser,
                  _aiUser,
                );
              },
            ),
            ChatExample(
              question: 'Tell me about your capabilities',
              onTap: (controller) {
                controller.handleExampleQuestion(
                  'Tell me about your capabilities',
                  _currentUser,
                  _aiUser,
                );
              },
            ),
            ChatExample(
              question: 'How do I get started?',
              onTap: (controller) {
                controller.handleExampleQuestion(
                  'How do I get started?',
                  _currentUser,
                  _aiUser,
                );
              },
            ),
          ],
        ),
        currentUser: _currentUser,
        aiUser: _aiUser,
        controller: _controller,
        isLoading: _isLoading,
        loadingIndicator: LoadingWidget(
          texts: const [
            'AI is thinking...',
            'Processing your message...',
            'Generating response...',
            'Almost there...',
          ],
          interval: const Duration(seconds: 2),
          textStyle: TextStyle(
            color: colorScheme.onSurfaceVariant,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.1,
          ),
          shimmerBaseColor:
              colorScheme.surfaceContainerHighest.withOpacity(0.5),
          shimmerHighlightColor: colorScheme.surface,
        ),
        onSendMessage: (ChatMessage message) async {
          // Add the user's message to the chat
          _controller.addMessage(message);

          // Start loading state
          setState(() {
            _isLoading = true;
          });

          // Simulate AI response after a delay
          await Future.delayed(const Duration(seconds: 2));

          // Add AI response
          _controller.addMessage(
            ChatMessage(
              text:
                  'I received your message: "${message.text}"\n\nThis is a simulated response that takes 2 seconds to appear, showing the loading indicator in the meantime.',
              user: _aiUser,
              createdAt: DateTime.now(),
            ),
          );

          // Stop loading state
          setState(() {
            _isLoading = false;
          });
        },
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.onPressed,
    required this.icon,
    required this.label,
  });

  final VoidCallback onPressed;
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Expanded(
      child: Material(
        color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 24,
                  color: colorScheme.primary,
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: isSmallScreen ? 12 : 13,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.1,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
