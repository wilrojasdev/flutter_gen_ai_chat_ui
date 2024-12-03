import 'package:flutter/material.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';
import 'simple_chat_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: SimpleChatScreen());
  }
}

class SimpleChatScreen extends StatefulWidget {
  const SimpleChatScreen({super.key});

  @override
  State<SimpleChatScreen> createState() => _SimpleChatScreenState();
}

class _SimpleChatScreenState extends State<SimpleChatScreen> {
  late final ChatMessagesController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ChatMessagesController(
      onSendMessage: (message) async {
        await Future.delayed(const Duration(seconds: 1));
        return "This is a demo response to: $message";
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple AI Chat'),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        // leading: IconButton(
        //   icon: const Icon(Icons.punch_clock_outlined),
        //   onPressed: () => LoadingWidget.show(context),
        // ),
      ),
      body: AiChatWidget(
        config: const AiChatConfig(
          userName: 'User',
          aiName: 'AI Assistant',
          hintText: 'Type a message...',
          enableAnimation: true,
        ),
        controller: _controller,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
