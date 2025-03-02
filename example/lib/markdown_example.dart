import 'package:flutter/material.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';
import 'package:flutter_markdown/flutter_markdown.dart'
    show MarkdownBody, MarkdownStyleSheet;
import 'package:url_launcher/url_launcher.dart';

/// A comprehensive example demonstrating markdown support in the chat UI.
/// This example shows various markdown features including:
/// - Text formatting (bold, italic, strikethrough)
/// - Headers
/// - Lists (ordered and unordered)
/// - Code blocks with syntax highlighting
/// - Blockquotes
/// - Links
/// - Tables
class MarkdownExample extends StatefulWidget {
  const MarkdownExample({super.key});

  @override
  State<MarkdownExample> createState() => _MarkdownExampleState();
}

class _MarkdownExampleState extends State<MarkdownExample> {
  /// Controller for managing chat messages
  late final ChatMessagesController _controller;

  /// Current user instance
  late final ChatUser _currentUser;

  /// AI assistant user instance
  late final ChatUser _aiUser;

  /// Loading state for AI responses
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeChat();
    _addWelcomeMessage();
  }

  /// Initialize chat users and controller
  void _initializeChat() {
    _currentUser = const ChatUser(id: '1', name: 'User');
    _aiUser = const ChatUser(id: '2', name: 'AI Assistant');
    _controller = ChatMessagesController();
  }

  /// Add initial welcome message with markdown examples
  void _addWelcomeMessage() {
    _controller.addMessage(ChatMessage(
      text: '''
# Welcome to Markdown Chat! 👋

This chat supports rich markdown formatting. Here are some examples:

## Text Formatting
- **Bold text** for emphasis
- *Italic text* for subtle emphasis
- ~~Strikethrough~~ for crossed-out text
- `inline code` for code snippets

## Lists
1. Ordered lists
2. With multiple items
   - And nested items
   - Using different markers

## Code Blocks
```dart
void main() {
  print('Hello, Markdown!');
  
  // With syntax highlighting
  final message = ChatMessage(
    text: '**Bold** and *italic*',
    isMarkdown: true,
  );
}
```

## Blockquotes
> Important information can be highlighted
> Using blockquotes like this

## Tables
| Feature | Support |
|---------|---------|
| Bold | ✅ |
| Italic | ✅ |
| Code | ✅ |

## Links
Learn more about [Flutter](https://flutter.dev) and [Markdown](https://www.markdownguide.org)

---
Try sending a message with markdown formatting!
''',
      user: _aiUser,
      createdAt: DateTime.now(),
      isMarkdown: true,
    ));
  }

  /// Handle sending a new message
  /// This includes:
  /// 1. Adding user message to chat
  /// 2. Showing loading state
  /// 3. Simulating AI response with markdown formatting
  /// 4. Error handling for markdown parsing
  Future<void> _handleSendMessage(ChatMessage message) async {
    setState(() => _isLoading = true);

    try {
      // Add user message
      _controller.addMessage(message);

      // Simulate AI response
      await Future.delayed(const Duration(seconds: 1));

      // Format AI response with markdown
      final response = ChatMessage(
        text: '''### Message Analysis

You said: *${message.text}*

Let me format that in different ways:

1. **Code Block**:
```
${message.text}
```

2. *Blockquote*:
> ${message.text}

3. **Table**:
| Type | Content |
|------|---------|
| Original | ${message.text} |
| Uppercase | ${message.text.toUpperCase()} |

---
**Markdown Tips:**
- Use `**text**` for **bold**
- Use `*text*` for *italic*
- Use ```code``` for code blocks
- Use `> text` for blockquotes
''',
        user: _aiUser,
        createdAt: DateTime.now(),
        isMarkdown: true,
      );

      _controller.addMessage(response);
    } catch (e) {
      // Handle any errors during message processing
      _controller.addMessage(ChatMessage(
        text: '⚠️ Error processing markdown: $e',
        user: _aiUser,
        createdAt: DateTime.now(),
      ));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AiChatWidget(
        config: AiChatConfig(
          aiName: 'AI Assistant',
          // Custom hint text showing markdown support
          hintText: 'Try using **markdown** in your message...',
          // Loading configuration
          loadingConfig: LoadingConfig(
            isLoading: _isLoading,
          ),
          // Custom message builder with markdown support
          messageBuilder: (message) => message.isMarkdown == true
              ? MarkdownBody(
                  data: message.text,
                  selectable: true,
                  onTapLink: (text, href, title) {
                    if (href != null) {
                      launchUrl(Uri.parse(href));
                    }
                  },
                  styleSheet: MarkdownStyleSheet(
                    // Customize markdown styling here
                    p: const TextStyle(fontSize: 16),
                    code: const TextStyle(
                      backgroundColor: Colors.black12,
                      fontFamily: 'monospace',
                    ),
                    h1: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    h2: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    h3: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    blockquote: const TextStyle(
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                    tableBody: const TextStyle(fontSize: 16),
                  ),
                )
              : SelectableText(message.text),
        ),
        controller: _controller,
        currentUser: _currentUser,
        aiUser: _aiUser,
        onSendMessage: _handleSendMessage,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
