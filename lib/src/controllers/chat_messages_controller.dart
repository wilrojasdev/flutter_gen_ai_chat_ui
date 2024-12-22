import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/foundation.dart';

/// Controller for managing chat messages and their states.
///
/// This controller handles message operations such as adding, updating,
/// and loading more messages. It also manages the welcome message state
/// and loading states for pagination.
class ChatMessagesController extends ChangeNotifier {
  /// Creates a new chat messages controller.
  ///
  /// [initialMessages] - Optional list of messages to initialize the chat with.
  /// [onLoadMoreMessages] - Optional callback to load more messages when
  ///  scrolling up.
  ChatMessagesController({
    final List<ChatMessage>? initialMessages,
    this.onLoadMoreMessages,
  }) {
    if (initialMessages != null && initialMessages.isNotEmpty) {
      _messages = List.from(initialMessages.reversed);
      _showWelcomeMessage = false;
    }
  }
  List<ChatMessage> _messages = [];
  bool _showWelcomeMessage = true;

  bool _isLoadingMore = false;

  /// Whether more messages are currently being loaded.
  bool get isLoadingMore => _isLoadingMore;

  /// Callback function to load more messages when scrolling up.
  final Future<List<ChatMessage>> Function(ChatMessage? lastMessage)?
      onLoadMoreMessages;

  /// List of all chat messages, ordered from newest to oldest.
  List<ChatMessage> get messages => _messages;

  /// Whether to show the welcome message.
  bool get showWelcomeMessage => _showWelcomeMessage;

  /// Adds a new message to the chat.
  ///
  /// The message is inserted at the beginning of the list (newest first).
  void addMessage(final ChatMessage message) {
    _messages.insert(0, message);
    _showWelcomeMessage = false;
    notifyListeners();
  }

  /// Updates an existing message or adds it if not found.
  ///
  /// Useful for updating streaming messages or editing existing ones.
  void updateMessage(final ChatMessage message) {
    final index = _messages.indexWhere(
      (final msg) =>
          msg.customProperties?['id'] == message.customProperties?['id'],
    );
    if (index != -1) {
      _messages[index] = message;
    } else {
      _messages.insert(0, message);
    }
    notifyListeners();
  }

  /// Replaces all existing messages with a new list.
  void setMessages(final List<ChatMessage> messages) {
    _messages = messages;
    notifyListeners();
  }

  /// Clears all messages and shows the welcome message.
  void clearMessages() {
    _messages.clear();
    _showWelcomeMessage = true;
    notifyListeners();
  }

  /// Loads more messages using the [onLoadMoreMessages] callback.
  ///
  /// Returns early if already loading or if no callback is provided.
  Future<void> loadMore() async {
    if (_isLoadingMore || onLoadMoreMessages == null) return;

    try {
      _isLoadingMore = true;
      notifyListeners();

      final lastMessage = _messages.isNotEmpty ? _messages.last : null;
      final moreMessages = await onLoadMoreMessages!(lastMessage);

      if (moreMessages.isNotEmpty) {
        _messages.addAll(moreMessages);
        notifyListeners();
      }
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  /// Handles an example question by creating and adding appropriate messages.
  void handleExampleQuestion(
    final String question,
    final ChatUser currentUser,
    final ChatUser aiUser,
  ) {
    final userMessage = ChatMessage(
      text: question,
      user: currentUser,
      createdAt: DateTime.now(),
    );
    addMessage(userMessage);

    final aiMessage = ChatMessage(
      text: 'I will help you with: $question',
      user: aiUser,
      createdAt: DateTime.now(),
    );
    addMessage(aiMessage);
  }
}
