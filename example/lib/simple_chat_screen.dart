import 'package:flutter/material.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';
import 'package:dash_chat_2/dash_chat_2.dart' show InputOptions;
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

  // Initialize speech recognition with proper error handling
  Future<void> _initSpeech() async {
    try {
      final available = await _speech.initialize(
        onError: (error) {
          debugPrint('Speech error: $error');
          setState(() {
            _isListening = false;
          });
          _showErrorDialog(error.errorMsg);
        },
        onStatus: (status) {
          debugPrint('Speech status: $status');
          if (status == 'notListening') {
            setState(() => _isListening = false);
          }
        },
        finalTimeout: const Duration(milliseconds: 5000),
      );

      if (!available) {
        _showErrorDialog('Speech recognition not available on this device');
      }
    } catch (e) {
      debugPrint('Speech initialization error: $e');
      _showErrorDialog('Failed to initialize speech recognition');
    }
  }

  void _showErrorDialog(String message) {
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Speech Recognition Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _requestPermissions();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  Future<void> _requestPermissions() async {
    try {
      if (Theme.of(context).platform == TargetPlatform.iOS) {
        // Open iOS settings - no direct method, use system settings
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Permissions Required'),
            content: const Text(
                'Please enable microphone and speech recognition permissions in Settings.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        // For Android, request permissions directly
        final status = await _speech.hasPermission;
        if (!status) {
          // The package only provides hasPermission check
          // Permissions must be requested through the initialize method
          await _speech.initialize();
        }
      }
    } catch (e) {
      debugPrint('Permission request error: $e');
    }
  }

  // Improved listen method with error handling
  Future<void> _listen() async {
    if (!_isListening) {
      try {
        final available = await _speech.initialize();
        if (available) {
          setState(() {
            _isListening = true;
          });

          await _speech.listen(
            onResult: (result) {
              if (result.finalResult) {
                final message = ChatMessage(
                  text: result.recognizedWords,
                  user: _currentUser,
                  createdAt: DateTime.now(),
                );
                _handleSendMessage(message);
                setState(() => _isListening = false);
              }
            },
            cancelOnError: true,
            listenMode: stt.ListenMode.confirmation,
          );
        } else {
          _showErrorDialog('Speech recognition not available');
        }
      } catch (e) {
        debugPrint('Listen error: $e');
        setState(() {
          _isListening = false;
        });
        _showErrorDialog('Failed to start listening');
      }
    } else {
      setState(() => _isListening = false);
      await _speech.stop();
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
        text: "This is a simulated AI response to: ${message.text}",
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
          // Basic settings
          userName: 'User',
          aiName: 'AI Assistant',
          hintText: 'Type a message...',
          enableAnimation: true,

          // Input configuration
          inputOptions: const InputOptions(
            alwaysShowSend: true,
            sendOnEnter: true,
          ),
          inputDecoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            prefixIcon: IconButton(
              icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
              onPressed: _listen,
            ),
          ),

          // Message display
          messageOptions: MessageOptions(
            showTime: true,
            containerColor: Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFF1E1E1E)
                : Colors.grey[50]!,
            currentUserContainerColor:
                Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFF7B61FF)
                    : Colors.blue,
          ),

          // Welcome message
          welcomeMessageConfig: const WelcomeMessageConfig(
            title: 'Welcome to Simple Chat!',
            questionsSectionTitle: 'Try asking these questions:',
          ),
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

          // Loading state
          isLoading: _isLoading,
          loadingIndicator: const LoadingWidget(
            texts: [
              'AI is thinking...',
              'Processing your message...',
            ],
          ),
        ),
        currentUser: _currentUser,
        aiUser: _aiUser,
        controller: _controller,
        onSendMessage: _handleSendMessage,
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
