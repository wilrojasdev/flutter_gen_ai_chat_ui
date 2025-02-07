import 'package:flutter/material.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

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

  // Speech recognition
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;

  @override
  void initState() {
    super.initState();

    // Initialize chat participants
    _currentUser = ChatUser(id: '1', firstName: 'User');
    _aiUser = ChatUser(id: '2', firstName: 'AI Assistant');

    // // Optional: Pre-populate chat with initial messages
    // final initialMessages = [
    //   ChatMessage(
    //     text: "Hello! How can I help you today?",
    //     user: _aiUser,
    //     createdAt: DateTime.now().subtract(const Duration(days: 1)),
    //   ),
    //   ChatMessage(
    //     text: "I have a question about Flutter",
    //     user: _currentUser,
    //     createdAt: DateTime.now().subtract(const Duration(days: 1)),
    //   ),
    //   // Add more messages as needed
    // ];

    // Initialize controller with optional initial messages
    _controller = ChatMessagesController();
    _initSpeech();
  }

  // Initialize speech recognition
  Future<void> _initSpeech() async {
    await _speech.initialize(
      onError: (error) => debugPrint('Speech error: $error'),
      onStatus: (status) => debugPrint('Speech status: $status'),
    );
  }

  // Toggle listening
  Future<void> _listen() async {
    if (!_isListening) {
      final available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (result) {
            if (result.finalResult && result.recognizedWords.isNotEmpty) {
              final message = ChatMessage(
                text: result.recognizedWords,
                user: _currentUser,
                createdAt: DateTime.now(),
              );
              _handleSendMessage(message);
              setState(() => _isListening = false);
            }
          },
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
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
      body: AiChatWidget(
        config: AiChatConfig(
          hintText: 'Type a message...',
          enableAnimation: true,
          welcomeMessageConfig: const WelcomeMessageConfig(
            title: 'Welcome to Simple Chat!',
            questionsSectionTitle: 'Try asking these questions:',
          ),
          aiName: 'AI Assistant',
          exampleQuestions: const [
            ExampleQuestion(
              question: 'What is the weather in Tokyo?',
            ),
            ExampleQuestion(
              question: 'What is the capital of France?',
            ),
            ExampleQuestion(
              question: 'What is the capital of Japan?',
            ),
          ],
          // Custom input decoration with speech button
          inputDecoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            prefixIcon: IconButton(
              icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
              onPressed: _listen,
            ),
          ),
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
    _speech.cancel();
    super.dispose();
  }
}
