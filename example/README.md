# Flutter Gen AI Chat UI Examples

This directory contains several examples demonstrating different features and use cases of the `flutter_gen_ai_chat_ui` package.

## Getting Started

1. Install dependencies:
```yaml
dependencies:
  flutter_gen_ai_chat_ui: ^1.1.2  # Latest version
```

2. Import the package:
```dart
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';
```

## Examples

### 1. Simple Chat Screen (`simple_chat_screen.dart`)
Basic implementation with minimal configuration.

```dart
AiChatWidget(
  config: AiChatConfig(),
  currentUser: ChatUser(id: '1', firstName: 'User'),
  aiUser: ChatUser(id: '2', firstName: 'AI'),
  controller: ChatMessagesController(),
  onSendMessage: (message) {
    // Handle message
  },
)
```

### 2. Custom Styling (`custom_styling_example.dart`)
Demonstrates theme customization and dark mode support.

### 3. Detailed Example (`detailed_example.dart`)
Shows advanced features including:
- Custom message bubbles
- Loading animations
- Pagination
- Example questions
- Responsive design

### 4. Streaming Example (`streaming_example.dart`)
Demonstrates word-by-word text streaming.

### 5. Markdown Example (`markdown_example.dart`)
Shows markdown rendering capabilities.

### 6. Pagination Example (`pagination_example.dart`)
Demonstrates loading historical messages.

## Platform-Specific Features

### Android
- Material Design 3 theming
- Adaptive colors
- Native ripple effects

### iOS
- Cupertino-style animations
- Native scrolling behavior
- Adaptive typography

### Web
- Responsive layout
- Keyboard shortcuts
- Touch and mouse input support

### Desktop (Windows, macOS, Linux)
- Window resizing support
- Keyboard navigation
- Native scrollbar styling

## Running the Examples

1. Clone the repository
2. Navigate to the example directory
3. Run `flutter pub get`
4. Run `flutter run`

## Customization

The examples demonstrate various customization options:

- Theme customization
- Message bubble styling
- Input field configuration
- Loading animations
- RTL support
- Dark mode
- Typography
- Animations

## Contributing

Feel free to contribute to these examples by:
1. Creating new examples
2. Improving existing ones
3. Adding documentation
4. Fixing bugs

## License

This example project is licensed under the same terms as the main package.