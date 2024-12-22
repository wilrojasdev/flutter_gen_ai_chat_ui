import 'package:flutter/material.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:google_fonts/google_fonts.dart';

class StreamingExample extends StatefulWidget {
  const StreamingExample({super.key});

  @override
  State<StreamingExample> createState() => _StreamingExampleState();
}

class _StreamingExampleState extends State<StreamingExample>
    with TickerProviderStateMixin {
  late final ChatMessagesController _controller;
  late final ChatUser _currentUser;
  late final ChatUser _aiUser;
  late final List<ChatExample> _exampleQuestions;
  bool _isLoading = false;
  bool _isStreaming = false;
  late final AnimationController _loadingAnimationController;

  @override
  void initState() {
    super.initState();
    _currentUser = ChatUser(id: '1', firstName: 'User');
    _aiUser = ChatUser(id: '2', firstName: 'AI Assistant');
    _controller = ChatMessagesController();
    _exampleQuestions = _createExampleQuestions();
    _loadingAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Add welcome message
    _controller.addMessage(ChatMessage(
      text:
          "Welcome! How can I assist you today?\n\nHere are some questions you can ask:",
      user: _aiUser,
      createdAt: DateTime.now(),
    ));
  }

  List<ChatExample> _createExampleQuestions() {
    return [
      ChatExample(
        question: "What is streaming in chat applications?",
        onTap: (controller) {
          _handleSendMessage(ChatMessage(
            text: "What is streaming in chat applications?",
            user: _currentUser,
            createdAt: DateTime.now(),
          ));
        },
      ),
      ChatExample(
        question: "Show me how word-by-word responses work",
        onTap: (controller) {
          _handleSendMessage(ChatMessage(
            text: "Show me how word-by-word responses work",
            user: _currentUser,
            createdAt: DateTime.now(),
          ));
        },
      ),
      ChatExample(
        question: "What are the benefits of streaming responses?",
        onTap: (controller) {
          _handleSendMessage(ChatMessage(
            text: "What are the benefits of streaming responses?",
            user: _currentUser,
            createdAt: DateTime.now(),
          ));
        },
      ),
    ];
  }

  Future<void> _handleSendMessage(ChatMessage message) async {
    setState(() {
      _isLoading = true;
      _isStreaming = false;
    });
    _loadingAnimationController.forward();
    _controller.addMessage(message);

    try {
      final messageId = DateTime.now().millisecondsSinceEpoch.toString();

      setState(() {
        _isLoading = false;
        _isStreaming = true;
      });

      await _streamResponse(messageId);
    } finally {
      if (mounted) {
        setState(() {
          _isStreaming = false;
        });
        _loadingAnimationController.reverse();
      }
    }
  }

  Future<void> _streamResponse(String messageId) async {
    const words = [
      "Hello!",
      "I'm",
      "responding",
      "word",
      "by",
      "word",
      "to",
      "demonstrate",
      "streaming",
      "functionality.",
      "This",
      "creates",
      "a",
      "more",
      "natural",
      "chat",
      "experience!"
    ];

    String currentText = "";

    // Create initial empty message
    _controller.addMessage(
      ChatMessage(
        text: "",
        user: _aiUser,
        createdAt: DateTime.now(),
        customProperties: {
          'id': messageId,
          'isStreaming': true,
        },
      ),
    );

    // Stream the words
    for (final word in words) {
      await Future.delayed(const Duration(milliseconds: 50));
      currentText += "${currentText.isEmpty ? '' : ' '}$word";

      _controller.updateMessage(
        ChatMessage(
          text: currentText,
          user: _aiUser,
          createdAt: DateTime.now(),
          customProperties: {
            'id': messageId,
            'isStreaming': true,
          },
        ),
      );
    }

    // Final message
    await Future.delayed(const Duration(milliseconds: 50));
    _controller.updateMessage(
      ChatMessage(
        text: currentText,
        user: _aiUser,
        createdAt: DateTime.now(),
        customProperties: {
          'id': messageId,
          'isStreaming': false,
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Streaming Example',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        elevation: 0,
        scrolledUnderElevation: 1,
        surfaceTintColor: Colors.transparent,
      ),
      body: AiChatWidget(
        config: AiChatConfig(
          hintText: 'Type a message...',
          typingUsers: null,
          enableAnimation: true,
          showTimestamp: true,
          exampleQuestions: _exampleQuestions,
          messageOptions: MessageOptions(
            containerColor: Theme.of(context).colorScheme.surface,
            currentUserContainerColor:
                Theme.of(context).colorScheme.primary.withOpacity(0.1),
            textColor: Theme.of(context).colorScheme.onSurface,
            currentUserTextColor: Theme.of(context).colorScheme.onSurface,
            messagePadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            showCurrentUserAvatar: false,
            showOtherUsersAvatar: false,
            showTime: true,
            currentUserTimeTextColor:
                Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            timeTextColor:
                Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            messageTextBuilder: (message, previousMessage, nextMessage) {
              final bool isUser = message.user.id == _currentUser.id;
              final bool isStreaming =
                  message.customProperties?['isStreaming'] == true;

              return AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: message.text.isEmpty ? 0.0 : 1.0,
                child: AnimatedBubble(
                  key: ValueKey(message.createdAt.millisecondsSinceEpoch),
                  animate: false,
                  isUser: isUser,
                  child: AnimatedTextMessage(
                    key: ValueKey(
                        '${message.createdAt.millisecondsSinceEpoch}_${message.text.length}'),
                    text: message.text,
                    animate: !isStreaming && !isUser,
                    isUser: isUser,
                    isStreaming: isStreaming,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 15,
                      height: 1.4,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        loadingIndicator: LoadingWidget(
          texts: const ['Loading...', 'Please wait...', 'Almost there...'],
          interval: const Duration(seconds: 2),
          textStyle: Theme.of(context).textTheme.bodyLarge,
        ),
        currentUser: _currentUser,
        aiUser: _aiUser,
        controller: _controller,
        onSendMessage: _handleSendMessage,
        isLoading: _isLoading || _isStreaming,
      ),
    );
  }

  @override
  void dispose() {
    _loadingAnimationController.dispose();
    _controller.dispose();
    super.dispose();
  }
}
