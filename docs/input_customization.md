# Input Field Customization Guide

The Flutter Gen AI Chat UI package provides extensive customization options for the chat input field. This guide covers all the ways you can customize the appearance and behavior of the input field, from basic styling to advanced glassmorphic effects.

## Basic Input Customization

Pass the `inputOptions` parameter directly to the `AiChatWidget` to customize the input field:

```dart
AiChatWidget(
  // Required parameters
  currentUser: _currentUser,
  aiUser: _aiUser,
  controller: _controller,
  onSendMessage: _handleSendMessage,
  
  // Input customization
  inputOptions: InputOptions(
    // Basic styling
    textStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Colors.black87,
    ),
    decoration: InputDecoration(
      hintText: 'Type a message...',
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: BorderSide.none,
      ),
    ),
    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    
    // Material container customization
    materialElevation: 4.0,  // Lower elevation than default
    materialColor: Colors.grey.shade50,  // Light background
    materialPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
    
    // Size control
    inputHeight: 48.0,  // Fixed height for the text input field
    inputContainerHeight: 64.0,  // Fixed height for the entire container
    
    // Behavior options
    sendOnEnter: true,
    unfocusOnTapOutside: false,
    
    // Text field properties
    maxLines: 5,
    minLines: 1,
    textCapitalization: TextCapitalization.sentences,
  ),
)
```

## Size and Dimension Control

The package provides several ways to control the size of the input field and its container:

```dart
InputOptions(
  // Text input field height
  inputHeight: 50.0,  // Fixed height for the TextField regardless of content
  
  // Container size control
  inputContainerHeight: 70.0,  // Fixed height for the entire input container
  inputContainerWidth: InputContainerWidth.fullWidth,  // How the width is determined
  
  // Advanced size constraints
  inputContainerConstraints: BoxConstraints(
    minWidth: 300,
    maxWidth: 600,
    minHeight: 60,
    maxHeight: 100,
  ),
)
```

### Controlling Input Field Height

The `inputHeight` property sets a fixed height for the text input field itself, overriding the default behavior where height is determined by `minLines` and `maxLines`:

- If you need a specific size for your design, use `inputHeight`
- For adaptive sizing based on content, continue using `minLines` and `maxLines`

```dart
// Fixed height input
InputOptions(
  inputHeight: 56.0,  // Specific height regardless of content
)

// Content-based height (default)
InputOptions(
  minLines: 1,  // Minimum height based on 1 line of text
  maxLines: 5,  // Will expand up to 5 lines before scrolling
)
```

### Container Size Options

Control the entire input container with these properties:

#### Container Height

```dart
InputOptions(
  inputContainerHeight: 80.0,  // Fixed height for the entire input section
)
```

#### Container Width

The `inputContainerWidth` enum offers three options:

```dart
// Take up all available width (default)
InputOptions(
  inputContainerWidth: InputContainerWidth.fullWidth,
)

// Wrap to content width
InputOptions(
  inputContainerWidth: InputContainerWidth.wrapContent,
)

// Use custom width from BoxConstraints
InputOptions(
  inputContainerWidth: InputContainerWidth.custom,
  inputContainerConstraints: BoxConstraints(
    minWidth: 300,
    maxWidth: 500,
  ),
)
```

#### Advanced Constraints

For more complex sizing requirements, use `inputContainerConstraints`:

```dart
InputOptions(
  inputContainerConstraints: BoxConstraints(
    minWidth: 300,
    maxWidth: 600,
    minHeight: 60,
    maxHeight: 100,
  ),
)
```

## Material Container Customization

The input field is wrapped in a `Material` widget that provides elevation and background color. You can customize this container with these properties:

```dart
InputOptions(
  // Material container properties
  materialElevation: 6.0,  // Controls shadow depth (default: 8.0)
  materialColor: Colors.grey.shade100,  // Background color (default: transparent)
  materialPadding: EdgeInsets.all(12),  // Padding around input (default: vertical 8)
  
  // Other input options...
)
```

### Material Elevation

The `materialElevation` property controls the shadow depth of the input container:

- **0.0**: No shadow
- **1.0-4.0**: Subtle shadow
- **5.0-8.0**: Medium shadow
- **9.0+**: Pronounced shadow

### Material Color

The `materialColor` property determines the background color of the input container:

- **Colors.transparent** (default): Shows through to the container decoration or background
- **Theme colors**: Use your theme's colors like `Theme.of(context).cardColor`
- **Custom colors**: Any Color or opacity value like `Colors.blue.withOpacity(0.1)`

## Custom Send Button

You can completely customize the send button using the `sendButtonBuilder` parameter:

```dart
InputOptions(
  sendButtonBuilder: (onSend) => Container(
    margin: EdgeInsets.only(left: 8),
    decoration: BoxDecoration(
      color: Colors.blue,
      shape: BoxShape.circle,
    ),
    child: IconButton(
      onPressed: onSend,
      icon: Icon(Icons.arrow_upward, color: Colors.white),
      tooltip: 'Send message',
    ),
  ),
)
```

## Glassmorphic Effect

### What is Glassmorphic UI?

Glassmorphic UI (or "frosted glass" effect) creates a translucent, blurred element that appears to be made of frosted glass. It's a modern design trend that adds depth and visual interest to your interface.

### Creating Glassmorphic Inputs

There are two ways to create glassmorphic inputs:

#### 1. Using the Glassmorphic Factory Constructor (Recommended)

The easiest way to create a glassmorphic effect is to use the dedicated factory constructor:

