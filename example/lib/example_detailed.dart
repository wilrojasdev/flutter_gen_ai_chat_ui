import 'package:flutter/material.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';
import 'package:dash_chat_2/dash_chat_2.dart'; // Add this import
import 'package:provider/provider.dart'; // Add this import

class ExampleDetailed extends StatefulWidget {
  const ExampleDetailed({super.key});

  @override
  State<ExampleDetailed> createState() => _ExampleDetailedState();
}

class _ExampleDetailedState extends State<ExampleDetailed> {
  late final ChatMessagesController messagesController;
  late final List<ChatExample> exampleQuestions;

  @override
  void initState() {
    super.initState();
    messagesController = ChatMessagesController(
      onSendMessage: (message) async {
        await Future.delayed(const Duration(seconds: 1));
        return "Response to: $message";
      },
    );
    exampleQuestions = _createExampleQuestions();
  }

  List<ChatExample> _createExampleQuestions() {
    return [
      ChatExample(
        question: 'What is the weather like today?',
        onTap: (controller) {
          controller.handleExampleQuestion(
            'What is the weather like today?',
            ChatUser(id: '1', firstName: 'User'),
            ChatUser(id: '2', firstName: 'AI Assistant'),
          );
        },
      ),
      ChatExample(
        question: 'Tell me a joke.',
        onTap: (controller) {
          controller.handleExampleQuestion(
            'Tell me a joke.',
            ChatUser(id: '1', firstName: 'User'),
            ChatUser(id: '2', firstName: 'AI Assistant'),
          );
        },
      ),
    ];
  }

  Widget _buildWelcomeMessage(BuildContext context, List<ChatExample> examples,
      ChatMessagesController controller) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        final isDarkMode = themeProvider.isDark;
        return Container(
          margin: const EdgeInsets.all(16.0),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey[900] : Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: isDarkMode ? Colors.black38 : Colors.black12,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome! How can I assist you today?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Here are some questions you can ask:',
                style: TextStyle(
                  fontSize: 16,
                  color: isDarkMode ? Colors.white70 : Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              for (var example in examples)
                GestureDetector(
                  onTap: () => example.onTap(controller),
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 12.0,
                    ),
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.grey[800] : Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      example.question,
                      style: TextStyle(
                        color: isDarkMode ? Colors.blue[100] : Colors.blue[700],
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          final isDarkMode = themeProvider.isDark;
          final size = MediaQuery.of(context).size;
          final isTablet = size.width > 600;
          final isDesktop = size.width > 1200;

          return Theme(
            data: themeProvider.theme,
            child: Scaffold(
              appBar: AppBar(
                title: const Text('AI Chat'),
                elevation: 0,
                surfaceTintColor: Colors.transparent,
                actions: [
                  IconButton(
                    icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
                    onPressed: () {
                      themeProvider.toggleTheme();
                    },
                  ),
                ],
              ),
              body: Center(
                child: AiChatWidget(
                  config: AiChatConfig(
                    userName: 'User',
                    aiName: 'AI Assistant',
                    hintText: LocaleHelper.isRTL(context)
                        ? 'نامەیەک بنێرە...'
                        : 'Type a message...',
                    maxWidth: isDesktop
                        ? 900
                        : isTablet
                            ? 700
                            : null,
                    enableAnimation: true,
                    showTimestamp: true,
                    exampleQuestions: exampleQuestions,
                  ),
                  controller: messagesController,
                  welcomeMessageBuilder: () => _buildWelcomeMessage(
                      context, exampleQuestions, messagesController),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    messagesController.dispose();
    super.dispose();
  }
}
