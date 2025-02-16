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
- 📝 Enhanced markdown support with code highlighting
- 🎤 Optional speech-to-text integration
- 📱 Responsive layout with customizable width
- 🌐 RTL language support
- ⚡ High performance message handling
- 📊 Improved pagination support
- 🔄 Centralized configuration

### UI Components
- 💬 Customizable message bubbles
- ⌨️ Rich input field options
- 🔄 Loading indicators with shimmer
- ⬇️ Smart scroll management
- 👋 Welcome message widget
- ❓ Example questions component
- 🎨 Enhanced theme customization
- 📝 Better code block styling

## Quick Start

```dart
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';

AiChatWidget(
  config: AiChatConfig(
    hintText: 'Type a message...',
    enableAnimation: true,
    inputOptions: InputOptions(
      alwaysShowSend: true,
      sendOnEnter: true,
      margin: EdgeInsets.all(16),
    ),
    messageOptions: MessageOptions(
      showTime: true,
      containerColor: Colors.grey[200],
    ),
    // New in 1.3.0: Enhanced configuration options
    paginationConfig: PaginationConfig(
      enabled: true,
      loadingIndicatorOffset: 100,
    ),
    loadingConfig: LoadingConfig(
      isLoading: false,
      typingIndicatorColor: Colors.blue,
    ),
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
  flutter_gen_ai_chat_ui: ^1.3.0
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

## What's New in 1.3.0

### Breaking Changes
1. All widget-level configurations now flow through `AiChatConfig`
2. Improved input handling with standalone `InputOptions`
3. Enhanced pagination with `PaginationConfig`
4. Better loading states with `LoadingConfig`
5. Centralized callbacks in `CallbackConfig`

### New Features
1. Enhanced markdown support with better code block styling
2. Improved dark theme contrast and readability
3. Better message bubble animations
4. Fixed layout overflow issues
5. Enhanced error handling

### Migration Guide
If you're upgrading from version 1.2.x:

```dart
// Old way (deprecated)
AiChatWidget(
  enableAnimation: true,
  loadingIndicator: MyLoadingWidget(),
  inputDecoration: InputDecoration(...),
)

// New way (1.3.0+)
AiChatWidget(
  config: AiChatConfig(
    enableAnimation: true,
    loadingConfig: LoadingConfig(
      loadingIndicator: MyLoadingWidget(),
    ),
    inputOptions: InputOptions(
      inputDecoration: InputDecoration(...),
    ),
  ),
)
```

## Configuration

The new configuration system in 1.3.0 provides better organization and type safety:

```dart
AiChatConfig(
  // Basic settings
  userName: 'User',
  aiName: 'AI',
  hintText: 'Type a message...',
  maxWidth: null,
  
  // Feature flags
  enableAnimation: true,
  showTimestamp: true,
  
  // Specialized configs
  inputOptions: InputOptions(...),
  messageOptions: MessageOptions(...),
  paginationConfig: PaginationConfig(...),
  loadingConfig: LoadingConfig(...),
  callbackConfig: CallbackConfig(...),
  
  // Welcome message
  welcomeMessageConfig: WelcomeMessageConfig(...),
  exampleQuestions: [...],
)
```

### Input Customization
```dart
InputOptions(
  // Basic options
  sendOnEnter: true,
  alwaysShowSend: true,
  
  // Styling
  margin: EdgeInsets.all(16),
  inputTextStyle: TextStyle(...),
  inputDecoration: InputDecoration(...),
  
  // Advanced
  maxLines: 5,
  textCapitalization: TextCapitalization.sentences,
  contextMenuBuilder: (context, editableTextState) => ...,
)
```

### Pagination
```dart
PaginationConfig(
  enabled: true,
  loadingIndicatorOffset: 100,
  loadMoreIndicator: ({isLoading}) => CustomLoadingWidget(),
)
```

### Loading States
```dart
LoadingConfig(
  isLoading: false,
  loadingIndicator: CustomLoadingWidget(),
  typingIndicatorColor: Colors.blue,
  typingIndicatorSize: 24.0,
)
```

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

## Version Compatibility

| Flutter Version | Package Version |
|----------------|-----------------|
| >=3.0.0        | ^1.3.0         |
| >=2.5.0        | ^1.2.0         |

## License

[MIT License](LICENSE)

---
⭐ If you find this package helpful, please star the repository!