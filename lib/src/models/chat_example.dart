import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';

class ChatExample {
  final String question;
  final Function(ChatMessagesController) onTap;

  const ChatExample({
    required this.question,
    required this.onTap,
  });
}
