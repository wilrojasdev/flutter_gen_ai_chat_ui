# Flutter Gen AI Chat UI Examples

This directory contains several examples demonstrating different features and use cases of the `flutter_gen_ai_chat_ui` package.

## Getting Started

1. Install dependencies:
```yaml
dependencies:
  flutter_gen_ai_chat_ui: ^1.1.9  # Latest version
  speech_to_text: ^6.6.0  # Optional: Only if you need speech recognition
```

2. Import the package:
```dart
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';
// Optional: For speech recognition
import 'package:speech_to_text/speech_to_text.dart' as stt;
```

3. Platform Setup (Optional - Only for speech recognition)

#### iOS
Add to `ios/Runner/Info.plist`:
```xml
<key>NSMicrophoneUsageDescription</key>
<string>This app needs microphone access for speech recognition</string>
<key>NSSpeechRecognitionUsageDescription</key>
<string>This app needs speech recognition to convert your voice to text</string>
```

#### Android
Add to `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.RECORD_AUDIO"/>
```

Note: Speech recognition is only supported on physical devices.

## Examples

### 1. Simple Chat Screen (`simple_chat_screen.dart`)
Basic implementation with minimal configuration, including:
- Core chat functionality
- Optional speech-to-text integration
- Custom input decoration
- Basic error handling

```dart
// Basic chat implementation
AiChatWidget(
  config: AiChatConfig(
    hintText: 'Type a message...',
    enableAnimation: true,
    welcomeMessageConfig: const WelcomeMessageConfig(
      title: 'Welcome to Simple Chat!',
      questionsSectionTitle: 'Try asking these questions:',
    ),
  ),
  currentUser: ChatUser(id: '1', firstName: 'User'),
  aiUser: ChatUser(id: '2', firstName: 'AI'),
  controller: ChatMessagesController(),
  onSendMessage: (message) {
    // Handle message
  },
)

// Optional: Speech-to-text integration
final speech = stt.SpeechToText();
await speech.initialize(
  onError: (error) => print('Speech error: $error'),
  onStatus: (status) => print('Speech status: $status'),
);

// Add speech button to input decoration
inputDecoration: InputDecoration(
  prefixIcon: IconButton(
    icon: Icon(isListening ? Icons.mic : Icons.mic_none),
    onPressed: listen,
  ),
),
```

### 2. Custom Styling (`custom_styling_example.dart`)
Demonstrates theme customization including:
- Dark mode support
- Custom message bubble colors
- Custom typography
- Adaptive theme colors

### 3. Detailed Example (`detailed_example.dart`)
Shows advanced features including:
- Custom message bubbles
- Loading animations with shimmer effect
- Pagination with custom offset
- Example questions with tap actions
- Responsive design
- Theme extension usage

### 4. Streaming Example (`streaming_example.dart`)
Demonstrates:
- Word-by-word text streaming
- Smooth message animations
- Real-time updates
- Markdown rendering during streaming

### 5. Markdown Example (`markdown_example.dart`)
Shows:
- Markdown rendering capabilities
- Code syntax highlighting
- Custom markdown styling
- Link handling

### 6. Pagination Example (`pagination_example.dart`)
Demonstrates:
- Historical message loading
- Custom loading indicators
- Scroll position management
- Efficient message rendering

## Platform-Specific Features

### Android
- Material Design 3 theming
- Adaptive colors
- Native ripple effects
- Speech recognition integration (requires RECORD_AUDIO permission)

### iOS
- Cupertino-style animations
- Native scrolling behavior
- Adaptive typography
- Speech recognition integration (requires microphone permission)

### Web
- Responsive layout
- Keyboard shortcuts
- Touch and mouse input support
- Adaptive UI for different screen sizes

### Desktop (Windows, macOS, Linux)
- Window resizing support
- Keyboard navigation
- Native scrollbar styling
- High-resolution display support

## Running the Examples

1. Clone the repository
2. Navigate to the example directory
3. Run `flutter pub get`
4. Run `flutter run`

## Customization

The examples demonstrate various customization options:

- Theme customization
  - Light/dark mode
  - Custom colors
  - Typography
  - Message bubble styling
- Input field configuration
  - Custom decorations
  - Voice input integration
  - Multi-line support
- Message features
  - Custom bubbles
  - Markdown support
  - Link handling
  - Timestamps
- Animations
  - Message transitions
  - Loading indicators
  - Streaming effects
- Platform adaptations
  - Permission handling
  - Native features
  - Responsive design

## Contributing

Feel free to contribute to these examples by:
1. Creating new examples
2. Improving existing ones
3. Adding documentation
4. Fixing bugs

Please ensure your contributions follow our coding standards and include appropriate documentation.

## License

This example project is licensed under the same terms as the main package.