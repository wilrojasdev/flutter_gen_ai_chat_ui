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
    _currentUser = const ChatUser(
      id: '1',
      name: 'User',
      avatar: 'https://ui-avatars.com/api/?name=User',
    );
    _aiUser = const ChatUser(
      id: '2',
      name: 'AI Assistant',
      avatar: 'https://ui-avatars.com/api/?name=AI&background=10A37F&color=fff',
    );

    // Initialize controller
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
            listenFor: const Duration(seconds: 30),
            pauseFor: const Duration(seconds: 3),
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
    setState(() => _isLoading = true);

    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));

    final response = ChatMessage(
      text: 'I received your message: ${message.text}',
      user: const ChatUser(id: '2', name: 'AI'),
      createdAt: DateTime.now(),
      customProperties: {
        'isMarkdown': false, // Regular text
        'isStreaming': false, // No streaming for simple responses
      },
    );

    _controller.addMessage(response);
    setState(() => _isLoading = false);
  }

  void _handleExampleQuestion(String question) {
    final message = ChatMessage(
      text: question,
      user: const ChatUser(id: '1', name: 'User'),
      createdAt: DateTime.now(),
    );
    _handleSendMessage(message);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Simple Chat')),
      body: AiChatWidget(
        config: AiChatConfig(
          aiName: 'AI',
          enableAnimation: true, // Enable animations
          inputOptions: const InputOptions(
            margin: EdgeInsets.all(16),
            alwaysShowSend: true,
          ),
          exampleQuestions: [
            ExampleQuestion(
              question: 'What can you do?',
              config: ExampleQuestionConfig(
                onTap: (question) => _handleExampleQuestion(question),
              ),
            ),
          ],
        ),
        currentUser: const ChatUser(id: '1', name: 'User'),
        aiUser: const ChatUser(id: '2', name: 'AI'),
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
