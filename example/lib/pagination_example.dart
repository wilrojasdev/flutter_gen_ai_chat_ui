import 'package:flutter/material.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';
import 'dart:math' as Math;

/// A modern example demonstrating pagination in the chat UI.
/// Features:
/// - Automatic message loading when scrolling up
/// - Efficient message loading with pagination
/// - Proper state management
/// - Enhanced error handling
/// - Modern UI with loading states
/// - Customizable pagination settings
class PaginationExample extends StatefulWidget {
  const PaginationExample({super.key});

  @override
  State<PaginationExample> createState() => _PaginationExampleState();
}

class _PaginationExampleState extends State<PaginationExample> {
  // Constants
  static const int _messagesPerPage = 10;
  static const Duration _loadingDelay = Duration(milliseconds: 500);
  static const double _scrollThreshold =
      200.0; // Changed to pixels for better control

  // Controllers and Data
  late final ChatMessagesController _controller;
  final List<ChatMessage> _mockHistoricalMessages = [];
  final ScrollController _scrollController = ScrollController();

  // State Management
  bool _isLoading = false;
  bool _hasError = false;
  String? _errorMessage;
  bool _hasMoreMessages = true;
  bool _isLoadingMore = false;

  // Users
  late final ChatUser _currentUser;
  late final ChatUser _aiUser;

  @override
  void initState() {
    super.initState();
    _initializeUsers();
    _generateMockMessages();
    _initializeController();
    _setupScrollController();
  }

  void _setupScrollController() {
    _scrollController.addListener(() {
      // Load more when we're near the top (for chronological order)
      if (_scrollController.position.pixels <= _scrollThreshold &&
          !_isLoadingMore &&
          _hasMoreMessages) {
        _loadMoreMessages();
      }
    });
  }

  void _initializeUsers() {
    _currentUser = const ChatUser(
      id: "user1",
      name: "User",
      avatar: "https://ui-avatars.com/api/?name=User",
    );
    _aiUser = const ChatUser(
      id: "ai",
      name: "AI Assistant",
      avatar: "https://ui-avatars.com/api/?name=AI&background=10A37F&color=fff",
    );
  }

  void _generateMockMessages() {
    final topics = [
      'project updates',
      'meeting schedule',
      'task progress',
      'code review',
      'design feedback'
    ];

    // Generate messages from 1 to 100
    for (int i = 1; i <= 100; i++) {
      final topic = topics[(i - 1) % topics.length];
      final isUser = i % 2 == 0;

      final text = isUser
          ? 'Message #$i: Can you provide an update on $topic?'
          : 'Message #$i: Here\'s the latest update on $topic:\n\n'
              '• Progress is on track\n'
              '• Key milestones achieved\n'
              '• Next steps planned\n\n'
              'Would you like more specific details?';

      _mockHistoricalMessages.add(
        ChatMessage(
          user: isUser ? _currentUser : _aiUser,
          text: text,
          createdAt: DateTime.now().subtract(Duration(minutes: 100 - i)),
          customProperties: {
            'id': 'msg_$i',
            'messageNumber': i,
            'topic': topic,
          },
        ),
      );
    }
  }

  void _initializeController() {
    // Start with the latest messages (90-100)
    final initialMessages = _getLatestMessages();
    _controller = ChatMessagesController(
      initialMessages: initialMessages,
      paginationConfig: const PaginationConfig(
        enabled: true,
        messagesPerPage: _messagesPerPage,
        loadingDelay: _loadingDelay,
        reverseOrder: false, // Show in chronological order
        scrollThreshold: _scrollThreshold,
      ),
    );
  }

  List<ChatMessage> _getLatestMessages() {
    final startIndex =
        Math.max(0, _mockHistoricalMessages.length - _messagesPerPage);
    final endIndex = _mockHistoricalMessages.length;
    return _mockHistoricalMessages.sublist(startIndex, endIndex);
  }

