import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/foundation.dart';

class ChatMessagesController extends ChangeNotifier {
  final Future<String> Function(String message) onSendMessage;
  final List<ChatMessage> _messages = [];
  bool _showWelcomeMessage = true;

  List<ChatMessage> get messages => _messages;
  bool get showWelcomeMessage => _showWelcomeMessage;

  ChatMessagesController({
    required this.onSendMessage,
  }) {
    _showWelcomeMessage = true; // Ensure it's true on initialization
  }

  Future<void> handleMessage(ChatMessage message, ChatUser aiUser) async {
    _messages.insert(0, message);
    _showWelcomeMessage = false;
    notifyListeners();

    try {
      final response = await onSendMessage(message.text);
      final aiMessage = ChatMessage(
        text: response,
        user: aiUser,
        createdAt: DateTime.now(),
      );
      _messages.insert(0, aiMessage);
      notifyListeners();
    } catch (e) {
      // Handle error
    }
  }

  void handleExampleQuestion(String question, ChatUser user, ChatUser aiUser) {
    final message = ChatMessage(
      text: question,
      user: user,
      createdAt: DateTime.now(),
    );
    handleMessage(message, aiUser);
  }

  void clearMessages() {
    _messages.clear();
    _showWelcomeMessage = true;
    notifyListeners();
  }
}
