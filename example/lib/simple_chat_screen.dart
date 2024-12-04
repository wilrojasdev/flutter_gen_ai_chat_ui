import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';

class SimpleChatScreen extends StatefulWidget {
  const SimpleChatScreen({super.key});

  @override
  State<SimpleChatScreen> createState() => _SimpleChatScreenState();
}

class _SimpleChatScreenState extends State<SimpleChatScreen> {
  late final ChatMessagesController _controller;
  late final ChatUser _currentUser;
  late final ChatUser _aiUser;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _currentUser = ChatUser(id: '1', firstName: 'User');
    _aiUser = ChatUser(id: '2', firstName: 'AI Assistant');

    // Example of initializing chat with existing messages
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

    _controller = ChatMessagesController(initialMessages: initialMessages);
  }

  Future<void> _handleSendMessage(ChatMessage message) async {
    setState(() => _isLoading = true);
    _controller.addMessage(message);

    try {
      // Simulate AI response - Replace with actual AI integration
      await Future.delayed(const Duration(seconds: 1));
      final response = "This is a demo response to: ${message.text}";

      final aiMessage = ChatMessage(
        text: response,
        user: _aiUser,
        createdAt: DateTime.now(),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple AI Chat'),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: AiChatWidget(
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
