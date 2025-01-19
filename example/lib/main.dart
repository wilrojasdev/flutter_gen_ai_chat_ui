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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
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
    const MyHomePage(),
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
  const MyHomePage({super.key});

  static const List<String> titles = [
    'Basic Example',
    'Custom Styling',
    'Detailed Example',
    'Markdown Example',
    'Pagination Example',
    'Streaming Example',
    'Simple Chat',
  ];

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _controller = ChatMessagesController();
  bool _isLoading = false;
  bool _speechEnabled = true;
  final _currentUser = ChatUser(
    id: '1',
    firstName: 'User',
  );
  final _aiUser = ChatUser(
    id: '2',
    firstName: 'AI Assistant',
  );

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      drawer: NavigationDrawer(
        selectedIndex: 0,
        onDestinationSelected: (index) {
          Navigator.pop(context);
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
            MyHomePage.titles.length,
            (index) => NavigationDrawerDestination(
              icon: Icon(
                index == 0 ? Icons.chat_rounded : Icons.chat_outlined,
              ),
              label: Text(MyHomePage.titles[index]),
            ),
          ),
          const Divider(indent: 28, endIndent: 28),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Row(
              children: [
                const Text('Speech Recognition'),
                const Spacer(),
                Switch(
                  value: _speechEnabled,
                  onChanged: (value) => setState(() => _speechEnabled = value),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
        ),
        constraints: const BoxConstraints.expand(),
        child: Material(
          color: Colors.transparent,
          child: SafeArea(
            child: AiChatWidget(
              config: AiChatConfig(
                userName: 'User',
                aiName: 'AI Assistant',
                hintText: 'Type or speak your message...',
                enableAnimation: true,
                showTimestamp: true,
                enableSpeechToText: _speechEnabled,
                speechToTextIcon: Icons.mic_none_rounded,
                speechToTextActiveIcon: Icons.mic_rounded,
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

                // Simulate AI response
                setState(() => _isLoading = true);
                await Future.delayed(const Duration(seconds: 2));

                // Add AI response
                _controller.addMessage(
                  ChatMessage(
                    text: 'I received your message: ${message.text}',
                    user: _aiUser,
                    createdAt: DateTime.now(),
                  ),
                );
                setState(() => _isLoading = false);
              },
            ),
          ),
        ),
      ),
    );
  }
}
