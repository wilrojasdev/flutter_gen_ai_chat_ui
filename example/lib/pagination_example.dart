import 'package:flutter/material.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';

/// A comprehensive example demonstrating pagination in the chat UI.
/// This example shows:
/// - Loading historical messages with pagination
/// - Proper loading states and indicators
/// - Error handling for failed loads
/// - Customizable pagination settings
class PaginationExample extends StatefulWidget {
  const PaginationExample({super.key});

  @override
  State<PaginationExample> createState() => _PaginationExampleState();
}

class _PaginationExampleState extends State<PaginationExample> {
  late final ChatMessagesController _controller;
  final List<ChatMessage> _mockHistoricalMessages = [];
  bool _isLoading = false;
  bool _hasError = false;
  String? _errorMessage;
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

  /// Generates mock historical messages for demonstration
  void _generateMockMessages() {
    for (int i = 0; i < 100; i++) {
      _mockHistoricalMessages.add(
        ChatMessage(
          user: i % 2 == 0 ? _currentUser : _aiUser,
          text:
              "Historical message ${100 - i} - This is a longer message to demonstrate how pagination handles messages of different lengths. Some messages might contain more content than others.",
          createdAt: DateTime.now().subtract(Duration(days: i)),
        ),
      );
    }
  }

  /// Handles sending a new message
  /// Shows proper loading states and error handling
  Future<void> _handleSendMessage(ChatMessage message) async {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = null;
    });

    try {
      _controller.addMessage(message);
      await Future.delayed(const Duration(seconds: 1));

      final response = ChatMessage(
        text:
            "Response to: ${message.text}\n\nThis is a detailed response to demonstrate message handling. Try scrolling up to load more historical messages!",
        user: _aiUser,
        createdAt: DateTime.now(),
      );
      _controller.addMessage(response);
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = "Failed to send message: $e";
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Loads more historical messages when scrolling up
  /// Includes error handling and proper loading states
  Future<List<ChatMessage>> _loadMoreMessages(ChatMessage? lastMessage) async {
    if (lastMessage == null) return [];

    try {
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
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = "Failed to load more messages: $e";
      });
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          if (_hasError && _errorMessage != null)
            Container(
              padding: const EdgeInsets.all(8),
              color: Colors.red.withValues(alpha: 26),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.red),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => setState(() {
                      _hasError = false;
                      _errorMessage = null;
                    }),
                  ),
                ],
              ),
            ),
          Expanded(
            child: AiChatWidget(
              config: AiChatConfig(
                hintText: 'Type a message...',
                // Pagination configuration
                paginationConfig: PaginationConfig(
                  enabled: true,
                  loadingIndicatorOffset: 100,
                  loadMoreIndicator: ({bool isLoading = false}) => isLoading
                      ? const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(height: 8),
                                Text(
                                  'Loading more messages...',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
                // Message display configuration
                messageOptions: MessageOptions(
                  showTime: true,
                  containerColor:
                      Theme.of(context).brightness == Brightness.dark
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
                ),
                // Welcome message configuration
                welcomeMessageConfig: const WelcomeMessageConfig(
                  title: 'Pagination Example',
                  questionsSectionTitle:
                      'Try scrolling up to load more historical messages!',
                ),
              ),
              controller: _controller,
              currentUser: _currentUser,
              aiUser: _aiUser,
              onSendMessage: _handleSendMessage,
              isLoading: _isLoading,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
