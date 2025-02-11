# Flutter Gen AI Chat UI

[![pub package](https://img.shields.io/pub/v/flutter_gen_ai_chat_ui.svg)](https://pub.dev/packages/flutter_gen_ai_chat_ui)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A modern, customizable chat UI for AI applications built with Flutter. Features streaming responses, markdown support, and rich customization options.

## Table of Contents
- [Features](#features)
- [Quick Start](#quick-start)
- [Installation](#installation)
- [Usage](#usage)
- [Configuration](#configuration)
- [Advanced Features](#advanced-features)
- [Platform Support](#platform-specific-features)
- [Examples](#examples--support)
- [Contributing](#contributing)

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

### Core Features
- 🎨 Dark/light mode with adaptive theming
- 💫 Word-by-word streaming with animations
- 📝 Markdown support with syntax highlighting
- 🎤 Optional speech-to-text integration
- 📱 Responsive layout with customizable width
- 🌐 RTL language support
- ⚡ High performance message handling

### UI Components
- 💬 Customizable message bubbles
- ⌨️ Rich input field options
- 🔄 Loading indicators with shimmer
- ⬇️ Smart scroll management
- 👋 Welcome message widget
- ❓ Example questions component

## Quick Start

```dart
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';

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

## Installation

1. Add dependency:
```yaml
dependencies:
  flutter_gen_ai_chat_ui: ^1.2.0
```

2. Import:
```dart
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';
```

Optional: For speech recognition, add:
```yaml
dependencies:
  speech_to_text: ^6.6.0
```

## Configuration

The `AiChatConfig` class provides extensive customization:

```dart
AiChatConfig({
  String? userName,                    // User's display name
  String? aiName,                      // AI assistant's name
  String? hintText,                    // Input placeholder
  double? maxWidth,                    // Maximum chat width
  bool enableAnimation = true,         // Enable animations
  bool showTimestamp = true,          // Show timestamps
  WelcomeMessageConfig? welcomeConfig, // Welcome message
  MessageOptions? messageOptions,      // Bubble styling
  InputDecoration? inputDecoration,    // Input styling
})
```

## Advanced Features

### Speech-to-Text Integration

1. Add the dependency:
```yaml
dependencies:
  speech_to_text: ^6.6.0
```

2. Add platform permissions:

iOS (`ios/Runner/Info.plist`):
```xml
<key>NSMicrophoneUsageDescription</key>
<string>This app needs microphone access for speech recognition</string>
<key>NSSpeechRecognitionUsageDescription</key>
<string>This app needs speech recognition to convert your voice to text</string>
```

Android (`android/app/src/main/AndroidManifest.xml`):
```xml
<uses-permission android:name="android.permission.RECORD_AUDIO"/>
```

3. Implement STT in your widget:
```dart
import 'package:speech_to_text/speech_to_text.dart' as stt;

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    await _speech.initialize(
      onError: (error) => debugPrint('Speech error: $error'),
      onStatus: (status) => debugPrint('Speech status: $status'),
    );
  }

  Future<void> _listen() async {
    if (!_isListening) {
      final available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (result) {
            if (result.finalResult) {
              // Handle the recognized text
              final message = ChatMessage(
                text: result.recognizedWords,
                user: currentUser,
                createdAt: DateTime.now(),
              );
              _handleSendMessage(message);
              setState(() => _isListening = false);
            }
          },
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AiChatWidget(
      config: AiChatConfig(
        inputDecoration: InputDecoration(
          prefixIcon: IconButton(
            icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
            onPressed: _listen,
          ),
        ),
      ),
      currentUser: currentUser,
      aiUser: aiUser,
      controller: controller,
      onSendMessage: _handleSendMessage,
    );
  }

  @override
  void dispose() {
    _speech.cancel();
    super.dispose();
  }
}

### Dark Mode
```dart
Theme(
  data: Theme.of(context).copyWith(
    extensions: [
      CustomThemeExtension(
        messageBubbleColor: isDark ? Color(0xFF1E1E1E) : Colors.white,
        userBubbleColor: isDark ? Color(0xFF7B61FF) : Color(0xFFE3F2FD),
      ),
    ],
  ),
  child: AiChatWidget(...),
)
```

### Streaming
```dart
void handleStreamingResponse(String text) {
  final response = ChatMessage(text: "", user: aiUser);
  for (var word in text.split(' ')) {
    response.text += '$word ';
    controller.updateMessage(response);
  }
}
```

### Speech Recognition
See [example/lib/simple_chat_screen.dart](example/lib/simple_chat_screen.dart) for complete implementation.

## Platform Support

✅ Android
- Material Design 3
- Native permissions
- Adaptive colors

✅ iOS
- Cupertino animations
- Privacy handling
- Native feel

✅ Web
- Responsive design
- Keyboard support
- Cross-browser

✅ Desktop
- Window management
- Keyboard navigation
- High DPI support

## Examples & Support

- 📘 [Example Directory](example)
- 🐛 [Issue Tracker](https://github.com/hooshyar/flutter_gen_ai_chat_ui/issues)
- 💡 [Contribution Guide](CONTRIBUTING.md)

## Dependencies

- [dash_chat_2](https://pub.dev/packages/dash_chat_2) - Chat UI
- [flutter_streaming_text_markdown](https://pub.dev/packages/flutter_streaming_text_markdown) - Markdown
- [provider](https://pub.dev/packages/provider) - State
- [shimmer](https://pub.dev/packages/shimmer) - Effects
- [google_fonts](https://pub.dev/packages/google_fonts) - Typography

## Version Compatibility

| Flutter Version | Package Version |
|----------------|-----------------|
| >=3.0.0        | ^1.2.0         |
| >=2.5.0        | ^1.1.0         |

## License

[MIT License](LICENSE)

---
⭐ If you find this package helpful, please star the repository!