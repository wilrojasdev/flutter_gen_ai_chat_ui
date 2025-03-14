import 'dart:async';
import 'dart:math';

class MockAiService {
  final Random _random = Random();

  // Simulate a natural delay
  Future<void> _simulateDelay(
      [int minMillis = 300, int maxMillis = 800]) async {
    final delay = minMillis + _random.nextInt(maxMillis - minMillis);
    await Future.delayed(Duration(milliseconds: delay));
  }

  // Get a professional response based on the input
  Future<String> getResponse(String input,
      {bool includeCodeBlock = true}) async {
    // Increase the initial delay to make loading more visible
    await _simulateDelay(1200, 2500);

    // Convert to lowercase for easier matching
    final lowerInput = input.toLowerCase();

    // Check for specific keywords to determine response type
    if (lowerInput.contains('hello') || lowerInput.contains('hi')) {
      return 'Hello! 👋 I\'m Dila, your AI assistant. How can I help you today?';
    } else if (lowerInput.contains('name') ||
        lowerInput.contains('who are you')) {
      return "I'm Dila, an AI assistant designed to showcase Flutter Gen AI Chat UI. I can provide information, code examples, and explain concepts in a friendly and helpful way.";
    } else if (lowerInput.contains('help') ||
        lowerInput.contains('what can you do')) {
      return '''
# How Dila Can Help You

I can assist with a variety of tasks:

1. **Answer Questions** - Ask me about Flutter, coding, or general information
2. **Provide Code Examples** - Request sample code for common patterns
3. **Explain Concepts** - Get clear explanations on technical topics
4. **Demonstrate Features** - Show the capabilities of this chat UI

Feel free to try any of these or ask something specific!
''';
    } else if (lowerInput.contains('code') || lowerInput.contains('example')) {
      if (includeCodeBlock) {
        return '''
# Flutter Code Example

Here's a simple Flutter widget demonstrating state management:

```dart
class CounterWidget extends StatefulWidget {
  const CounterWidget({super.key});

  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int _counter = 0;
  
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Count: \$_counter',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _incrementCounter,
              icon: const Icon(Icons.add),
              label: const Text('Increment'),
            ),
          ],
        ),
      ),
    );
  }
}
```

This widget demonstrates a simple counter with state management using `setState()`. You can integrate this into any Flutter app.
''';
      } else {
        return 'I\'d be happy to show you a code example, but code blocks are currently disabled in settings. You can enable them in the settings drawer to see beautiful syntax highlighting.';
      }
    } else if (lowerInput.contains('markdown')) {
      return '''
# Markdown Support in Dila

This chat UI comes with rich markdown support including:

## Styled Headers

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
> This is a blockquote that highlights important information.

### Code Blocks
```dart
print('Hello, Dila!');
```

All these formatting options make conversations with Dila more expressive and informative.
''';
    } else if (lowerInput.contains('flutter')) {
      return '''
# Flutter Overview

Flutter is Google's UI toolkit for building beautiful, natively compiled applications for mobile, web, desktop, and embedded devices from a single codebase.

## Key Features

- **Fast Development**: Hot reload helps you quickly experiment and build UIs
- **Expressive UI**: Create beautiful apps with Flutter's widgets
- **Native Performance**: Flutter compiles to native ARM code for performance

## Popular Packages

- **provider**: Simple state management
- **flutter_bloc**: Robust state management
- **dio**: HTTP client for API calls
- **flutter_gen_ai_chat_ui**: Create chat UIs like this one!

Would you like me to elaborate on any of these aspects of Flutter?
''';
    } else if (lowerInput.contains('features') ||
        lowerInput.contains('capabilities')) {
      return '''
# Dila Chat UI Features

This chat interface includes:

## Core Features
- ⚡ **Streaming Text**: Word-by-word animation for natural conversations
- 📝 **Markdown Support**: Rich formatting with headers, lists, and more
- 🎨 **Syntax Highlighting**: Beautiful code blocks with proper syntax coloring
- 🌗 **Themeable**: Complete dark/light mode support with customizable colors

## User Experience
- 🔄 **Persistent State**: Chat history is maintained between sessions
- 💬 **Example Questions**: Guided conversation starters
- ⚙️ **Customization**: Extensive configuration options
- 📱 **Responsive**: Adapts to all screen sizes

## Developer Experience
- 🔧 **Easy Integration**: Simple API for adding to any Flutter app
- 🧩 **Modular Design**: Use only the components you need
- 📚 **Well-documented**: Comprehensive documentation and examples

Feel free to explore these features during our conversation!
''';
    } else {
      // Default response with markdown formatting
      return '''
I'm not quite sure how to respond to that. As Dila, I can help with:

- **Flutter Development** - Ask about widgets, state management, etc.
- **Code Examples** - Request sample code for common patterns
- **UI Features** - Learn about chat UI capabilities
- **Markdown Demonstrations** - See rich formatting in action

What would you like to explore?
''';
    }
  }

  // Stream a response word by word for more natural conversation
  Stream<String> streamResponse(String input,
      {bool includeCodeBlock = true}) async* {
    // Add an initial delay before starting to stream content
    await _simulateDelay(1200, 2000);

    final fullResponse =
        await getResponse(input, includeCodeBlock: includeCodeBlock);
    final words = fullResponse.split(' ');

    var accumulatedText = '';

    for (final word in words) {
      // Add varied delays to make streaming feel more natural
      await _simulateDelay(60, 200);
      accumulatedText += (accumulatedText.isEmpty ? '' : ' ') + word;
      yield accumulatedText;
    }
  }
}
