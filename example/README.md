# Flutter Gen AI Chat UI Examples

This directory contains example implementations of the `flutter_gen_ai_chat_ui` package, demonstrating various features and customization options.

## Examples

1. **Basic Chat Example** (`lib/basic_example.dart`)
   - Minimal setup
   - Basic message handling
   - Default styling

2. **Custom Styling Example** (`lib/custom_styling_example.dart`)
   - Custom theme implementation
   - Dark mode support
   - Message bubble customization
   - Input field styling

3. **Markdown Example** (`lib/markdown_example.dart`)
   - Markdown message support
   - Code block highlighting
   - Custom markdown styling
   - Streaming text support

4. **Pagination Example** (`lib/pagination_example.dart`)
   - Message pagination
   - Loading indicators
   - Scroll behavior
   - Message history management

5. **Speech Recognition Example** (`lib/speech_recognition_example.dart`)
   - Voice input integration
   - Permission handling
   - Platform-specific setup
   - Error handling

## Running the Examples

1. Clone the repository:
```bash
git clone https://github.com/hooshyar/flutter_gen_ai_chat_ui.git
```

2. Navigate to the example directory:
```bash
cd flutter_gen_ai_chat_ui/example
```

3. Get dependencies:
```bash
flutter pub get
```

4. Run the desired example:
```bash
flutter run -t lib/basic_example.dart
```

## Configuration

Each example demonstrates different aspects of the package configuration. Here's a quick overview:

### Basic Example
```dart
AiChatWidget(
  config: AiChatConfig(
    hintText: 'Type a message...',
    enableAnimation: true,
  ),
  currentUser: ChatUser(id: '1', firstName: 'User'),
  aiUser: ChatUser(id: '2', firstName: 'AI'),
  controller: ChatMessagesController(),
  onSendMessage: (message) async {
    // Handle message
  },
)
```

### Custom Styling
```dart
AiChatWidget(
  config: AiChatConfig(
    inputOptions: InputOptions(
      alwaysShowSend: true,
      sendOnEnter: true,
      margin: EdgeInsets.all(16),
      inputDecoration: InputDecoration(
        border: OutlineInputBorder(),
        filled: true,
      ),
    ),
    messageOptions: MessageOptions(
      showTime: true,
      containerColor: Colors.grey[200],
      userBubbleColor: Colors.blue[100],
      aiBubbleColor: Colors.grey[100],
    ),
  ),
)
```

### Markdown Support
```dart
AiChatWidget(
  config: AiChatConfig(
    messageOptions: MessageOptions(
      markdownConfig: MarkdownConfig(
        codeBlockTheme: CodeBlockTheme(
          backgroundColor: Colors.grey[900],
          textStyle: TextStyle(
            color: Colors.white,
            fontFamily: 'RobotoMono',
          ),
        ),
      ),
    ),
  ),
)
```

### Pagination
```dart
AiChatWidget(
  config: AiChatConfig(
    paginationConfig: PaginationConfig(
      enabled: true,
      loadingIndicatorOffset: 100,
      loadMoreIndicator: ({isLoading}) => CustomLoadingWidget(),
    ),
  ),
  controller: ChatMessagesController(
    initialMessages: messages.take(20).toList(),
    onLoadMoreMessages: (lastMessage) async {
      // Load next page
      return nextPageOfMessages;
    },
  ),
)
```

## Platform Support

All examples are tested and working on:
- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ Desktop (Windows, macOS, Linux)

## Contributing

Feel free to contribute more examples or improvements to existing ones. Please follow the [contribution guidelines](../CONTRIBUTING.md).

## License

These examples are licensed under the MIT License - see the [LICENSE](../LICENSE) file for details.