import 'package:flutter/material.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter_streaming_text_markdown/flutter_streaming_text_markdown.dart';

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
  late final List<ExampleQuestion> _exampleQuestions;
  bool _isLoading = false;
  bool _isStreaming = false;
  String? _streamingMessageId;
  String? _latestMessageId; // Add this line
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

  List<ExampleQuestion> _createExampleQuestions() {
    return [
      ExampleQuestion(
        question: 'What can you help me with?',
        config: ExampleQuestionConfig(
          onTap: (question) {
            final message = ChatMessage(
              text: 'What can you help me with?',
              user: _currentUser,
              createdAt: DateTime.now(),
            );
            _handleSendMessage(message);
          },
        ),
      ),
      ExampleQuestion(
        question: 'Show me streaming responses',
        config: ExampleQuestionConfig(
          onTap: (question) {
            final message = ChatMessage(
              text: 'Can you demonstrate streaming responses?',
              user: _currentUser,
              createdAt: DateTime.now(),
            );
            _handleSendMessage(message);
          },
        ),
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
      _streamingMessageId = messageId;

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

    setState(() {
      _latestMessageId = messageId; // Add this line
    });

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

  bool _isMessageStreaming(String messageId) {
    return _isStreaming && messageId == _streamingMessageId;
  }

  Widget _buildMessage(ChatMessage message) {
    if (_isMessageStreaming(message.customProperties?['id'])) {
      return StreamingTextMarkdown(
        text: message.text,
        // style: const TextStyle(color: Colors.black),
      );
    }
    return Text(message.text);
  }

  void _handleNewMessage(String text) {
    final messageId = DateTime.now().millisecondsSinceEpoch.toString();
    setState(() {
      _streamingMessageId = messageId;
      _isStreaming = true;
    });

    // Add message to chat with streaming animation
    _controller.addMessage(ChatMessage(
      text: text,
      user: _aiUser,
      createdAt: DateTime.now(),
      customProperties: {
        'id': messageId,
        'isStreaming': true,
      },
    ));

    // When streaming completes:
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isStreaming = false;
        _streamingMessageId = null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            messageTextBuilder:
                (final message, final previousMessage, final nextMessage) {
              final bool isStreaming =
                  message.customProperties?['isStreaming'] == true &&
                      message.customProperties?['id'] == _streamingMessageId;
              final bool isUser = message.user.id == _currentUser.id;
              final bool isLatestMessage =
                  message.customProperties?['id'] == _latestMessageId;

              return AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: message.text.isEmpty ? 0.0 : 1.0,
                child: AnimatedBubble(
                  key: ValueKey(message.createdAt.millisecondsSinceEpoch),
                  animate: false,
                  isUser: isUser,
                  child: isStreaming && !isUser
                      ? StreamingTextMarkdown(
                          key: ValueKey(
                              '${message.createdAt.millisecondsSinceEpoch}_${message.text.length}'),
                          text: message.text,
                          typingSpeed: const Duration(milliseconds: 50),
                          fadeInEnabled: true,
                        )
                      : AnimatedTextMessage(
                          key: ValueKey(
                              '${message.createdAt.millisecondsSinceEpoch}_${message.text.length}'),
                          text: message.text,
                          animate: !isStreaming &&
                              !isUser &&
                              isLatestMessage, // Update this line
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
