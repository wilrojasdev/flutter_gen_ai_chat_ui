import 'chat_user.dart';

class ChatMessage {
  final String text;
  final ChatUser user;
  final DateTime createdAt;
  final bool isMarkdown;
  final Map<String, dynamic>? customProperties;

  const ChatMessage({
    required this.text,
    required this.user,
    required this.createdAt,
    this.isMarkdown = false,
    this.customProperties,
  });

  /// Creates a copy of this message with the given fields replaced with new values
  ChatMessage copyWith({
    String? text,
    ChatUser? user,
    DateTime? createdAt,
    bool? isMarkdown,
    Map<String, dynamic>? customProperties,
  }) =>
      ChatMessage(
        text: text ?? this.text,
        user: user ?? this.user,
        createdAt: createdAt ?? this.createdAt,
        isMarkdown: isMarkdown ?? this.isMarkdown,
        customProperties: customProperties ?? this.customProperties,
      );
}
