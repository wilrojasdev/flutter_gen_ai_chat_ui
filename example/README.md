# Flutter Gen AI Chat UI Examples

This directory contains example implementations of the `flutter_gen_ai_chat_ui` package.

## Examples

1. **Simple Chat** (`lib/simple_chat_screen.dart`)
   - Basic implementation with essential features
   - Shows how to handle messages and configure the UI
   - Includes speech recognition example

```dart
AiChatWidget(
  config: AiChatConfig(
    hintText: 'Type a message...',
    enableAnimation: true,
    inputOptions: InputOptions(
      alwaysShowSend: true,
    ),
    // Custom input decoration with speech button
    inputDecoration: InputDecoration(
      prefixIcon: IconButton(
        icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
        onPressed: _listen,
      ),
    ),
  ),
  currentUser: _currentUser,
  aiUser: _aiUser,
  controller: _controller,
  onSendMessage: _handleSendMessage,
)
```

2. **Streaming Example** (`lib/streaming_example.dart`)
   - Demonstrates word-by-word streaming
   - Shows loading states and animations
   - Implements markdown support

```dart
AiChatWidget(
  config: AiChatConfig(
    enableAnimation: true,
    isLoading: _isLoading,
    messageOptions: MessageOptions(
      containerColor: isDark ? Color(0xFF1E1E1E) : Colors.grey[50],
      currentUserContainerColor: isDark ? Color(0xFF7B61FF) : Colors.blue,
    ),
  ),
  // ... other properties
)
```

3. **Custom Styling** (`lib/custom_styling_example.dart`)
   - Shows theme customization
   - Demonstrates message bubble styling
   - Custom welcome message implementation

4. **Detailed Example** (`lib/detailed_example.dart`)
   - Comprehensive implementation
   - Shows all available customization options
   - Includes error handling and loading states

## Running the Examples

1. Clone the repository
2. Navigate to the example directory
3. Run `flutter pub get`
4. Run `flutter run`

## Configuration Guide

All configurations are now centralized in `AiChatConfig`. Here's how to use different features:

### Basic Configuration
```dart
AiChatConfig(
  userName: 'User',
  aiName: 'AI Assistant',
  hintText: 'Type a message...',
  enableAnimation: true,
)
```

### Message Styling
```dart
AiChatConfig(
  messageOptions: MessageOptions(
    containerColor: Colors.grey[50],
    currentUserContainerColor: Colors.blue,
    textColor: Colors.black,
    showTime: true,
  ),
)
```

### Input Customization
```dart
AiChatConfig(
  inputOptions: InputOptions(
    alwaysShowSend: true,
    sendOnEnter: true,
  ),
  inputDecoration: InputDecoration(
    // Your custom decoration
  ),
)
```

### Loading States
```dart
AiChatConfig(
  isLoading: _isLoading,
  loadingIndicator: LoadingWidget(
    texts: ['AI is thinking...', 'Processing...'],
  ),
)
```

## Platform Setup

### Speech Recognition

1. iOS (`ios/Runner/Info.plist`):
```xml
<key>NSMicrophoneUsageDescription</key>
<string>This app needs microphone access for speech recognition</string>
<key>NSSpeechRecognitionUsageDescription</key>
<string>This app needs speech recognition to convert your voice to text</string>
```

2. Android (`android/app/src/main/AndroidManifest.xml`):
```xml
<uses-permission android:name="android.permission.RECORD_AUDIO"/>
```

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