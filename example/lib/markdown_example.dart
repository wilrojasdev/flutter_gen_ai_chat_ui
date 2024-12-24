import 'package:flutter/material.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

class MarkdownExample extends StatefulWidget {
  const MarkdownExample({super.key});

  @override
  State<MarkdownExample> createState() => _MarkdownExampleState();
}

class _MarkdownExampleState extends State<MarkdownExample> {
  late final ChatMessagesController _controller;
  late final ChatUser _currentUser;
  late final ChatUser _aiUser;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _currentUser = ChatUser(id: '1', firstName: 'User');
    _aiUser = ChatUser(id: '2', firstName: 'AI Assistant');
    _controller = ChatMessagesController();

    // Add initial message demonstrating markdown
    _controller.addMessage(ChatMessage(
      text: '''
Welcome! This chat supports markdown formatting. Here are some examples:

**Bold text** and *italic text*

# Headers
## Different
### Sizes

Lists:
- Item 1
- Item 2
  - Nested item
  
Code blocks:
```dart
void main() {
  print('Hello, World!');
}
```

And [links](https://flutter.dev) too!
''',
      user: _aiUser,
      createdAt: DateTime.now(),
    ));
  }

  Future<void> _handleSendMessage(ChatMessage message) async {
    setState(() => _isLoading = true);
    _controller.addMessage(message);

    try {
      // Simulate AI response with markdown
      await Future.delayed(const Duration(seconds: 1));
      final response = ChatMessage(
        text: '''Here's a response with markdown:

You said: *${message.text}*

Let me format that in a code block:
```
${message.text}
```

Need help? Here are some things you can try:
1. Use **bold** for emphasis
2. Create lists with - or numbers
3. Write code with `backticks`
''',
        user: _aiUser,
        createdAt: DateTime.now(),
      );
      _controller.addMessage(response);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildMarkdownMessage(ChatMessage message, bool isUser) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: MarkdownBody(
        data: message.text,
        styleSheet: MarkdownStyleSheet(
          p: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontSize: 16,
          ),
          code: TextStyle(
            backgroundColor: isUser
                ? (isDark ? Colors.blue[900] : Colors.blue[50])
                : (isDark ? Colors.grey[800] : Colors.grey[200]),
            color: isDark ? Colors.white : Colors.black87,
            fontSize: 14,
          ),
          codeblockDecoration: BoxDecoration(
            color: isUser
                ? (isDark ? Colors.blue[900] : Colors.blue[50])
                : (isDark ? Colors.grey[800] : Colors.grey[200]),
            borderRadius: BorderRadius.circular(8),
          ),
          blockquote: TextStyle(
            color: (isDark ? Colors.white70 : Colors.black54),
            fontSize: 16,
          ),
          listBullet: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontSize: 16,
          ),
          h1: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          h2: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          h3: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          em: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontStyle: FontStyle.italic,
          ),
          strong: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
          ),
          a: TextStyle(
            color: isDark ? Colors.lightBlue[300] : Colors.blue,
            decoration: TextDecoration.underline,
          ),
        ),
        onTapLink: (text, href, title) {
          if (href != null) {
            launchUrl(Uri.parse(href));
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AiChatWidget(
        config: AiChatConfig(
          hintText: 'Try using **markdown** in your message...',
          // Custom message builder for markdown support
          messageBuilder: (message) {
            final isUser = message.user.id == _currentUser.id;
            return _buildMarkdownMessage(message, isUser);
          },
        ),
        controller: _controller,
        currentUser: _currentUser,
        aiUser: _aiUser,
        onSendMessage: _handleSendMessage,
        isLoading: _isLoading,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
