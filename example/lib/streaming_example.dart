import 'package:flutter/material.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';
import 'package:flutter_streaming_text_markdown/flutter_streaming_text_markdown.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

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
        question: 'Can you demonstrate streaming responses?',
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

    // Add initial message with first word
    currentText = words[0];
    _controller.addMessage(
      ChatMessage(
        text: currentText,
        user: _aiUser,
        createdAt: DateTime.now(),
        customProperties: {
          'id': messageId,
          'isStreaming': true,
        },
        customBuilder: (context, message) {
          final bool isStreaming =
              message.customProperties?['isStreaming'] == true &&
                  message.customProperties?['id'] == _streamingMessageId;

          return StreamingTextMarkdown(
            key: ValueKey(
                '${message.createdAt.millisecondsSinceEpoch}_${message.text.length}'),
            text: message.text,
            typingSpeed: const Duration(milliseconds: 50),
            fadeInEnabled: true,
            styleSheet: MarkdownStyleSheet(
              p: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 15,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black87,
                  ),
            ),
          );
        },
      ),
    );

    setState(() {
      _latestMessageId = messageId;
    });

    // Stream remaining words
    for (final word in words.skip(1)) {
      if (!mounted) return;
      await Future.delayed(const Duration(milliseconds: 50));
      currentText += " $word";

      _controller.updateMessage(
        ChatMessage(
          text: currentText,
          user: _aiUser,
          createdAt: DateTime.now(),
          customProperties: {
            'id': messageId,
            'isStreaming': true,
          },
          customBuilder: (context, message) {
            final bool isStreaming =
                message.customProperties?['isStreaming'] == true &&
                    message.customProperties?['id'] == _streamingMessageId;

            return StreamingTextMarkdown(
              key: ValueKey(
                  '${message.createdAt.millisecondsSinceEpoch}_${message.text.length}'),
              text: message.text,
              typingSpeed: const Duration(milliseconds: 50),
              fadeInEnabled: true,
              styleSheet: MarkdownStyleSheet(
                p: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 15,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black87,
                    ),
              ),
            );
          },
        ),
      );
    }

    // Final message without streaming
    if (!mounted) return;
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Streaming Example')),
      body: AiChatWidget(
        config: AiChatConfig(
          aiName: 'AI',
          enableAnimation: true,
          enableMarkdownStreaming: true,
          streamingDuration: const Duration(milliseconds: 30),
          exampleQuestions: [
            ExampleQuestion(
              question: 'Tell me about markdown with code example',
              config: ExampleQuestionConfig(
                onTap: (question) => _handleExampleQuestion(question),
              ),
            ),
            ExampleQuestion(
              question: 'Show me a long response with streaming',
              config: ExampleQuestionConfig(
                onTap: (question) => _handleExampleQuestion(question),
              ),
            ),
          ],
        ),
        currentUser: _currentUser,
        aiUser: _aiUser,
        controller: _controller,
        onSendMessage: _handleSendMessage,
        isLoading: _isStreaming,
      ),
    );
  }

  Widget _buildAnimatedBubble({
    required Key key,
    required bool animate,
    required bool isUser,
    required Widget child,
  }) {
    return Container(
      key: key,
      padding: const EdgeInsets.all(8),
      child: child,
    );
  }

  Widget _buildAnimatedTextMessage({
    required Key key,
    required String text,
    required bool animate,
    required bool isUser,
    required bool isStreaming,
    required TextStyle style,
  }) {
    return Text(
      text,
      key: key,
      style: style,
    );
  }

  Widget _buildLoadingWidget() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  void dispose() {
    _loadingAnimationController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _handleExampleQuestion(String question) {
    final message = ChatMessage(
      text: question,
      user: const ChatUser(id: '1', name: 'User'),
      createdAt: DateTime.now(),
    );
    _handleSendMessage(message);
  }
}