```dart
InputOptions.glassmorphic(
  // Gradient colors for the background
  colors: [
    Colors.blue.withOpacity(0.4),
    Colors.purple.withOpacity(0.4),
  ],
  
  // Styling
  borderRadius: 24.0,
  blurStrength: 1.0, // 0.5-2.0 recommended
  backgroundOpacity: 0.15,
  backgroundColor: Colors.white, // For a tinted effect
  
  // Material container customization
  materialElevation: 10.0,  // Stronger shadow for floating effect
  materialColor: Colors.transparent,  // Let the glassmorphic effect show through
  materialPadding: EdgeInsets.symmetric(vertical: 12),  // More vertical space
  
  // Size control
  inputHeight: 56.0,  // Control text field height
  inputContainerHeight: 80.0,  // Control container height
  
  // Text styling
  textColor: Colors.white,
  hintColor: Colors.white.withOpacity(0.7),
  hintText: 'Type a message...',
  
  // Other options
  sendOnEnter: true,
)
```

#### 2. Manual Configuration

For more control, you can manually configure all the properties:

```dart
InputOptions(
  // Text field styling
  textStyle: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.white.withOpacity(0.9),
  ),
  decoration: InputDecoration(
    hintText: 'Message...',
    hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide.none,
    ),
    filled: true,
    fillColor: Colors.transparent,
  ),
  
  // Material container customization
  materialElevation: 12.0,
  materialColor: Colors.transparent,
  materialPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
  
  // Size control
  inputHeight: 50.0,
  inputContainerConstraints: BoxConstraints(
    minHeight: 70.0,
    maxWidth: 600.0,
  ),
  
  // Container styling for glassmorphic effect
  containerDecoration: BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Colors.blue.withOpacity(0.4),
        Colors.purple.withOpacity(0.4),
      ],
    ),
    borderRadius: BorderRadius.circular(25),
    border: Border.all(
      color: Colors.white.withOpacity(0.2),
      width: 1.5,
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.2),
        blurRadius: 15,
        spreadRadius: 5,
      ),
    ],
  ),
  
  // Blur effect settings
  containerBackgroundColor: Colors.white.withOpacity(0.1),
  blurStrength: 0.7,
  containerPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
  clipBehavior: true, // Required for backdrop filter
)
```

### Auto-Theming with Scaffold Background

By default, if you use `Colors.transparent` for the `backgroundColor` (which is the default), the glassmorphic effect will automatically use the Scaffold's background color with a slight opacity. This creates a seamless integration with your app's theme.

```dart
// This will automatically use the Scaffold's background color
InputOptions.glassmorphic(
  blurStrength: 1.2,
  // No backgroundColor specified (uses Colors.transparent by default)
  textColor: Colors.white,
  borderRadius: 24.0,
)
```

### Customizing Blur Strength

The `blurStrength` parameter controls the intensity of the blur effect:

- **Lower values (0.3-0.7)**: Subtle blur effect
- **Medium values (0.8-1.2)**: Standard glassmorphic look
- **Higher values (1.3-2.0)**: Strong blur effect

### Background Color Opacity

The `backgroundOpacity` parameter (or directly setting `containerBackgroundColor` with an opacity) controls how transparent or opaque the glass effect appears:

- **Low opacity (0.05-0.2)**: Very transparent, more of the background shows through
- **Medium opacity (0.3-0.5)**: Balanced transparency
- **High opacity (0.6-0.9)**: More solid appearance with less transparency

## Advanced Customization Examples

### Light Glassmorphic Input

```dart
InputOptions.glassmorphic(
  colors: [
    Colors.blue.withOpacity(0.4),
    Colors.purple.withOpacity(0.4),
  ],
  borderRadius: 24.0,
  blurStrength: 0.7,
  backgroundOpacity: 0.1,
  backgroundColor: Colors.white,
  textColor: Colors.white,
  materialElevation: 6.0,  // Medium elevation
  inputHeight: 48.0,  // Fixed text field height
)
```

### Dark Glassmorphic Input

```dart
InputOptions.glassmorphic(
  colors: [
    Colors.indigo.withOpacity(0.3),
    Colors.blue.withOpacity(0.3),
  ],
  borderRadius: 24.0,
  blurStrength: 1.5,
  backgroundOpacity: 0.3,
  backgroundColor: Colors.black,
  textColor: Colors.white,
  hintColor: Colors.blue.shade100,
  materialElevation: 12.0,  // Strong elevation for floating effect
  materialPadding: EdgeInsets.symmetric(vertical: 12),  // More space
  inputContainerHeight: 75.0,  // Taller input area
)
```

### Teal/Cyan Theme

```dart
InputOptions.glassmorphic(
  colors: [
    Colors.teal.withOpacity(0.4),
    Colors.cyan.withOpacity(0.4),
  ],
  borderRadius: 24.0,
  blurStrength: 1.2,
  backgroundOpacity: 0.15,
  backgroundColor: Colors.white,
  borderColor: Colors.cyan,
  textColor: Colors.white,
  materialColor: Colors.teal.withOpacity(0.05),  // Subtle teal tint
  inputContainerConstraints: BoxConstraints(
    maxWidth: 500.0,  // Maximum width of 500px
  ),
  inputContainerWidth: InputContainerWidth.custom,
)
```

### Flat Design (No Elevation)

```dart
InputOptions(
  decoration: InputDecoration(
    hintText: 'Type a message...',
    filled: true,
    fillColor: Colors.grey.shade100,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
  ),
  materialElevation: 0.0,  // No elevation for flat design
  materialColor: Colors.grey.shade50,
  materialPadding: EdgeInsets.symmetric(vertical: 16),  // More vertical padding
  inputHeight: 44.0,  // Compact input height
)
```