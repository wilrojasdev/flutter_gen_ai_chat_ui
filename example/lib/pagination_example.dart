import 'package:flutter/material.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';
import 'package:dash_chat_2/dash_chat_2.dart';

class PaginationExample extends StatefulWidget {
  const PaginationExample({super.key});

  @override
  State<PaginationExample> createState() => _PaginationExampleState();
}

class _PaginationExampleState extends State<PaginationExample> {
  late final ChatMessagesController _controller;
  final List<ChatMessage> _mockHistoricalMessages = [];
  bool _isLoading = false;
  static const int _messagesPerPage = 20;
  late final ChatUser _currentUser;
  late final ChatUser _aiUser;

  @override
  void initState() {
    super.initState();
    _currentUser = ChatUser(id: "user1", firstName: "User");
    _aiUser = ChatUser(id: "ai", firstName: "AI Assistant");

    _generateMockMessages();
    _controller = ChatMessagesController(
      initialMessages: _mockHistoricalMessages.take(_messagesPerPage).toList(),
      onLoadMoreMessages: _loadMoreMessages,
    );
  }

  void _generateMockMessages() {
    for (int i = 0; i < 100; i++) {
      _mockHistoricalMessages.add(
        ChatMessage(
          user: i % 2 == 0 ? _currentUser : _aiUser,
          text: "Historical message ${100 - i}",
          createdAt: DateTime.now().subtract(Duration(days: i)),
        ),
      );
    }
  }

  Future<void> _handleSendMessage(ChatMessage message) async {
    setState(() => _isLoading = true);
    _controller.addMessage(message);

    try {
      await Future.delayed(const Duration(seconds: 1));
      final response = ChatMessage(
        text: "Response to: ${message.text}",
        user: _aiUser,
        createdAt: DateTime.now(),
      );
      _controller.addMessage(response);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<List<ChatMessage>> _loadMoreMessages(ChatMessage? lastMessage) async {
    if (lastMessage == null) return [];

    // Find the index of the last message
    final lastIndex = _mockHistoricalMessages.indexWhere(
      (msg) => msg.createdAt == lastMessage.createdAt,
    );
    if (lastIndex == -1) return [];

    // Get next page of messages
    final nextIndex = lastIndex + 1;
    if (nextIndex >= _mockHistoricalMessages.length) return [];

    // Simulate loading delay
    await Future.delayed(const Duration(seconds: 1));

    return _mockHistoricalMessages
        .skip(nextIndex)
        .take(_messagesPerPage)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AiChatWidget(
        config: AiChatConfig(
          hintText: 'Type a message...',
          enablePagination: true,
          paginationLoadingIndicatorOffset: 100,
          loadMoreIndicator: ({bool isLoading = false}) => isLoading
              ? const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(child: CircularProgressIndicator()),
                )
              : const SizedBox.shrink(),
        ),
        controller: _controller,
        currentUser: _currentUser,
        aiUser: _aiUser,
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
