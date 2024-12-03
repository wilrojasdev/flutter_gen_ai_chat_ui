# Flutter Gen AI Chat UI Examples

This project contains example implementations of the Flutter Gen AI Chat UI package.

## Examples Included

### Simple Chat Example
Demonstrates basic chat functionality with minimal configuration:
- Basic message sending/receiving
- Default theme
- Simple UI controls

### Detailed Chat Example
Showcases advanced features:
- Custom theming
- Welcome messages
- Example questions
- Loading states
- Responsive layout
- Dark/Light mode support


Here's a basic example of how to implement the chat UI:

```dart
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';

class SimpleChatScreen extends StatefulWidget {
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
        // Handle message sending here
        return "Response to: $message";
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('AI Chat')),
      body: AiChatWidget(
        config: AiChatConfig(
          userName: 'User',
          aiName: 'AI Assistant',
          hintText: 'Type a message...',
        ),
        controller: _controller,
      ),
    );
  }
}
```

## 🔧 Advanced Usage

For more advanced usage, you can customize various aspects of the chat UI:

```dart
AiChatWidget(
  config: AiChatConfig(
    userName: 'User',
    aiName: 'AI Assistant',
    hintText: 'Type a message...',
    enableAnimation: true,
    showTimestamp: true,
    maxWidth: 900, // For desktop/tablet layouts
    exampleQuestions: [
      ChatExample(
        question: 'What is the weather like today?',
        onTap: (controller) {
          controller.handleExampleQuestion(
            'What is the weather like today?',
            ChatUser(id: '1', firstName: 'User'),
            ChatUser(id: '2', firstName: 'AI Assistant'),
          );
        },
      ),
    ],
    // Customize input decoration
    inputDecoration: InputDecoration(
      // Your custom decoration
    ),
  ),
  controller: _controller,
  // Custom welcome message
  welcomeMessageBuilder: () => YourCustomWelcomeWidget(),
),
```