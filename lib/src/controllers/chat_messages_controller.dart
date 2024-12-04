import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/foundation.dart';

class ChatMessagesController extends ChangeNotifier {
  List<ChatMessage> _messages = [];
  bool _showWelcomeMessage = true;

  bool _isLoadingMore = false;
  bool get isLoadingMore => _isLoadingMore;

  final Future<List<ChatMessage>> Function(ChatMessage? lastMessage)?
      onLoadMoreMessages;

  List<ChatMessage> get messages => _messages;
  bool get showWelcomeMessage => _showWelcomeMessage;

  ChatMessagesController({
    List<ChatMessage>? initialMessages,
    this.onLoadMoreMessages,
  }) {
    if (initialMessages != null && initialMessages.isNotEmpty) {
      _messages = List.from(initialMessages
          .reversed); // Reverse to show latest messages at bottom
      _showWelcomeMessage = false;
    }
  }

  void addMessage(ChatMessage message) {
    _messages.insert(0, message);
    _showWelcomeMessage = false;
    notifyListeners();
  }

  void setMessages(List<ChatMessage> messages) {
    _messages = messages;
    notifyListeners();
  }

  void clearMessages() {
    _messages.clear();
    _showWelcomeMessage = true;
    notifyListeners();
  }

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

  void handleExampleQuestion(String question, ChatUser user, ChatUser aiUser) {
    final message = ChatMessage(
      text: question,
      user: user,
      createdAt: DateTime.now(),
    );
    addMessage(message);

    // Create AI response message
    final aiMessage = ChatMessage(
      text: "This is a demo response to example question: $question",
      user: aiUser,
      createdAt: DateTime.now(),
    );
    addMessage(aiMessage);
  }
}
