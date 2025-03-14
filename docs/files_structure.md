# Package Structure

This document outlines the organization of the Flutter Gen AI Chat UI package.

## Directory Structure

```
flutter_gen_ai_chat_ui/
│
├── lib/                    # Main package code
│   ├── flutter_gen_ai_chat_ui.dart  # Main entry point / exports
│   │
│   └── src/                # Source code
│       ├── controllers/    # State management
│       ├── models/         # Data models
│       ├── theme/          # Theme extensions
│       ├── utils/          # Utility functions
│       └── widgets/        # UI components
│
├── example/                # Example application
│
├── docs/                   # Documentation
│   ├── USAGE.md            # Usage guide
│   ├── MIGRATION.md        # Migration guide
│   └── files_structure.md  # This file
│
└── test/                   # Tests
```

## Core Components

### Controllers

| File | Description |
|------|-------------|
| `chat_messages_controller.dart` | Manages chat messages, loading states, and pagination |

### Models

| File | Description |
|------|-------------|
| `chat_message.dart` | Message data structure |
| `chat_user.dart` | User data structure |
| `input_options.dart` | Input field configuration |
| `welcome_message_config.dart` | Welcome message styling |
| `example_question.dart` | Example question model |
| `ai_chat_config.dart` | Legacy configuration (deprecated) |

### Widgets

| File | Description |
|------|-------------|
| `ai_chat_widget.dart` | Main chat widget (entry point) |
| `chat_input.dart` | Input field component |
| `custom_chat_widget.dart` | Customizable chat UI |
| `message_content_text.dart` | Text content renderer |
| `animated_text.dart` | Streaming text animation |
| `markdown_renderer.dart` | Markdown rendering component |
| `welcome_message.dart` | Welcome message component |
| `example_questions_list.dart` | Suggestions component |

### Theme

| File | Description |
|------|-------------|
| `custom_theme_extension.dart` | Theme extensions for the chat UI |

### Utils

| File | Description |
|------|-------------|
| `glassmorphic_container.dart` | Frosted glass effect |
| `font_helper.dart` | Typography utilities |
| `locale_helper.dart` | RTL/Localization support |

## Entry Points

The main entry point for the package is `flutter_gen_ai_chat_ui.dart`, which exports all public APIs.

## Key APIs

### Main Widget

`AiChatWidget` - The primary widget to integrate in your application.

### Configuration Objects

- `InputOptions` - Input field styling and behavior
- `MessageOptions` - Message styling and layout
- `LoadingConfig` - Loading state indicators
- `PaginationConfig` - Message history pagination

### Controllers

`ChatMessagesController` - Manages message state and interactions

### Models

- `ChatUser` - User representation
- `ChatMessage` - Message content and metadata

## Example App

The example app demonstrates:

1. Basic chat implementation
2. Streaming text responses
3. Markdown formatting
4. Theme customization
5. Configuration options

## Deprecations

The following are maintained for backward compatibility but are deprecated:

- `AiChatConfig` - Use direct parameters on `AiChatWidget` instead 