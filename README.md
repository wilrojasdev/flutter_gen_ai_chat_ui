# Flutter Gen AI Chat UI

[![pub package](https://img.shields.io/pub/v/flutter_gen_ai_chat_ui.svg)](https://pub.dev/packages/flutter_gen_ai_chat_ui)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A modern, customizable chat interface for AI applications in Flutter. Simple to use, easy to customize.

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
- 🎨 Dark and light mode support
- 💫 Smooth message animations
- 🔄 Word-by-word text streaming
- ✨ Loading indicators with shimmer effect
- 📱 Responsive layout for all screen sizes
- 🎤 Professional speech-to-text with visual feedback

### Message Features
- 📝 Markdown support with syntax highlighting
- 🎯 Selectable text in messages
- 🔗 Clickable links
- 📜 Message pagination
- 🌐 RTL language support

### UI Components
- 👋 Customizable welcome message
- ⭐️ Example questions widget
- 💬 Custom message bubbles
- 🎮 Custom input field and send button

## Quick Start

### 1. Add the dependency

```yaml
dependencies:
  flutter_gen_ai_chat_ui: ^1.1.6
```

### 2. Platform Setup

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

## License

MIT License - see the [LICENSE](LICENSE) file for details.

