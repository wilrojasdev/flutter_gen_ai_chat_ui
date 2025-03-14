import 'package:flutter/material.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';

// Import the comprehensive example components
import 'comprehensive/models/app_state.dart';
import 'comprehensive/screens/chat_screen.dart' as comprehensive;

void main() {
  runApp(const ExampleSelectionApp());
}

/// App that allows selection between different example implementations
class ExampleSelectionApp extends StatelessWidget {
  const ExampleSelectionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Gen AI Chat UI Examples',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ExampleSelectionScreen(),
    );
  }
}

/// Screen for selecting between different examples
class ExampleSelectionScreen extends StatelessWidget {
  const ExampleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Chat UI Examples'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Title
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const Text(
                    'Flutter Gen AI Chat UI',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Select an example implementation',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Example options
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  // Minimal example
                  _buildExampleCard(
                    context,
                    title: 'Minimal Example',
                    description:
                        'Clean, simple implementation with basic features',
                    icon: Icons.code,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MinimalChatScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  // Comprehensive example
                  _buildExampleCard(
                    context,
                    title: 'Professional Example',
                    description:
                        'Full-featured implementation with professional design',
                    icon: Icons.auto_awesome,
                    isPrimary: true,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => _buildComprehensiveExample(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build a card for an example option
  Widget _buildExampleCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required VoidCallback onTap,
    bool isPrimary = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 2,
      color: isPrimary ? colorScheme.primaryContainer : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Icon(
                icon,
                size: 36,
                color: isPrimary
                    ? colorScheme.onPrimaryContainer
                    : colorScheme.primary,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isPrimary
                            ? colorScheme.onPrimaryContainer
                            : colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        color: isPrimary
                            ? colorScheme.onPrimaryContainer.withOpacity(0.8)
                            : colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: isPrimary
                    ? colorScheme.onPrimaryContainer.withOpacity(0.8)
                    : colorScheme.onSurface.withOpacity(0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// This function imports and returns the comprehensive example
  Widget _buildComprehensiveExample() {
    return ChangeNotifierProvider(
      create: (_) => AppState(),
      child: const comprehensive.ChatScreen(),
    );
  }
}

/// Simple chat screen implementation
class MinimalChatScreen extends StatefulWidget {
  const MinimalChatScreen({super.key});

  @override
  State<MinimalChatScreen> createState() => _MinimalChatScreenState();
}

class _MinimalChatScreenState extends State<MinimalChatScreen> {
  // Controller for managing chat messages
  final _chatController = ChatMessagesController();

  // Define user identities
  final _currentUser = ChatUser(id: 'user1', firstName: 'User');
  final _aiUser = ChatUser(id: 'ai1', firstName: 'AI');

  // Track loading state
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minimal AI Chat'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset Chat',
            onPressed: () {
              _chatController.clearMessages();
              _chatController.showWelcomeMessage = true;
            },
          ),
        ],
      ),
      body: AiChatWidget(
        // Required parameters
        currentUser: _currentUser,
        aiUser: _aiUser,
        controller: _chatController,
        onSendMessage: _handleSendMessage,

        // Simple loading configuration
        loadingConfig: LoadingConfig(
          isLoading: _isLoading,
        ),

        // Add some basic example questions
        exampleQuestions: [
          ExampleQuestion(question: 'What can you help me with?'),
          ExampleQuestion(question: 'Tell me a fun fact'),
          ExampleQuestion(question: 'Show me a code example'),
          ExampleQuestion(question: 'What is Flutter?'),
        ],

        // Simple welcome message
        welcomeMessageConfig: WelcomeMessageConfig(
          title: 'Welcome to the Minimal AI Chat',
          titleStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          containerPadding: const EdgeInsets.all(20),
          containerDecoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 0,
              ),
            ],
          ),
        ),

        // Add some basic markdown styling
        markdownStyleSheet: MarkdownStyleSheet(
          p: const TextStyle(fontSize: 16),
          code: TextStyle(
            backgroundColor: Colors.grey.shade200,
            fontFamily: 'monospace',
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  // Handle sending a message
  void _handleSendMessage(ChatMessage message) async {
    setState(() => _isLoading = true);

    // Generate a response based on the user's message
    final response = _generateResponse(message.text);

    // Simulate AI response after a delay
    await Future.delayed(const Duration(seconds: 1));

    // Add AI response
    _chatController.addMessage(
      ChatMessage(
        text: response,
        user: _aiUser,
        createdAt: DateTime.now(),
        isMarkdown: true, // Enable markdown for formatted responses
      ),
    );

    setState(() => _isLoading = false);
  }

  // Generate a simple response based on user input
  String _generateResponse(String input) {
    final lowerInput = input.toLowerCase();

    // Check for greetings
    if (lowerInput.contains('hello') || lowerInput.contains('hi')) {
      return "Hello! 👋 How can I help you today?";
    }

    // Check for questions about the assistant
    if (lowerInput.contains('who are you') ||
        lowerInput.contains('your name')) {
      return "I'm a simple AI assistant created to demonstrate the Flutter Gen AI Chat UI package.";
    }

    // Check for help requests
    if (lowerInput.contains('help') || lowerInput.contains('can you do')) {
      return "I can help with some basic information and demonstrate how this chat UI works. Try asking me about Flutter or how this UI is built!";
    }

    // Check for Flutter questions
    if (lowerInput.contains('flutter')) {
      return "**Flutter** is Google's UI toolkit for building beautiful, natively compiled applications for mobile, web, desktop, and embedded devices from a single codebase. The Flutter Gen AI Chat UI package makes it easy to create AI chat interfaces in Flutter!";
    }

    // Check for code-related questions
    if (lowerInput.contains('code') || lowerInput.contains('example')) {
      return "Here's a simple Flutter code example:\n\n```dart\nContainer(\n  padding: EdgeInsets.all(16),\n  decoration: BoxDecoration(\n    color: Colors.blue[100],\n    borderRadius: BorderRadius.circular(12),\n  ),\n  child: Text('Hello, Flutter!'),\n)\n```";
    }

    // Default response
    return "Thanks for your message! This is a simple demo of the Flutter Gen AI Chat UI package. Try asking about Flutter or requesting a code example.";
  }

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }
}
