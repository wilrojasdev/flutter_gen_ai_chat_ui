import 'dart:async';
import 'dart:math';

class MockAiService {
  final Random _random = Random();

  // Simulate a delay
  Future<void> _simulateDelay(
      [int minMillis = 300, int maxMillis = 800]) async {
    final delay = minMillis + _random.nextInt(maxMillis - minMillis);
    await Future.delayed(Duration(milliseconds: delay));
  }

  // Get a standard response based on the input
  Future<String> getResponse(String input,
      {bool includeCodeBlock = true}) async {
    await _simulateDelay(500, 1500);

    // Convert to lowercase for easier matching
    final lowerInput = input.toLowerCase();

    // Check for specific keywords to determine response type
    if (lowerInput.contains('hello') || lowerInput.contains('hi')) {
      return 'Hello! How can I assist you today?';
    } else if (lowerInput.contains('name')) {
      return "I'm an AI assistant created to showcase the Flutter Gen AI Chat UI package.";
    } else if (lowerInput.contains('code') || lowerInput.contains('example')) {
      if (includeCodeBlock) {
        return '''
Here's an example of a Flutter StatefulWidget:

```dart
class MyWidget extends StatefulWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  int _counter = 0;
  
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Count: \$_counter'),
        ElevatedButton(
          onPressed: _incrementCounter,
          child: const Text('Increment'),
        ),
      ],
    );
  }
}
```

You can use this widget in your app by placing it in a parent widget.
''';
      } else {
        return 'I could show you a code example, but code blocks are currently disabled in the settings.';
      }
    } else if (lowerInput.contains('markdown')) {
      return '''
# Markdown Support

This package supports markdown formatting with:

## Headers

- **Bold text** for emphasis
- *Italic text* for subtle emphasis
- ~~Strikethrough~~ for removed content

### Lists
1. First item
2. Second item
3. Third item

### Links
[Flutter Website](https://flutter.dev)

### Blockquotes
> This is a blockquote that can be used to highlight important information.

And much more!
''';
    } else if (lowerInput.contains('features') ||
        lowerInput.contains('capabilities')) {
      return '''
# Features of this Chat UI

This package includes:

1. **Streaming Text**: Word-by-word animation for a more natural conversation
2. **Markdown Support**: Rich formatting of messages
3. **Code Highlighting**: Syntax highlighting for code blocks
4. **Customizable Themes**: Light/dark mode support
5. **Custom Avatars**: Ability to set user and AI avatars
6. **Message Controls**: Options for editing and deleting messages
7. **Responsive Layout**: Works on all screen sizes

You can customize all these features through the `AiChatConfig` class.
''';
    } else {
      // Default response with markdown formatting
      return "I'm not sure how to respond to that. You can ask me about:\n\n- Code examples\n- Markdown formatting\n- Features of this chat UI\n\nOr just say hello!";
    }
  }

  // Stream a response word by word
  Stream<String> streamResponse(String input,
      {bool includeCodeBlock = true}) async* {
    final fullResponse =
        await getResponse(input, includeCodeBlock: includeCodeBlock);
    final words = fullResponse.split(' ');

    var accumulatedText = '';

    for (final word in words) {
      await _simulateDelay(50, 200);
      accumulatedText += (accumulatedText.isEmpty ? '' : ' ') + word;
      yield accumulatedText;
    }
  }
}
