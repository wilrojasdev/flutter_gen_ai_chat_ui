import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';

class SimpleChatScreen extends StatefulWidget {
  const SimpleChatScreen({super.key});

  @override
  State<SimpleChatScreen> createState() => _SimpleChatScreenState();
}

// A basic example demonstrating core features of the chat UI package
class _SimpleChatScreenState extends State<SimpleChatScreen> {
  late final ChatMessagesController _controller;
  late final ChatUser _currentUser;
  late final ChatUser _aiUser;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    // Initialize chat participants
    _currentUser = ChatUser(id: '1', firstName: 'User');
    _aiUser = ChatUser(id: '2', firstName: 'AI Assistant');

    // Optional: Pre-populate chat with initial messages
    final initialMessages = [
      ChatMessage(
        text: "Hello! How can I help you today?",
        user: _aiUser,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      ChatMessage(
        text: "I have a question about Flutter",
        user: _currentUser,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      // Add more messages as needed
    ];

    // Initialize controller with optional initial messages
    _controller = ChatMessagesController(initialMessages: initialMessages);
  }

  // Handle new messages and AI responses
  Future<void> _handleSendMessage(ChatMessage message) async {
    // Show loading indicator while processing
    setState(() => _isLoading = true);

    // Add user message to chat immediately
    _controller.addMessage(message);

    try {
      // Simulate AI processing time - Replace with actual AI integration
      await Future.delayed(const Duration(seconds: 1));

      // Create and add AI response
      final aiMessage = ChatMessage(
        text: "This is a demo response to: ${message.text}",
        user: _aiUser,
        createdAt: DateTime.now(),
      );
      _controller.addMessage(aiMessage);
    } finally {
      // Hide loading indicator
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple AI Chat'),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: AiChatWidget(
        // Basic configuration with minimal customization
        config: const AiChatConfig(
          hintText: 'Type a message...',
          enableAnimation: true,
        ),
        currentUser: _currentUser,
        aiUser: _aiUser,
        controller: _controller,
        onSendMessage: _handleSendMessage,
        isLoading: _isLoading,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
