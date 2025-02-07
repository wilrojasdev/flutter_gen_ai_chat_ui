import 'package:flutter/material.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';

class DetailedExample extends StatefulWidget {
  const DetailedExample({super.key});

  @override
  State<DetailedExample> createState() => _DetailedExampleState();
}

class _DetailedExampleState extends State<DetailedExample> {
  late final ChatMessagesController messagesController;
  late final List<ExampleQuestion> exampleQuestions;
  late final ChatUser _currentUser;
  late final ChatUser _aiUser;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _currentUser = ChatUser(id: '1', firstName: 'User');
    _aiUser = ChatUser(id: '2', firstName: 'AI Assistant');

    final initialMessages = [
      ChatMessage(
        text:
            "Hello! I'm your AI assistant. I can help you with various tasks and answer your questions.",
        user: _aiUser,
        createdAt: DateTime.now().subtract(const Duration(minutes: 1)),
      ),
    ];

    messagesController = ChatMessagesController(
      initialMessages: initialMessages,
      onLoadMoreMessages: _loadMoreMessages,
    );
    exampleQuestions = _createExampleQuestions();
  }

  Future<List<ChatMessage>> _loadMoreMessages(ChatMessage? lastMessage) async {
    setState(() => _isLoading = true);
    try {
      await Future.delayed(const Duration(seconds: 1));
      return List.generate(10, (index) {
        final isUser = index.isEven;
        final daysAgo = index ~/ 2 + 1;
        return ChatMessage(
          text: isUser
              ? "This is a historical user message from $daysAgo days ago."
              : "This is a historical AI response with detailed information and formatting examples.",
          user: isUser ? _currentUser : _aiUser,
          createdAt: DateTime.now().subtract(Duration(days: daysAgo)),
        );
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleSendMessage(ChatMessage message) async {
    setState(() => _isLoading = true);
    // Add user message with current timestamp
    final userMessage = ChatMessage(
      text: message.text,
      user: _currentUser,
      createdAt: DateTime.now(),
    );
    messagesController.addMessage(userMessage);

    try {
      // Simulate AI thinking time
      await Future.delayed(const Duration(seconds: 2));

      final response = ChatMessage(
        text: """Thank you for your message. Let me help you with that.

${message.text}

I'm demonstrating different formatting capabilities:
• Bullet points for organization
• Support for multiple paragraphs
• Code examples when needed

Would you like to know more about any specific aspect?""",
        user: _aiUser,
        createdAt: DateTime.now(),
      );
      messagesController.addMessage(response);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  List<ExampleQuestion> _createExampleQuestions() {
    return [
      ExampleQuestion(
        question: 'What can you help me with?',
        config: ExampleQuestionConfig(
          onTap: (question) {
            final message = ChatMessage(
              text: question,
              user: _currentUser,
              createdAt: DateTime.now(),
            );
            _handleSendMessage(message);
          },
        ),
      ),
      ExampleQuestion(
        question: 'Show formatting examples',
        config: ExampleQuestionConfig(
          onTap: (question) {
            final message = ChatMessage(
              text: question,
              user: _currentUser,
              createdAt: DateTime.now(),
            );
            _handleSendMessage(message);
          },
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(
      extensions: [
        CustomThemeExtension(
          chatBackground: Theme.of(context).scaffoldBackgroundColor,
          messageBubbleColor: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF1E1E1E)
              : const Color(0xFFF7F7F8),
          userBubbleColor: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF7B61FF)
              : const Color(0xFF10A37F),
          messageTextColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : const Color(0xFF353740),
          inputBackgroundColor: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF1E1E1E)
              : Colors.white,
          inputBorderColor: Theme.of(context).brightness == Brightness.dark
              ? Theme.of(context).colorScheme.outline
              : const Color(0xFFD9D9E3),
          inputTextColor: Theme.of(context).brightness == Brightness.dark
              ? Theme.of(context).colorScheme.onSurface
              : const Color(0xFF353740),
          hintTextColor: const Color(0xFF8E8EA0),
          backToBottomButtonColor:
              Theme.of(context).brightness == Brightness.dark
                  ? Theme.of(context).colorScheme.primary
                  : const Color(0xFF10A37F),
          sendButtonColor: Colors.transparent,
          sendButtonIconColor: Theme.of(context).brightness == Brightness.dark
              ? Theme.of(context).colorScheme.primary
              : const Color(0xFF10A37F),
        ),
      ],
    );

    return Theme(
      data: theme,
      child: Scaffold(
        body: AiChatWidget(
          currentUser: _currentUser,
          aiUser: _aiUser,
          controller: messagesController,
          onSendMessage: _handleSendMessage,
          isLoading: _isLoading,
          loadingIndicator: LoadingWidget(
            texts: const [
              'AI is thinking...',
              'Processing your message...',
              'Generating response...',
              'Almost there...',
            ],
            interval: const Duration(seconds: 2),
            textStyle: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.1,
            ),
            shimmerBaseColor: Theme.of(context)
                .colorScheme
                .surfaceContainerHighest
                .withValues(alpha: 128),
            shimmerHighlightColor: Theme.of(context).colorScheme.surface,
          ),
          config: AiChatConfig(
            hintText: 'Send a message',
            messageOptions: MessageOptions(
              containerColor: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFF1E1E1E)
                  : const Color(0xFFF7F7F8),
              currentUserContainerColor:
                  Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFF7B61FF)
                      : const Color(0xFF10A37F),
              textColor: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : const Color(0xFF353740),
              currentUserTextColor: Colors.white,
              messagePadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              showCurrentUserAvatar: false,
              showOtherUsersAvatar: true,
              showTime: true,
              timeTextColor: const Color(0xFF8E8EA0),
              currentUserTimeTextColor: const Color(0xFF8E8EA0),
              borderRadius: 12,
            ),
            enableAnimation: true,
            showTimestamp: true,
            inputDecoration: InputDecoration(
              hintText: 'Send a message',
              hintStyle: const TextStyle(
                color: Color(0xFF8E8EA0),
              ),
              filled: true,
              fillColor: Theme.of(context).brightness == Brightness.dark
                  ? Theme.of(context).colorScheme.surface
                  : Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Theme.of(context).colorScheme.outline
                      : const Color(0xFFD9D9E3),
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Theme.of(context).colorScheme.outline
                      : const Color(0xFFD9D9E3),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Theme.of(context).colorScheme.primary
                      : const Color(0xFF10A37F),
                  width: 1.5,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            sendButtonIcon: Icons.send_rounded,
            sendButtonIconSize: 24,
            sendButtonPadding: const EdgeInsets.all(8),
            sendButtonBuilder: (onSend) => Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                icon: Icon(
                  Icons.send_rounded,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Theme.of(context).colorScheme.primary
                      : const Color(0xFF10A37F),
                  size: 24,
                ),
                onPressed: onSend,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    messagesController.dispose();
    super.dispose();
  }
}
