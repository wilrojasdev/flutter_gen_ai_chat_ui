import 'package:flutter/material.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';

// Import the comprehensive example components
import 'comprehensive/models/app_state.dart';
import 'comprehensive/screens/chat_screen.dart' as comprehensive;

/// A simple example demonstrating the Flutter Gen AI Chat UI package
/// This example shows the minimal setup required to use the package
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Gen AI Chat UI Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.system,
      home: const SimpleChatScreen(),
    );
  }
}

class SimpleChatScreen extends StatefulWidget {
  const SimpleChatScreen({super.key});

  @override
  State<SimpleChatScreen> createState() => _SimpleChatScreenState();
}

class _SimpleChatScreenState extends State<SimpleChatScreen> {
  // Create a controller to manage chat messages
  final _controller = ChatMessagesController();

  // Define users for the chat
  final _currentUser = ChatUser(id: 'user123', firstName: 'You');
  final _aiUser = ChatUser(id: 'ai123', firstName: 'AI Assistant');

  // Track loading state
  bool _isLoading = false;

  // Some example questions for the welcome message
  final _exampleQuestions = [
    ExampleQuestion(question: "What can you help me with?"),
    ExampleQuestion(question: "Tell me about Flutter"),
    ExampleQuestion(question: "How does this UI work?"),
  ];

  @override
  void initState() {
    super.initState();

    // Add a welcome message to the chat
    _controller.addMessage(
      ChatMessage(
        text: "👋 Hello! I'm your AI assistant. How can I help you today?",
        user: _aiUser,
        createdAt: DateTime.now(),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose the controller when the widget is disposed
    _controller.dispose();
    super.dispose();
  }

  /// Handle sending a message
  Future<void> _handleSendMessage(ChatMessage message) async {
    // Set loading state
    setState(() => _isLoading = true);

    try {
      // Simulate API call with a delay
      await Future.delayed(const Duration(seconds: 1));

      // Create an AI response
      final response = "Thank you for your message: \"${message.text}\"\n\n"
          "This is a demo response to show how the chat UI works. "
          "In a real implementation, you would connect to an AI service here.";

      // Add the AI response to the chat
      _controller.addMessage(
        ChatMessage(
          text: response,
          user: _aiUser,
          createdAt: DateTime.now(),
        ),
      );
    } finally {
      // Reset loading state
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Example'),
        actions: [
          // Add a button to reset the conversation
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _controller.clearMessages();
              // Re-add the welcome message
              _controller.addMessage(
                ChatMessage(
                  text:
                      "👋 Hello! I'm your AI assistant. How can I help you today?",
                  user: _aiUser,
                  createdAt: DateTime.now(),
                ),
              );
            },
          ),
        ],
      ),
      body: AiChatWidget(
        // Required parameters
        currentUser: _currentUser,
        aiUser: _aiUser,
        controller: _controller,
        onSendMessage: _handleSendMessage,

        // Loading state
        loadingConfig: LoadingConfig(
          isLoading: _isLoading,
        ),

        // Welcome message configuration
        welcomeMessageConfig: const WelcomeMessageConfig(
          title: "Welcome to Flutter Gen AI Chat UI",
          questionsSectionTitle: "Try asking:",
        ),

        // Example questions to display in the welcome message
        exampleQuestions: _exampleQuestions,

        // Input configuration - notice the send button is always visible now
        inputOptions: const InputOptions(
          unfocusOnTapOutside:
              false, // Prevents focus loss when tapping outside
          sendOnEnter: true, // Enter key sends the message
        ),

        // Message styling
        messageOptions: MessageOptions(
          showUserName: true,
          bubbleStyle: BubbleStyle(
            userBubbleColor: Theme.of(context).colorScheme.primaryContainer,
            aiBubbleColor: Theme.of(context).colorScheme.surfaceVariant,
          ),
        ),
      ),
    );
  }
}

// For a more comprehensive example with advanced features:
// - See the 'comprehensive' directory which demonstrates:
//   - Streaming text responses
//   - Dark/light theme switching
//   - Custom message styling
//   - Animation control
//   - Markdown rendering with code blocks
