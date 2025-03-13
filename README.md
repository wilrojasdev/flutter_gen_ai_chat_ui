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

### Extensive Customization Options
- 🎨 **Extensive Customization Options**: Customize every aspect of the chat UI.
- 📝 **Rich Text Support**: Supports markdown, code blocks, and custom formatting.
- 🔄 **Built-in Loading States**: Elegant loading indicators for AI responses.
- 🌙 **Dark Mode Support**: Seamlessly adapts to your app's theme.
- 📱 **Responsive Design**: Works on all screen sizes.
- 🎭 **Custom User Avatars**: Support for user avatars and AI avatars.
- 💬 **Typography Control**: Customize fonts, sizes, and text styling.
- ✨ **Modern Glassmorphic Effects**: Create beautiful frosted glass inputs with blur effects that automatically adapt to your app's theme.

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

## Advanced Input Field Customization

The package provides multiple ways to customize the input field, from simple styling to complete custom implementations:

### Disable the Outer Container

You can now completely disable the outer container for full control over the input field styling:

```dart
inputOptions: InputOptions(
  useOuterContainer: false, // Remove the outer Material container
  decoration: InputDecoration(
    // Your custom decoration
  ),
)
```

### Factory Constructors for Common Styles

#### Minimal Input Field

For a clean, borderless input with no outer container:

```dart
inputOptions: InputOptions.minimal(
  hintText: 'Message...',
  textColor: Colors.black,
  hintColor: Colors.grey,
  backgroundColor: Colors.white,
  borderRadius: 24.0,
)
```

#### Glassmorphic Input Field

Create a beautiful frosted glass effect:

```dart
inputOptions: InputOptions.glassmorphic(
  colors: [Colors.blue.withOpacity(0.2), Colors.purple.withOpacity(0.2)],
  borderRadius: 24.0,
  blurStrength: 10.0,
  useOuterContainer: true, // Keep the container for the blur effect
)
```

#### Custom Input Field

For complete control over all aspects:

```dart
inputOptions: InputOptions.custom(
  decoration: yourCustomDecoration,
  textStyle: yourCustomTextStyle,
  sendButtonBuilder: (onSend) => YourCustomSendButton(onSend: onSend),
  useOuterContainer: false,
)
```

This flexibility allows developers to implement exactly the design they want, whether using the built-in styling or creating something completely custom.

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
  
  // Example questions
  exampleQuestions: [
    ExampleQuestion(question: 'What is AI?'),
    ExampleQuestion(question: 'How does machine learning work?'),
  ],
  persistentExampleQuestions: true, // Keep suggestions visible after welcome message disappears
  
  // Specialized configs
  inputOptions: InputOptions(...),
  messageOptions: MessageOptions(...),
  paginationConfig: PaginationConfig(...),
  loadingConfig: LoadingConfig(...),
  callbackConfig: CallbackConfig(...),
  
  // Welcome message
  welcomeMessageConfig: WelcomeMessageConfig(...),
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

## Backward Compatibility

This package has been updated to maintain backward compatibility with older versions and DashChat. The following compatibility features have been added:

### ChatUser Changes
- Added support for `firstName` parameter as an alternative to `name`.
- Made `name` parameter optional (falls back to `firstName` or `id`).

### Controller Changes
- Added support for `onLoadMoreMessages` parameter in the `ChatMessagesController` constructor.

### Input Options
- Added backward compatibility parameters:
  - `textController`: Support for passing in a TextEditingController
  - `inputTextDirection`: Support for specifying input direction
  - `inputTextStyle`: Support for styling input (alias of `textStyle`)
  - `inputDecoration`: Support for decorating input (alias of `decoration`)

### Message Options
- Added backward compatibility parameters:
  - `containerColor`: Support for specifying message bubble background color
  - Added logic to properly handle both new and old styling parameters

### Widgets
- Added `LoadingWidget` class for custom loading indicators
- Updated message rendering to respect both old and new styling parameters
- Made LoadingWidget reuse existing custom loading indicators

These changes ensure smoother migration from older versions to the latest version with minimal code changes required.

## Customization

### Input Field Customization

The package provides extensive options for customizing the chat input field, including a beautiful glassmorphic effect:

```dart
// Basic input customization
InputOptions(
  textStyle: TextStyle(fontSize: 16),
  decoration: InputDecoration(
    hintText: 'Type a message...',
    filled: true,
    fillColor: Colors.grey.shade100,
  ),
)

// Glassmorphic input (frosted glass effect)
InputOptions.glassmorphic(
  colors: [Colors.blue.withOpacity(0.4), Colors.purple.withOpacity(0.4)],
  borderRadius: 24.0,
  blurStrength: 1.0,
  textColor: Colors.white,
)
```

The glassmorphic effect automatically adapts to your app's theme when no background color is specified. See the [Input Customization Guide](docs/input_customization.md) for more details.