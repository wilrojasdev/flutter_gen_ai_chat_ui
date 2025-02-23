import 'package:flutter/foundation.dart';
import '../models/chat/models.dart';
import '../models/ai_chat_config.dart';

/// Controller for managing chat messages and their states.
///
/// This controller handles message operations such as adding, updating,
/// and loading more messages. It also manages the welcome message state
/// and loading states for pagination.
class ChatMessagesController extends ChangeNotifier {
  /// Creates a new chat messages controller.
  ///
  /// [initialMessages] - Optional list of messages to initialize the chat with.
  /// [paginationConfig] - Configuration for pagination behavior.
  ChatMessagesController({
    final List<ChatMessage>? initialMessages,
    this.paginationConfig = const PaginationConfig(),
  }) {
    if (initialMessages != null && initialMessages.isNotEmpty) {
      _messages = List.from(paginationConfig.reverseOrder
          ? initialMessages
          : initialMessages.reversed);
      _messageCache = {for (var m in _messages) _getMessageId(m): m};
      _showWelcomeMessage = false;
    }
  }

  /// Configuration for pagination behavior
  final PaginationConfig paginationConfig;

  List<ChatMessage> _messages = [];
  Map<String, ChatMessage> _messageCache = {};
  bool _showWelcomeMessage = true;
  bool _isLoadingMore = false;
  bool _hasMoreMessages = true;
  int _currentPage = 1;

  /// Whether more messages are currently being loaded.
  bool get isLoadingMore => _isLoadingMore;

  /// Whether there are more messages to load.
  bool get hasMoreMessages => _hasMoreMessages;

  /// List of all chat messages, ordered from newest to oldest.
  List<ChatMessage> get messages => _messages;

  /// Whether to show the welcome message.
  bool get showWelcomeMessage => _showWelcomeMessage;

  /// Current page of pagination
  int get currentPage => _currentPage;

  /// Generates a unique ID for a message
  String _getMessageId(ChatMessage message) {
    final customId = message.customProperties?['id'] as String?;
    return customId ??
        '${message.user.id}_${message.createdAt.millisecondsSinceEpoch}_${message.text.hashCode}';
  }

  /// Adds a new message to the chat.
  void addMessage(ChatMessage message) {
    final messageId = _getMessageId(message);
    if (!_messageCache.containsKey(messageId)) {
      if (paginationConfig.reverseOrder) {
        _messages.insert(0, message);
      } else {
        _messages.insert(0, message);
      }
      _messageCache[messageId] = message;
      notifyListeners();
    }
  }

  /// Adds multiple messages to the chat at once.
  void addMessages(List<ChatMessage> messages) {
    bool hasNewMessages = false;
    final messagesToAdd = messages;

    for (final message in messagesToAdd) {
      final messageId = _getMessageId(message);
      if (!_messageCache.containsKey(messageId)) {
        if (paginationConfig.reverseOrder) {
          _messages.add(message);
        } else {
          _messages.insert(0, message);
        }
        _messageCache[messageId] = message;
        hasNewMessages = true;
      }
    }

    if (hasNewMessages) {
      notifyListeners();
    }
  }

  /// Updates an existing message or adds it if not found.
  ///
  /// Useful for updating streaming messages or editing existing ones.
  void updateMessage(final ChatMessage message) {
    final customId = message.customProperties?['id'] as String?;
    final messageId = customId ?? _getMessageId(message);
    final index = _messages.indexWhere(
      (final msg) => _getMessageId(msg) == messageId,
    );

    if (index != -1) {
      _messages[index] = message;
      _messageCache[messageId] = message;
    } else {
      if (paginationConfig.reverseOrder) {
        _messages.insert(0, message);
      } else {
        _messages.add(message);
      }
      _messageCache[messageId] = message;
    }
    notifyListeners();
  }

  /// Replaces all existing messages with a new list.
  void setMessages(List<ChatMessage> messages) {
    _messages =
        List.from(paginationConfig.reverseOrder ? messages : messages.reversed);
    _messageCache = {for (var m in messages) _getMessageId(m): m};
    _currentPage = 1;
    notifyListeners();
  }

  /// Clears all messages and shows the welcome message.
  void clearMessages() {
    _messages.clear();
    _messageCache.clear();
    _currentPage = 1;
    _hasMoreMessages = true;
    notifyListeners();
  }

  /// Loads more messages using the provided callback.
  ///
  /// Returns early if already loading or no more messages.
  /// The callback should return a list of messages to add.
  Future<void> loadMore(
      Future<List<ChatMessage>> Function() loadCallback) async {
    if (_isLoadingMore || !_hasMoreMessages || !paginationConfig.enabled) {
      return;
    }

    try {
      _isLoadingMore = true;
      notifyListeners();

      await Future.delayed(paginationConfig.loadingDelay);

      final moreMessages = await loadCallback();

      if (moreMessages.isEmpty) {
        _hasMoreMessages = false;
      } else {
        addMessages(moreMessages);
        _currentPage++;
      }
    } catch (e) {
      _hasMoreMessages = true; // Allow retry on error
      rethrow;
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  /// Resets pagination state
  void resetPagination() {
    _hasMoreMessages = true;
    _currentPage = 1;
    notifyListeners();
  }

  /// Handles an example question by creating and adding appropriate messages.
  void handleExampleQuestion(
      String question, ChatUser currentUser, ChatUser aiUser) {
    hideWelcomeMessage();
    addMessage(
      ChatMessage(
        text: question,
        user: currentUser,
        createdAt: DateTime.now(),
      ),
    );
  }

  void hideWelcomeMessage() {
    _showWelcomeMessage = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _messages.clear();
    _messageCache.clear();
    super.dispose();
  }
}
