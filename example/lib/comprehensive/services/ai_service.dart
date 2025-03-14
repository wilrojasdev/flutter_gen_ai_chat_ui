import 'dart:async';
import 'dart:math';

/// Response from the AI, including text and formatting information
class AiResponse {
  /// The text content of the response
  final String text;

  /// Whether the text should be rendered as markdown
  final bool isMarkdown;

  AiResponse(this.text, {this.isMarkdown = false});
}

/// Service that simulates AI responses
class AiService {
  final Random _random = Random();

  /// Generate a response with a realistic delay
  Future<AiResponse> generateResponse(String query,
      {bool includeCodeBlock = true}) async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 500 + _random.nextInt(1000)));

    final lowerQuery = query.toLowerCase();

    // Introduction/greeting
    if (lowerQuery.contains('hello') ||
        lowerQuery.contains('hi') ||
        query.length < 10) {
      return AiResponse(
        "Hello! I'm Insight AI, your personal assistant. How can I help you today?",
      );
    }

    // About the assistant
    if (lowerQuery.contains('who are you') ||
        lowerQuery.contains('about you') ||
        lowerQuery.contains('your name')) {
      return AiResponse('''
# About Insight AI

I'm a sophisticated AI assistant designed to provide help, information, and insights on a wide range of topics. I can:

- Answer questions on various subjects
- Assist with problem-solving
- Generate creative content
- Provide code examples and explanations
- Engage in thoughtful conversations

I'm continuously learning and improving to better serve your needs.
      ''', isMarkdown: true);
    }

    // Help options
    if (lowerQuery.contains('help') ||
        lowerQuery.contains('can you do') ||
        lowerQuery.contains('what can you')) {
      return AiResponse('''
# How I Can Help You

I can assist with a variety of tasks:

1. **Answer Questions** - Ask me about Flutter, coding, or general information
2. **Provide Code Examples** - Request sample code for common patterns
3. **Explain Concepts** - Get clear explanations on technical topics
4. **Demonstrate Features** - Show the capabilities of this chat UI

Feel free to try any of these or ask something specific!
      ''', isMarkdown: true);
    }

    // Code example
    if ((lowerQuery.contains('code') ||
            lowerQuery.contains('example') ||
            lowerQuery.contains('sample')) &&
        includeCodeBlock) {
      return AiResponse('''
# Flutter Code Example

Here's a simple Flutter widget that creates a beautiful card component:

```dart
class InsightCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;

  const InsightCard({
    Key? key,
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 32, color: Theme.of(context).primaryColor),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

You can use this card component to display information in a visually appealing way in your Flutter app.
      ''', isMarkdown: true);
    } else if ((lowerQuery.contains('code') ||
            lowerQuery.contains('example')) &&
        !includeCodeBlock) {
      return AiResponse(
        "I'd be happy to show you a code example, but code blocks are currently disabled in settings. You can enable them in the settings panel to see beautiful syntax highlighting.",
      );
    }

    // Flutter information
    if (lowerQuery.contains('flutter') || lowerQuery.contains('dart')) {
      return AiResponse('''
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
      ''', isMarkdown: true);
    }

    // Chat UI features
    if (lowerQuery.contains('features') ||
        lowerQuery.contains('capabilities') ||
        lowerQuery.contains('this chat') ||
        lowerQuery.contains('chat ui')) {
      return AiResponse('''
# This Chat UI's Features

The Flutter Gen AI Chat UI package offers a wide range of features:

## Core Features
- 🎨 **Theme Support**: Full light/dark mode with custom theming
- 💫 **Animations**: Word-by-word streaming and message transitions
- 📝 **Markdown**: Rich text formatting with code highlighting
- 🌐 **Responsive**: Works on all screen sizes and orientations

## UI Components
- 💬 **Message Bubbles**: Customizable with various styling options
- ⌨️ **Input Field**: Multiple styles including minimal and glassmorphic
- 🎨 **Theme Customization**: Control colors, shapes, and typography
- 📱 **Mobile-Friendly**: Touch-optimized controls and interactions

## User Experience
- 👋 **Welcome Screen**: Customizable introduction with example questions
- ❓ **Suggestion Chips**: Helpful example questions for users
- 🔄 **Typing Indicators**: Show when the AI is generating a response
- ⬇️ **Smart Scrolling**: Easy navigation of conversation history

Would you like to see a demonstration of any specific feature?
      ''', isMarkdown: true);
    }

    // Default response
    return AiResponse(
      "Thank you for your message. I'll do my best to assist you. If you're looking for something specific, feel free to ask about Flutter, code examples, or this chat UI's features.",
    );
  }

  /// Stream a response word by word
  Stream<String> streamResponse(String query,
      {bool includeCodeBlock = true}) async* {
    final response =
        await generateResponse(query, includeCodeBlock: includeCodeBlock);
    final words = response.text.split(' ');

    String accumulated = '';

    for (final word in words) {
      accumulated += (accumulated.isEmpty ? '' : ' ') + word;
      yield accumulated;

      // Random delay between words for natural typing feel
      await Future.delayed(Duration(milliseconds: 20 + _random.nextInt(80)));
    }
  }
}
