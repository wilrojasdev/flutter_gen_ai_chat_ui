# Flutter Gen AI Chat UI

[![pub package](https://img.shields.io/pub/v/flutter_gen_ai_chat_ui.svg)](https://pub.dev/packages/flutter_gen_ai_chat_ui)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A customizable chat UI for AI applications built with Flutter. This package offers features such as streaming responses, markdown support, animations, and easy integration into your Flutter app.

<table>
  <tr>
    <td align="center">
      <img src="https://raw.githubusercontent.com/hooshyar/flutter_gen_ai_chat_ui/main/screenshots/detailed_dark.png" alt="Dark Mode" width="300px">
      <br>
      <em>Dark Mode</em>
    </td>
    <td align="center">
      <img src="https://raw.githubusercontent.com/hooshyar/flutter_gen_ai_chat_ui/main/screenshots/detailed.gif" alt="Chat Demo" width="300px">
      <br>
      <em>Chat Demo</em>
    </td>
  </tr>
</table>

## Features
- Customizable AI chat interface with theming and animations.
- Support for streaming responses with markdown rendering using [flutter_streaming_text_markdown](https://pub.dev/packages/flutter_streaming_text_markdown).
- Example implementations: Simple Chat, Custom Styling, Detailed Example, Markdown, Pagination, and Streaming.

## Installation

Add the following to your `pubspec.yaml` file:

```yaml
dependencies:
  flutter_gen_ai_chat_ui: ^0.1.0
```

Then run:

```bash
flutter pub get
```

## Usage

Import the package and use one of the provided widgets (e.g. `AiChatWidget`) along with the configuration classes. See the example apps in the `example/` directory for various integrations:

- simple_chat_screen.dart
- custom_styling_example.dart
- detailed_example.dart
- streaming_example.dart

## Release Notes

This release includes:
- Updated streaming example to use [flutter_streaming_text_markdown](https://pub.dev/packages/flutter_streaming_text_markdown) for improved streaming text rendering.
- Reverted dash_chat_2 dependency to ^0.0.21 for compatibility.
- Various bug fixes and improvements in behavior and styling.

## License

[MIT License](LICENSE)

## 🤖 Quick Integration with AI Help

Need help integrating this package with your specific use case? Copy this prompt into ChatGPT:

```
Help me integrate flutter_gen_ai_chat_ui with my Flutter app.

My app details:
1. App type: [e.g., AI chatbot, customer support, education app]
2. Backend: [e.g., OpenAI API, custom API, Firebase]
3. Features needed: [e.g., streaming responses, markdown support, dark mode]
4. Current state management: [e.g., Provider, Bloc, GetX]

Please show me:
1. How to integrate the chat UI
2. How to connect it with my backend
3. How to customize the theme to match my app
4. Best practices for my specific use case
```

The AI will provide:
- ✅ Complete integration code
- ✅ Backend connection setup
- ✅ Theme customization examples
- ✅ Performance optimization tips
- ✅ Use case specific recommendations

## Key Features

### Core Features
- 🎨 Dark and light mode support with adaptive theming
- 💫 Smooth message animations with word-by-word streaming
- 🔄 Real-time message updates and streaming
- ✨ Loading indicators with customizable shimmer effect
- 📱 Responsive layout with configurable max width
- 🎤 Professional speech-to-text with:
  - 🌊 Smooth dual-layer pulse animation
  - 📊 Real-time sound level visualization
  - 🎨 Adaptive theming for light/dark modes
  - 🎯 Precise error handling and recovery
  - 🔄 Automatic language detection
  - 📱 iOS and Android support (physical devices)

### Message Features
- 📝 Markdown support with syntax highlighting
- 🎯 Selectable text in messages
- 🔗 Clickable links and URL handling
- 📜 Message pagination with custom loading indicators
- 🌐 RTL language support
- ⏱️ Customizable timestamps
- 🔄 Message streaming with real-time updates
- 🎨 Custom message bubble styling

### UI Components
- 👋 Customizable welcome message
- ⭐️ Example questions widget with tap actions
- 💬 Custom message bubbles and layouts
- 🎮 Custom input field with:
  - 🎨 Customizable styling and decoration
  - 🎯 Custom send button
  - 🎤 Integrated speech-to-text
  - ⌨️ Multi-line input support
- ⬇️ Smart scroll-to-bottom button
- 🔄 Loading indicators and shimmer effects

### Advanced Features
- 🎮 Complete message controller
- 🔄 Pagination support with custom offset
- 🎯 Action callbacks for send/clear/stop
- 🌍 Locale support for speech recognition
- 🎨 Theme extension for deep customization
- 📱 Platform-specific optimizations
- 🔒 Permission handling for speech recognition
- 🎯 Error handling and recovery

## Quick Start

### 1. Add the dependency

```yaml
dependencies:
  flutter_gen_ai_chat_ui: ^1.1.6
```

### 2. Platform Setup

Speech-to-text functionality is optional. If you plan to use it (`enableSpeechToText: true`), you'll need to:

1. Add the required permissions:

#### iOS - Add to `ios/Runner/Info.plist`:
```xml
<key>NSMicrophoneUsageDescription</key>
<string>This app needs microphone access for speech recognition</string>
<key>NSSpeechRecognitionUsageDescription</key>
<string>This app needs speech recognition to convert your voice to text</string>
```

#### Android - Add to `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.RECORD_AUDIO"/>
```

Note: Speech-to-text is only supported on physical devices, not on simulators/emulators.

If you don't plan to use speech-to-text, you can skip this setup and simply set `enableSpeechToText: false` in your `AiChatConfig`.

### 3. Basic Implementation

```dart
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';
import 'package:dash_chat_2/dash_chat_2.dart';

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = ChatMessagesController();
  final _currentUser = ChatUser(id: '1', firstName: 'User');
  final _aiUser = ChatUser(id: '2', firstName: 'AI Assistant');
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('AI Chat')),
      body: AiChatWidget(
        config: AiChatConfig(
          enableSpeechToText: true,  // Enable speech recognition
          hintText: 'Type or speak your message...',
          enableAnimation: true,
          // Optional speech-to-text customization
          speechToTextIcon: Icons.mic_none_rounded,
          speechToTextActiveIcon: Icons.mic_rounded,
          onSpeechError: (error) => print('Speech error: $error'),
        ),
        controller: _controller,
        currentUser: _currentUser,
        aiUser: _aiUser,
        onSendMessage: _handleMessage,
        isLoading: _isLoading,
      ),
    );
  }

  Future<void> _handleMessage(ChatMessage message) async {
    setState(() => _isLoading = true);
    try {
      // Add your AI response logic here
      await Future.delayed(Duration(seconds: 1));
      _controller.addMessage(ChatMessage(
        text: "I received: ${message.text}",
        user: _aiUser,
        createdAt: DateTime.now(),
      ));
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
```

## Configuration Guide

### AiChatConfig Options

The `AiChatConfig` class provides extensive customization options. Here's a comprehensive guide:

#### Basic Configuration
```dart
AiChatConfig(
  // User Interface
  userName: 'User',            // Name displayed for the user
  aiName: 'AI Assistant',      // Name displayed for the AI
  hintText: 'Type a message...', // Input field placeholder
  maxWidth: 800,              // Maximum width of the chat interface
  padding: EdgeInsets.all(16), // Padding around the chat interface
  
  // Feature Toggles
  enableAnimation: true,       // Enable/disable message animations
  showTimestamp: true,        // Show/hide message timestamps
  readOnly: false,            // Make chat read-only
  enablePagination: false,    // Enable/disable message pagination
  
  // Example Questions
  exampleQuestions: [
    ChatExample(
      question: 'What can you help me with?',
      onTap: (controller) {
        controller.handleExampleQuestion(
          'What can you help me with?',
          currentUser,
          aiUser,
        );
      },
    ),
  ],
)
```

#### Speech-to-Text Configuration
```dart
AiChatConfig(
  enableSpeechToText: true,
  speechToTextIcon: Icons.mic_none_rounded,      // Default mic icon
  speechToTextActiveIcon: Icons.mic_rounded,     // Icon when active
  speechToTextLocale: 'en_US',                  // Recognition language
  
  // Speech Recognition Callbacks
  onSpeechStart: () async {
    // Called when speech recognition starts
  },
  onSpeechEnd: () async {
    // Called when speech recognition ends
  },
  onSpeechError: (error) {
    // Handle speech recognition errors
  },
  onRequestSpeechPermission: () async {
    // Handle permission requests
    return true; // Return true if permission granted
  },
  
  // Custom Speech Button
  customSpeechToTextButton: (isListening, onPressed) {
    return YourCustomButton(
      isListening: isListening,
      onPressed: onPressed,
    );
  },
)
```

#### UI Customization
```dart
AiChatConfig(
  // Input Field Styling
  inputTextStyle: TextStyle(fontSize: 16),
  inputDecoration: InputDecoration(
    border: OutlineInputBorder(),
    filled: true,
  ),
  
  // Message Display
  messageBuilder: (message) {
    return CustomMessageBubble(message: message);
  },
  
  // Send Button
  sendButtonIcon: Icons.send_rounded,
  sendButtonIconSize: 24,
  sendButtonPadding: EdgeInsets.all(8),
  sendButtonBuilder: (onSend) {
    return CustomSendButton(onPressed: onSend);
  },
  
  // Scroll Button
  scrollToBottomBuilder: (controller) {
    return CustomScrollButton(controller: controller);
  },
)
```

#### Pagination and Loading
```dart
AiChatConfig(
  enablePagination: true,
  paginationLoadingIndicatorOffset: 100,
  loadMoreIndicator: ({required bool isLoading}) {
    return CustomLoadingIndicator(isLoading: isLoading);
  },
)
```

#### Action Callbacks
```dart
AiChatConfig(
  onSendButtonPressed: (message) {
    // Handle send button press
  },
  onClearButtonPressed: () {
    // Handle clear button press
  },
  onStopButtonPressed: () {
    // Handle stop button press (e.g., stop streaming)
  },
)
```

#### Advanced Message Options
```dart
AiChatConfig(
  // Message Options
  messageOptions: MessageOptions(
    showTime: true,
    timePadding: EdgeInsets.only(top: 4),
    containerColor: Colors.grey[200],
    textColor: Colors.black87,
  ),
  
  // Message List Options
  messageListOptions: MessageListOptions(
    showDateSeparator: true,
    scrollPhysics: BouncingScrollPhysics(),
  ),
  
  // Quick Reply Options
  quickReplyOptions: QuickReplyOptions(
    quickReplyStyle: BoxDecoration(
      border: Border.all(),
      borderRadius: BorderRadius.circular(12),
    ),
  ),
)
```

## Advanced Features

### 1. Speech Recognition
The package includes a professional speech-to-text button with:
- 🌊 Smooth dual-layer pulse animation
- 📊 Real-time sound level visualization
- 🎨 Adaptive theming for light/dark modes
- 🎯 Precise error handling and recovery
- 🔄 Automatic language detection
- 📱 iOS and Android support (physical devices only)

### 2. Dark Mode Support

```dart
Theme(
  data: Theme.of(context).copyWith(
    extensions: [
      CustomThemeExtension(
        messageBubbleColor: isDark ? Color(0xFF262626) : Colors.white,
        userBubbleColor: isDark ? Color(0xFF1A4B8F) : Color(0xFFE3F2FD),
        messageTextColor: isDark ? Color(0xFFE5E5E5) : Colors.grey[800]!,
        chatBackground: isDark ? Color(0xFF171717) : Colors.grey[50]!,
      ),
    ],
  ),
  child: AiChatWidget(...),
)
```

### 3. Streaming Responses

```dart
Future<void> handleStreamingResponse(String text) async {
  final response = ChatMessage(
    text: "",
    user: aiUser,
    createdAt: DateTime.now(),
  );
  
  for (var word in text.split(' ')) {
    await Future.delayed(Duration(milliseconds: 50));
    response.text += '${response.text.isEmpty ? '' : ' '}$word';
    controller.updateMessage(response);
  }
}
```

## Examples & Support

- 📘 Check our [example](example) folder for complete implementations
- 🐛 File issues on our [GitHub repository](https://github.com/hooshyar/flutter_gen_ai_chat_ui)
- 💡 Contribute to the project

