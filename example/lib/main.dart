import 'package:flutter/material.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';
import 'package:dash_chat_2/dash_chat_2.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ChatMessagesController _controller = ChatMessagesController();
  final ChatUser _currentUser = ChatUser(id: '1', firstName: 'User');
  final ChatUser _aiUser = ChatUser(id: '2', firstName: 'AI');
  bool _isDark = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(_isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              setState(() {
                _isDark = !_isDark;
              });
            },
          ),
        ],
      ),
      body: AiChatWidget(
        config: AiChatConfig(
          userName: 'User',
          aiName: 'AI Assistant',
          hintText: 'Type a message...',
          enableAnimation: true,
          showTimestamp: true,
          exampleQuestions: [
            ChatExample(
              question: 'This is an example message',
              onTap: (controller) {
                controller.handleExampleQuestion(
                  'This is an example message',
                  _currentUser,
                  _aiUser,
                );
              },
            ),
            ChatExample(
              question: 'This is another example message',
              onTap: (controller) {
                controller.handleExampleQuestion(
                  'This is another example message',
                  _currentUser,
                  _aiUser,
                );
              },
            ),
          ],
        ),
        currentUser: _currentUser,
        aiUser: _aiUser,
        controller: _controller,
        onSendMessage: (ChatMessage message) {
          // Handle sending message
          debugPrint('Message sent: ${message.text}');
        },
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).colorScheme.surface,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text('Example Buttons:'),
            TextButton(
              onPressed: () {
                _controller.clearMessages();
              },
              child: const Text('Clear'),
            ),
            TextButton(
              onPressed: () {
                _controller.addMessage(
                  ChatMessage(
                    text: 'Hello from AI!',
                    user: _aiUser,
                    createdAt: DateTime.now(),
                  ),
                );
              },
              child: const Text('Add AI Message'),
            ),
            TextButton(
              onPressed: () {
                _controller.addMessage(
                  ChatMessage(
                    text: 'Hello from User!',
                    user: _currentUser,
                    createdAt: DateTime.now(),
                  ),
                );
              },
              child: const Text('Add User Message'),
            ),
          ],
        ),
      ),
    );
  }
}
