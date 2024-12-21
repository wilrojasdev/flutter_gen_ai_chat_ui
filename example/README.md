# Flutter Gen AI Chat UI Examples

This project contains example implementations of the Flutter Gen AI Chat UI package.

## Examples Included

### Streaming Example
Demonstrates streaming chat functionality:
- Word-by-word text streaming
- Smooth animations
- Loading indicators
- Basic theme support

### Custom Styling Example
Showcases advanced theming capabilities:
- Dark/Light mode toggle
- Custom color schemes
- Animated transitions
- Custom input field styling
- Custom send button
- Example questions
- Loading states with shimmer effect
- Responsive layout

### Markdown Example
Demonstrates markdown support in messages:
- Headers (h1, h2, h3)
- Bold and italic text
- Code blocks with syntax highlighting
- Lists (ordered and unordered)
- Links with custom styling
- Dark/Light mode compatible markdown

## Basic Implementation

Here's a basic example of how to implement the chat UI:

```dart
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';
import 'package:dash_chat_2/dash_chat_2.dart';

class SimpleChatScreen extends StatefulWidget {
  @override
  State<SimpleChatScreen> createState() => _SimpleChatScreenState();
}

class _SimpleChatScreenState extends State<SimpleChatScreen> {
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
  }

  Future<void> _handleSendMessage(ChatMessage message) async {
    setState(() => _isLoading = true);
    _controller.addMessage(message);

    try {
      // Add your AI response logic here
      final response = ChatMessage(
        text: "Response to: ${message.text}",
        user: _aiUser,
        createdAt: DateTime.now(),
      );
      _controller.addMessage(response);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('AI Chat')),
      body: AiChatWidget(
        config: AiChatConfig(
          hintText: 'Type a message...',
          enableAnimation: true,
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
```

## 🎨 Customization

Each example demonstrates different aspects of customization:

### Theme Customization
```dart
Theme(
  data: theme.copyWith(
    extensions: [
      CustomThemeExtension(
        chatBackground: isDark ? Color(0xFF171717) : Colors.grey[50]!,
        messageBubbleColor: isDark ? Color(0xFF262626) : Colors.white,
        userBubbleColor: isDark ? Color(0xFF1A4B8F) : Color(0xFFE3F2FD),
        messageTextColor: isDark ? Color(0xFFE5E5E5) : Colors.grey[800]!,
        inputBackgroundColor: isDark ? Color(0xFF262626) : Colors.white,
        inputBorderColor: isDark ? Color(0xFF404040) : Colors.grey[300]!,
        inputTextColor: isDark ? Colors.white : Colors.grey[800]!,
        hintTextColor: isDark ? Color(0xFF9CA3AF) : Colors.grey[600]!,
      ),
    ],
  ),
  child: AiChatWidget(...),
)
```

### Markdown Support
```dart
AiChatConfig(
  messageBuilder: (message) {
    final isUser = message.user.id == currentUser.id;
    return MarkdownBody(
      data: message.text,
      styleSheet: MarkdownStyleSheet(
        // Custom markdown styles
      ),
    );
  },
)
```

### Streaming Text
```dart
Future<void> handleSendMessage(ChatMessage message) async {
  // Create initial empty message
  final response = ChatMessage(
    text: "",
    user: aiUser,
    createdAt: DateTime.now(),
  );
  controller.addMessage(response);

  // Stream the response word by word
  final words = responseText.split(' ');
  String currentText = '';
  
  for (var word in words) {
    await Future.delayed(Duration(milliseconds: 50));
    currentText += (currentText.isEmpty ? '' : ' ') + word;
    // Update the message
    controller.updateMessage(currentText);
  }
}
```
```yaml
dependencies:
  flutter_gen_ai_chat_ui: ^1.1.1  # Latest version