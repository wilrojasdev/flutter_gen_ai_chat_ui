# Flutter Gen AI Chat UI

[![pub package](https://img.shields.io/pub/v/flutter_gen_ai_chat_ui.svg)](https://pub.dev/packages/flutter_gen_ai_chat_ui)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A modern, customizable chat UI for AI applications built with Flutter. Features streaming responses, markdown support, and rich customization options.

## Table of Contents
- [Features](#features)
- [Installation](#installation)
- [Basic Usage](#basic-usage)
- [Configuration Options](#configuration-options)
- [Advanced Features](#advanced-features)
- [Platform Support](#platform-support)
- [Examples](#examples)

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

### AI-Specific Features
- 👋 Customizable welcome message
- ❓ Example questions component
- 💬 Persistent example questions
- 🔄 AI typing indicators
- 📜 Streaming markdown rendering

### UI Components
- 💬 Customizable message bubbles
- ⌨️ Multiple input field styles (minimal, glassmorphic, custom)
- 🔄 Loading indicators with shimmer
- ⬇️ Smart scroll management
- 🎨 Enhanced theme customization
- 📝 Better code block styling

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_gen_ai_chat_ui: ^1.3.0
```

Then run:
```bash
flutter pub get
```

Import the package:
```dart
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';
```

## Basic Usage

```dart
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';
import 'package:flutter/material.dart';

class BasicChatScreen extends StatefulWidget {
  @override
  _BasicChatScreenState createState() => _BasicChatScreenState();
}

class _BasicChatScreenState extends State<BasicChatScreen> {
  final _chatController = ChatMessagesController();
  final _currentUser = ChatUser(id: 'user1', firstName: 'User');
  final _aiUser = ChatUser(id: 'ai1', firstName: 'AI Assistant');
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('AI Chat')),
      body: AiChatWidget(
        // Required parameters
        currentUser: _currentUser,
        aiUser: _aiUser,
        controller: _chatController,
        onSendMessage: _handleSendMessage,
        
        // Optional parameters
        inputOptions: InputOptions(
          sendOnEnter: true,
          alwaysShowSend: true,
        ),
        loadingConfig: LoadingConfig(
          isLoading: _isLoading,
        ),
        exampleQuestions: [
          ExampleQuestion(question: 'What is AI?'),
          ExampleQuestion(question: 'How can you help me?'),
        ],
      ),
    );
  }

  void _handleSendMessage(ChatMessage message) async {
    // Handle user message
    setState(() => _isLoading = true);
    
    // Simulate AI response after a delay
    await Future.delayed(Duration(seconds: 1));
    
    // Add AI response
    _chatController.addMessage(
      ChatMessage(
        text: "This is a response to: ${message.text}",
        user: _aiUser,
        createdAt: DateTime.now(),
      ),
    );
    
    setState(() => _isLoading = false);
  }
}
```

## Configuration Options

### AiChatWidget Parameters

#### Required Parameters
```dart
AiChatWidget(
  // Required parameters
  currentUser: ChatUser(...),  // The current user
  aiUser: ChatUser(...),       // The AI assistant
  controller: ChatMessagesController(),  // Message controller
  onSendMessage: (message) {   // Message handler
    // Handle user messages here
  },
  
  // ... optional parameters
)
```

#### Optional Parameters

```dart
AiChatWidget(
  // ... required parameters
  
  // Message display options
  messages: [],                // Optional list of messages (if not using controller)
  messageOptions: MessageOptions(...),  // Message bubble styling
  messageListOptions: MessageListOptions(...),  // Message list behavior
  
  // Input field customization
  inputOptions: InputOptions(...),  // Input field styling and behavior
  readOnly: false,             // Whether the chat is read-only
  
  // AI-specific features
  exampleQuestions: [          // Suggested questions for users
    ExampleQuestion(question: 'What is AI?'),
  ],
  persistentExampleQuestions: true,  // Keep questions visible after welcome
  enableAnimation: true,       // Enable message animations
  enableMarkdownStreaming: true,  // Enable streaming text
  streamingDuration: Duration(milliseconds: 30),  // Stream speed
  welcomeMessageConfig: WelcomeMessageConfig(...),  // Welcome message styling
  
  // Loading states
  loadingConfig: LoadingConfig(  // Loading configuration
    isLoading: false,
    showCenteredIndicator: true,
  ),
  
  // Pagination
  paginationConfig: PaginationConfig(  // Pagination configuration
    enabled: true,
    reverseOrder: true,  // Newest messages at bottom
  ),
  
  // Layout
  maxWidth: 800,             // Maximum width
  padding: EdgeInsets.all(16),  // Overall padding
)
```

### Input Field Customization

The package offers multiple ways to style the input field:

#### Default Input

```dart
InputOptions(
  // Basic properties
  sendOnEnter: true,
  alwaysShowSend: true,
  
  // Styling
  textStyle: TextStyle(...),
  decoration: InputDecoration(...),
)
```

#### Minimal Input

```dart
InputOptions.minimal(
  hintText: 'Ask a question...',
  textColor: Colors.black,
  hintColor: Colors.grey,
  backgroundColor: Colors.white,
  borderRadius: 24.0,
)
```

#### Glassmorphic (Frosted Glass) Input

```dart
InputOptions.glassmorphic(
  colors: [Colors.blue.withOpacity(0.2), Colors.purple.withOpacity(0.2)],
  borderRadius: 24.0,
  blurStrength: 10.0,
  hintText: 'Ask me anything...',
  textColor: Colors.white,
)
```

#### Custom Input

```dart
InputOptions.custom(
  decoration: yourCustomDecoration,
  textStyle: yourCustomTextStyle,
  sendButtonBuilder: (onSend) => CustomSendButton(onSend: onSend),
)
```

### Message Bubble Customization

```dart
MessageOptions(
  // Basic options
  showTime: true,
  showUserName: true,
  
  // Styling
  bubbleStyle: BubbleStyle(
    userBubbleColor: Colors.blue.withOpacity(0.1),
    aiBubbleColor: Colors.white,
    userNameColor: Colors.blue.shade700,
    aiNameColor: Colors.purple.shade700,
    bottomLeftRadius: 22,
    bottomRightRadius: 22,
    enableShadow: true,
  ),
)
```

### Loading Configuration

```dart
LoadingConfig(
  isLoading: true,  // Whether the AI is currently generating a response
  loadingIndicator: CustomLoadingWidget(),  // Custom loading indicator
  typingIndicatorColor: Colors.blue,  // Color for the typing indicator
  showCenteredIndicator: false,  // Show indicator in center or as typing
)
```

### Pagination Configuration

```dart
PaginationConfig(
  enabled: true,  // Enable pagination for large message histories
  loadingIndicatorOffset: 100,  // How far from top to trigger loading
  reverseOrder: true,  // Show newest messages at bottom
)
```

## Advanced Features

### Streaming Text

To enable word-by-word text streaming:

```dart
AiChatWidget(
  // ... other parameters
  enableMarkdownStreaming: true,
  streamingDuration: Duration(milliseconds: 30),
  
  onSendMessage: (message) async {
    // Start with an empty message
    final aiMessage = ChatMessage(
      text: "",
      user: aiUser,
      createdAt: DateTime.now(),
      isMarkdown: true,
    );
    
    // Add to the chat
    _chatController.addMessage(aiMessage);
    
    // Stream the response word by word
    final response = "This is a **streaming** response with `code` and more...";
    String accumulating = "";
    
    for (final word in response.split(" ")) {
      await Future.delayed(Duration(milliseconds: 100));
      accumulating += (accumulating.isEmpty ? "" : " ") + word;
      
      // Update the message with new text
      _chatController.updateMessage(
        aiMessage.copyWith(text: accumulating),
      );
    }
  },
)
```

### Welcome Message Configuration

```dart
// The welcome message is disabled by default and only appears 
// when this configuration is provided
WelcomeMessageConfig(
  title: "Welcome to My AI Assistant",
  containerPadding: EdgeInsets.all(24),
  questionsSectionTitle: "Try asking me:",
)
```

### Controller Methods

```dart
// Initialize controller
final controller = ChatMessagesController();

// Add a message
controller.addMessage(ChatMessage(...));

// Add multiple messages
controller.addMessages([ChatMessage(...), ChatMessage(...)]);

// Update a message (useful for streaming)
controller.updateMessage(message.copyWith(text: newText));

// Clear all messages
controller.clearMessages();

// Hide the welcome message
controller.hideWelcomeMessage();

// Show/hide welcome message programmatically
controller.showWelcomeMessage = true;  // Show welcome message
controller.showWelcomeMessage = false; // Hide welcome message

// Manually scroll to bottom
controller.scrollToBottom();

// Load more messages (for pagination)
controller.loadMore(() async {
  return await fetchOlderMessages();
});
```

## Platform Support

✅ Android
✅ iOS
✅ Web
✅ macOS
✅ Windows
✅ Linux

## Examples

Check the [example](example) directory for complete sample applications showcasing different features.

## License

[MIT License](LICENSE)

---
⭐ If you find this package helpful, please star the repository!