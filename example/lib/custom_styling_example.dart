import 'package:flutter/material.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomStylingExample extends StatefulWidget {
  const CustomStylingExample({super.key});

  @override
  State<CustomStylingExample> createState() => _CustomStylingExampleState();
}

class _CustomStylingExampleState extends State<CustomStylingExample> {
  late final ChatMessagesController _controller;
  late final ChatUser _currentUser;
  late final ChatUser _aiUser;
  bool _isLoading = false;

  // Custom theme options
  final int _selectedColorScheme = 0;

  // Predefined color schemes for demonstration
  final List<(Color, String)> _colorSchemes = [
    (const Color(0xFF7B61FF), 'Modern Purple'), // Modern Purple
    (const Color(0xFF2E7D32), 'Elegant Green'), // Elegant Green
    (const Color(0xFF0277BD), 'Ocean Blue'), // Ocean Blue
  ];

  @override
  void initState() {
    super.initState();
    _currentUser = const ChatUser(
      id: "user1",
      name: "User",
      avatar: "https://i.pravatar.cc/150?img=1", // Example avatar
    );
    _aiUser = const ChatUser(
      id: "ai",
      name: "AI Assistant",
      avatar: "https://i.pravatar.cc/150?img=2", // Example avatar
    );
    _controller = ChatMessagesController();

    // Add initial welcome message
    _controller.addMessage(ChatMessage(
      text: """# Welcome to Custom Styling Demo! 🎨

This example showcases various styling options available in the package:

• Custom color schemes
• Message bubble styling
• Input field customization
• Avatar customization
• Typography options
• And more!

Try the color scheme selector in the top right to switch between themes.""",
      user: _aiUser,
      createdAt: DateTime.now(),
      isMarkdown: true,
    ));
  }

  Future<void> _handleSendMessage(ChatMessage message) async {
    setState(() => _isLoading = true);
    _controller.addMessage(message);

    try {
      await Future.delayed(const Duration(seconds: 1));

      String response = '';
      if (message.text.toLowerCase().contains('theme') ||
          message.text.toLowerCase().contains('style')) {
        response = """# Styling Features 🎨

This chat UI demonstrates:

1. **Color Schemes**
   • Modern Purple
   • Elegant Green
   • Ocean Blue

2. **Message Styling**
   • Custom colors
   • Rounded corners
   • Avatar support
   • Time stamps

3. **Input Field**
   • Custom borders
   • Themed colors
   • Send button styling

Try the color scheme selector in the top right!""";
      } else {
        response =
            "Your message: '${message.text}' demonstrates our custom styling. Notice the themed colors and clean design!";
      }

      final aiMessage = ChatMessage(
        text: response,
        user: _aiUser,
        createdAt: DateTime.now(),
        isMarkdown: message.text.toLowerCase().contains('theme') ||
            message.text.toLowerCase().contains('style'),
      );
      _controller.addMessage(aiMessage);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentColor = _colorSchemes[_selectedColorScheme].$1;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: currentColor,
          brightness: Theme.of(context).brightness,
        ),
      ),
      child: Builder(
        builder: (context) {
          return Scaffold(
            body: AiChatWidget(
              config: AiChatConfig(
                hintText: 'Type a message...',
                enableAnimation: true,
                welcomeMessageConfig: const WelcomeMessageConfig(
                  title: 'Custom Styling Demo',
                  questionsSectionTitle: 'Try these style-related questions:',
                ),
                aiName: 'Style Assistant',
                messageOptions: MessageOptions(
                  decoration: BoxDecoration(
                    color: isDark
                        ? Theme.of(context).colorScheme.surface
                        : Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest
                            .withValues(alpha: 128),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  textStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  timeTextStyle: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 153),
                  ),
                ),
                inputOptions: InputOptions(
                  textStyle: GoogleFonts.inter(),
                  decoration: InputDecoration(
                    hintText: 'Send a message',
                    hintStyle: GoogleFonts.inter(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 153),
                    ),
                    filled: true,
                    fillColor: isDark
                        ? Theme.of(context).colorScheme.surface
                        : Theme.of(context)
                            .colorScheme
                            .surface
                            .withValues(alpha: 230),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.outline,
                        width: 1,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.outline,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: currentColor,
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
                exampleQuestions: [
                  ExampleQuestion(
                    question: 'Tell me about the styling features',
                    config: ExampleQuestionConfig(
                      onTap: (question) {
                        final message = ChatMessage(
                          text: question,
                          user: _currentUser,
                          createdAt: DateTime.now(),
                        );
                        _handleSendMessage(message);
                      },
                    ),
                  ),
                  ExampleQuestion(
                    question: 'Show different themes',
                    config: ExampleQuestionConfig(
                      onTap: (question) {
                        final message = ChatMessage(
                          text: question,
                          user: _currentUser,
                          createdAt: DateTime.now(),
                        );
                        _handleSendMessage(message);
                      },
                    ),
                  ),
                ],
                loadingConfig: LoadingConfig(
                  isLoading: _isLoading,
                ),
              ),
              controller: _controller,
              currentUser: _currentUser,
              aiUser: _aiUser,
              onSendMessage: _handleSendMessage,
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