  Future<void> _handleSendMessage(ChatMessage message) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _clearError();
    });

    try {
      final userMessage = _createMessage(
        message.text,
        _currentUser,
        _mockHistoricalMessages.length + 1,
      );
      _controller.addMessage(userMessage);
      _mockHistoricalMessages.add(userMessage);

      await Future.delayed(const Duration(seconds: 1));

      final aiMessage = _createMessage(
        _generateAIResponse(message.text),
        _aiUser,
        _mockHistoricalMessages.length + 1,
      );
      _controller.addMessage(aiMessage);
      _mockHistoricalMessages.add(aiMessage);
    } catch (e) {
      _showError("Failed to send message: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  ChatMessage _createMessage(String text, ChatUser user, int number) {
    return ChatMessage(
      text: text,
      user: user,
      createdAt: DateTime.now(),
      customProperties: {'id': 'msg_$number'},
    );
  }

  String _generateAIResponse(String userMessage) {
    return 'Thank you for your message: "$userMessage"\n\n'
        'I\'ve processed your request and here\'s a detailed response:\n\n'
        '1. Your message has been analyzed\n'
        '2. Context has been considered\n'
        '3. Appropriate response generated\n\n'
        'Would you like to know more about any specific aspect?';
  }

  Future<void> _loadMoreMessages() async {
    if (_isLoadingMore || !_hasMoreMessages) return;

    setState(() {
      _isLoadingMore = true;
      _clearError();
    });

    try {
      final currentMessages = _controller.messages;
      if (currentMessages.isEmpty) return;

      // Find the oldest message number we have
      final oldestMessage = currentMessages.last; // Changed from first to last
      final oldestMessageNumber =
          oldestMessage.customProperties?['messageNumber'] as int?;
      if (oldestMessageNumber == null) return;

      // Calculate the range for next batch
      final endIndex = oldestMessageNumber - 1;
      final startIndex = Math.max(0, endIndex - _messagesPerPage + 1);

      if (startIndex >= endIndex) {
        setState(() => _hasMoreMessages = false);
        return;
      }

      await Future.delayed(_loadingDelay);

      // Get older messages
      final olderMessages =
          _mockHistoricalMessages.getRange(startIndex, endIndex + 1).toList();

      _controller.addMessages(olderMessages);

      setState(() {
        _hasMoreMessages = startIndex > 0;
      });
    } catch (e) {
      _showError("Failed to load more messages: $e");
    } finally {
      if (mounted) {
        setState(() => _isLoadingMore = false);
      }
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    setState(() {
      _hasError = true;
      _errorMessage = message;
    });
    _scheduleErrorClear();
  }

  void _clearError() {
    _hasError = false;
    _errorMessage = null;
  }

  void _scheduleErrorClear() {
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) setState(() => _clearError());
    });
  }

  void _resetChat() {
    setState(() {
      _hasMoreMessages = true;
      _clearError();
      _controller.clearMessages();
      _controller.setMessages(_getLatestMessages());
    });
  }

  Widget _buildLoadingIndicator() {
    if (!_isLoadingMore) return const SizedBox.shrink();

    return const Padding(
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
    );
  }

  Widget _buildNoMoreMessages() {
    if (_hasMoreMessages) return const SizedBox.shrink();

    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        'No more messages',
        style: TextStyle(
          color: Colors.grey,
          fontSize: 12,
          fontStyle: FontStyle.italic,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pagination Example'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetChat,
            tooltip: 'Reset Chat',
          ),
        ],
      ),
      body: Column(
        children: [
          if (_hasError && _errorMessage != null) _buildErrorBar(),
          if (_isLoadingMore) _buildLoadingIndicator(),
          if (!_hasMoreMessages) _buildNoMoreMessages(),
          Expanded(
            child: AiChatWidget(
              config: AiChatConfig(
                aiName: 'AI Assistant',
                messageOptions: MessageOptions(
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? const Color(0xFF1E1E1E)
                        : const Color(0xFFF7F7F8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : const Color(0xFF353740),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                paginationConfig: const PaginationConfig(
                  enabled: true,
                  messagesPerPage: _messagesPerPage,
                  loadingDelay: _loadingDelay,
                  scrollThreshold: _scrollThreshold,
                  reverseOrder: false,
                ),
                loadingConfig: LoadingConfig(
                  isLoading: _isLoading,
                ),
              ),
              controller: _controller,
              currentUser: _currentUser,
              aiUser: _aiUser,
              onSendMessage: _handleSendMessage,
              scrollController: _scrollController,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorBar() {
    return Container(
      padding: const EdgeInsets.all(8),
      color: Colors.red.withOpacity(0.1),
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
            icon: const Icon(Icons.refresh),
            onPressed: _loadMoreMessages,
            tooltip: 'Retry',
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => setState(() => _clearError()),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }
}
