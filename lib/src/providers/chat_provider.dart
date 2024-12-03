import 'package:flutter/material.dart';
import 'package:dash_chat_2/dash_chat_2.dart';

class ChatProvider with ChangeNotifier {
  final List<ChatMessage> _messages = [];
  final ChatUser _user = ChatUser(id: '1', firstName: 'User');
  final ChatUser _aiUser = ChatUser(id: '2', firstName: 'AI');
  bool _showWelcomeMessage = true;
  String _currentSessionId = '';

  List<ChatMessage> get messages => _messages;
  bool get showWelcomeMessage => _showWelcomeMessage;
  String get currentSessionId => _currentSessionId;

  ChatProvider() {
    _createNewSession();
  }

  void _createNewSession() {
    _currentSessionId = DateTime.now().millisecondsSinceEpoch.toString();
  }

  ChatMessage _createMessage({
    required ChatUser user,
    required String text,
    String? sessionId,
  }) {
    return ChatMessage(
      user: user,
      text: text,
      createdAt: DateTime.now(),
      customProperties: {
        'sessionId': sessionId ?? _currentSessionId,
      },
    );
  }

  void handleExampleQuestionTap(String question) {
    final message = _createMessage(
      user: _user,
      text: question,
    );
    _messages.insert(0, message);
    _showWelcomeMessage = false;
    notifyListeners();
  }

  Future<void> handleSend(
      ChatMessage message, Future<String> Function(String) onAiResponse) async {
    final userMessage = _createMessage(
      user: _user,
      text: message.text,
    );
    _messages.insert(0, userMessage);
    _showWelcomeMessage = false;
    notifyListeners();

    try {
      final aiResponse = await onAiResponse(message.text);
      _messages.insert(
        0,
        _createMessage(
          user: _aiUser,
          text: aiResponse,
        ),
      );
      notifyListeners();
    } catch (e) {
      // Handle error
    }
  }

  Future<void> handleExampleQuestionTapWithResponse(
      String question, Future<String> Function(String) onAiResponse) async {
    final userMessage = _createMessage(
      user: _user,
      text: question,
    );
    _messages.insert(0, userMessage);
    _showWelcomeMessage = false;
    notifyListeners();

    try {
      final aiResponse = await onAiResponse(question);
      _messages.insert(
        0,
        _createMessage(
          user: _aiUser,
          text: aiResponse,
        ),
      );
      notifyListeners();
    } catch (e) {
      // Handle error
    }
  }

  List<ChatMessage> getMessagesForSession(String sessionId) {
    return _messages
        .where((msg) => msg.customProperties?['sessionId'] == sessionId)
        .toList();
  }

  void startNewSession() {
    _createNewSession();
    notifyListeners();
  }
}
