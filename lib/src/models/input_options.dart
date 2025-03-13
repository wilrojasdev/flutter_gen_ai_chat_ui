import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Controls how the input container's width should be sized
enum InputContainerWidth {
  /// Use the maximum available width
  fullWidth,

  /// Use the width of the content plus padding
  wrapContent,

  /// Use a specific width provided in inputContainerConstraints
  custom
}

/// Extended input options for the chat UI.
/// Provides comprehensive customization options for the input field.
class InputOptions {
  /// Style for the input text
  final TextStyle? textStyle;

  /// Decoration for the input field
  final InputDecoration? decoration;

  /// Margin around the input field
  final EdgeInsets? margin;

  /// Container decoration for the input area
  /// Use this to style the container that holds the input field (e.g., for glassmorphic effects)
  final BoxDecoration? containerDecoration;

  /// Background color inside the container (on top of the blur)
  /// This controls the opacity level of the blurred background
  /// Use fully transparent for maximum blur effect, or add slight color for tinted glass effect
  final Color containerBackgroundColor;

  /// The blur strength used in the backdrop filter effect (when clipBehavior is true)
  /// Higher values create a more intense blur effect
  final double blurStrength;

  /// Padding inside the container that holds the input
  final EdgeInsets? containerPadding;

  /// Whether to apply ClipRRect with borderRadius to match the container decoration
  final bool clipBehavior;

  /// Whether to use the outer Material container for the input
  /// When set to false, only the raw ChatInput will be rendered without the Material wrapper
  /// This gives developers complete control over the input field's appearance
  final bool useOuterContainer;

  /// Elevation for the Material widget wrapping the input field
  /// Controls the shadow depth of the input container
  final double materialElevation;

  /// Color for the Material widget wrapping the input field
  /// Use Colors.transparent to let the container decoration show through
  final Color materialColor;

  /// Shape for the Material widget wrapping the input field
  /// Controls the border and border radius of the material
  final ShapeBorder? materialShape;

  /// Whether to use the scaffold background color instead of materialColor
  /// When true, the input container will adapt to the theme's scaffold color
  final bool useScaffoldBackground;

  /// Position from the left edge when used in a Positioned widget
  /// Only applied when input is placed in a Stack with Positioned
  final double? positionedLeft;

  /// Position from the right edge when used in a Positioned widget
  /// Only applied when input is placed in a Stack with Positioned
  final double? positionedRight;

  /// Position from the bottom edge when used in a Positioned widget
  /// Only applied when input is placed in a Stack with Positioned
  final double? positionedBottom;

  /// Position from the top edge when used in a Positioned widget
  /// Only applied when input is placed in a Stack with Positioned
  final double? positionedTop;

  /// Padding for the Material widget wrapping the input field
  /// Controls space around the input container
  final EdgeInsets materialPadding;

  /// Explicit height for the text input field
  /// When set, this overrides the height calculated from minLines/maxLines
  /// Set to null (default) to use the standard height calculation based on lines
  final double? inputHeight;

  /// Height for the entire input container
  /// When set, the container will have this exact height regardless of content
  /// Set to null (default) for the container to size based on its content
  final double? inputContainerHeight;

  /// Constraints for the input container
  /// Provides more advanced control over minimum and maximum dimensions
  /// Set to null (default) to use standard constraints based on content
  final BoxConstraints? inputContainerConstraints;

  /// Controls how the input container width is determined
  /// - fullWidth: Uses the maximum available width (default)
  /// - wrapContent: Sizes to the content width plus padding
  /// - custom: Uses width from inputContainerConstraints
  final InputContainerWidth inputContainerWidth;

  /// Builder for the send button
  final Widget Function(VoidCallback onSend)? sendButtonBuilder;

  /// Whether to send on enter key press
  final bool sendOnEnter;

  /// Whether to always show the send button
  final bool alwaysShowSend;

  /// Whether to enable autocorrect.
  final bool autocorrect;

  /// @deprecated Use sendButtonBuilder instead
  final IconData? sendButtonIcon;

  /// @deprecated Use sendButtonBuilder instead
  final double? sendButtonIconSize;

  /// @deprecated Use sendButtonBuilder instead
  final EdgeInsets? sendButtonPadding;

  /// Text controller for the input field (added for backward compatibility)
  final TextEditingController? textController;

  /// Text direction for the input (added for backward compatibility)
  final TextDirection? inputTextDirection;

  /// Text style for the input (added for backward compatibility)
  final TextStyle? inputTextStyle;

  /// Decoration for the input (added for backward compatibility)
  final InputDecoration? inputDecoration;

  Widget Function(VoidCallback onSend) get effectiveSendButtonBuilder =>
      sendButtonBuilder ?? _buildDefaultSendButton;

  static Widget _buildDefaultSendButton(VoidCallback onSend) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: IconButton(
        onPressed: onSend,
        icon: const Icon(Icons.send, size: 24),
        padding: const EdgeInsets.all(8),
      ),
    );
  }

  /// The type of capitalization to use for the text input.
  final TextCapitalization textCapitalization;

  /// The maximum number of lines for the input field.
  final int maxLines;

  /// The minimum number of lines for the input field.
  final int minLines;

  /// The type of action button to show on the keyboard.
  final TextInputAction textInputAction;

  /// The type of keyboard to show.
  final TextInputType keyboardType;

  /// The color of the cursor.
  final Color? cursorColor;

  /// The height of the cursor.
  final double? cursorHeight;

  /// The width of the cursor.
  final double cursorWidth;

  /// The radius of the cursor.
  final Radius? cursorRadius;

  /// Whether to show the cursor.
  final bool showCursor;

  /// Whether to show input suggestions.
  final bool enableSuggestions;

  /// Whether to enable IME personalized learning.
  final bool enableIMEPersonalizedLearning;

  /// Whether the text field is read-only.
  final bool readOnly;

  /// The handling of smart dashes.
  final SmartDashesType? smartDashesType;

  /// The handling of smart quotes.
  final SmartQuotesType? smartQuotesType;

  /// Widget for showing the selection handles.
  final TextSelectionControls? selectionControls;

  /// Called when the text field is tapped.
  final VoidCallback? onTap;

  /// Called when editing is complete.
  final VoidCallback? onEditingComplete;

  /// Called when the text field is submitted.
  final ValueChanged<String>? onSubmitted;

  /// Called when the text field's content changes.
  final ValueChanged<String>? onChanged;

  /// Optional input formatters to use.
  final List<TextInputFormatter>? inputFormatters;

  /// The cursor for a mouse pointer when it enters or hovers over the text field.
  final MouseCursor? mouseCursor;

  /// Builds the context menu.
  /// Defaults to [_defaultContextMenuBuilder] which provides standard text editing options.
  final EditableTextContextMenuBuilder contextMenuBuilder;

  /// Controller for undo/redo operations.
  final UndoHistoryController? undoController;

  /// Configuration for spell check.
  final SpellCheckConfiguration? spellCheckConfiguration;

  /// Configuration for the magnifier.
  final TextMagnifierConfiguration? magnifierConfiguration;

  const InputOptions({
    this.textStyle,
    this.decoration = const InputDecoration(
      hintText: 'Type a message...',
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        borderSide: BorderSide.none,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      filled: true,
      fillColor: null,
    ),
    this.margin = const EdgeInsets.all(16),
    this.containerDecoration = const BoxDecoration(
      color: null,
      borderRadius: BorderRadius.all(Radius.circular(22)),
      boxShadow: [
        BoxShadow(
          color: Color(0x0D000000),
          blurRadius: 8,
          offset: Offset(0, 3),
          spreadRadius: -2,
        ),
      ],
    ),
    this.containerBackgroundColor = Colors.transparent,
    this.blurStrength = 1.0,
    this.containerPadding =
        const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
    this.clipBehavior = true,
    this.useOuterContainer = true,
    this.materialElevation = 0.0,
    this.materialColor = Colors.transparent,
    this.materialShape,
    this.useScaffoldBackground = false,
    this.positionedLeft,
    this.positionedRight,
    this.positionedBottom,
    this.positionedTop,
    this.materialPadding = const EdgeInsets.symmetric(vertical: 8),
    this.inputHeight,
    this.inputContainerHeight,
    this.inputContainerConstraints,
    this.inputContainerWidth = InputContainerWidth.fullWidth,
    this.sendButtonBuilder,
    this.sendOnEnter = false,
    this.alwaysShowSend = true,
    this.autocorrect = true,
    this.sendButtonIcon,
    this.sendButtonIconSize,
    this.sendButtonPadding,
    this.textController,
    this.inputTextDirection,
    this.inputTextStyle,
    this.inputDecoration,
    this.textCapitalization = TextCapitalization.sentences,
    this.maxLines = 5,
    this.minLines = 1,
    this.textInputAction = TextInputAction.newline,
    this.keyboardType = TextInputType.multiline,
    this.cursorColor,
    this.cursorHeight,
    this.cursorWidth = 2.0,
    this.cursorRadius,
    this.showCursor = true,
    this.enableSuggestions = true,
    this.enableIMEPersonalizedLearning = true,
    this.readOnly = false,
    this.smartDashesType,
    this.smartQuotesType,
    this.selectionControls,
    this.onTap,
    this.onEditingComplete,
    this.onSubmitted,
    this.onChanged,
    this.inputFormatters,
    this.mouseCursor,
    this.contextMenuBuilder = _defaultContextMenuBuilder,
    this.undoController,
    this.spellCheckConfiguration,
    this.magnifierConfiguration,
  });

  /// Creates a copy of this options with the given fields replaced with new values
  InputOptions copyWith({
    TextStyle? textStyle,
    InputDecoration? decoration,
    EdgeInsets? margin,
    BoxDecoration? containerDecoration,
    Color? containerBackgroundColor,
    double? blurStrength,
    EdgeInsets? containerPadding,
    bool? clipBehavior,
    bool? useOuterContainer,
    double? materialElevation,
    Color? materialColor,
    ShapeBorder? materialShape,
    bool? useScaffoldBackground,
    double? positionedLeft,
    double? positionedRight,
    double? positionedBottom,
    double? positionedTop,
    EdgeInsets? materialPadding,
    double? inputHeight,
    double? inputContainerHeight,
    BoxConstraints? inputContainerConstraints,
    InputContainerWidth? inputContainerWidth,
    Widget Function(VoidCallback onSend)? sendButtonBuilder,
    bool? sendOnEnter,
    bool? alwaysShowSend,
    bool? autocorrect,
    IconData? sendButtonIcon,
    double? sendButtonIconSize,
    EdgeInsets? sendButtonPadding,
    TextCapitalization? textCapitalization,
    int? maxLines,
    int? minLines,
    TextInputAction? textInputAction,
    TextInputType? keyboardType,
    Color? cursorColor,
    double? cursorHeight,
    double? cursorWidth,
    Radius? cursorRadius,
    bool? showCursor,
    bool? enableSuggestions,
    bool? enableIMEPersonalizedLearning,
    bool? readOnly,
    SmartDashesType? smartDashesType,
    SmartQuotesType? smartQuotesType,
    TextSelectionControls? selectionControls,
    VoidCallback? onTap,
    VoidCallback? onEditingComplete,
    ValueChanged<String>? onSubmitted,
    ValueChanged<String>? onChanged,
    List<TextInputFormatter>? inputFormatters,
    MouseCursor? mouseCursor,
    EditableTextContextMenuBuilder? contextMenuBuilder,
    UndoHistoryController? undoController,
    SpellCheckConfiguration? spellCheckConfiguration,
    TextMagnifierConfiguration? magnifierConfiguration,
  }) =>
      InputOptions(
        textStyle: textStyle ?? this.textStyle,
        decoration: decoration ?? this.decoration,
        margin: margin ?? this.margin,
        containerDecoration: containerDecoration ?? this.containerDecoration,
        containerBackgroundColor:
            containerBackgroundColor ?? this.containerBackgroundColor,
        blurStrength: blurStrength ?? this.blurStrength,
        containerPadding: containerPadding ?? this.containerPadding,
        clipBehavior: clipBehavior ?? this.clipBehavior,
        useOuterContainer: useOuterContainer ?? this.useOuterContainer,
        materialElevation: materialElevation ?? this.materialElevation,
        materialColor: materialColor ?? this.materialColor,
        materialShape: materialShape ?? this.materialShape,
        useScaffoldBackground:
            useScaffoldBackground ?? this.useScaffoldBackground,
        positionedLeft: positionedLeft ?? this.positionedLeft,
        positionedRight: positionedRight ?? this.positionedRight,
        positionedBottom: positionedBottom ?? this.positionedBottom,
        positionedTop: positionedTop ?? this.positionedTop,
        materialPadding: materialPadding ?? this.materialPadding,
        inputHeight: inputHeight ?? this.inputHeight,
        inputContainerHeight: inputContainerHeight ?? this.inputContainerHeight,
        inputContainerConstraints:
            inputContainerConstraints ?? this.inputContainerConstraints,
        inputContainerWidth: inputContainerWidth ?? this.inputContainerWidth,
        sendButtonBuilder: sendButtonBuilder ?? this.sendButtonBuilder,
        sendOnEnter: sendOnEnter ?? this.sendOnEnter,
        alwaysShowSend: alwaysShowSend ?? this.alwaysShowSend,
        autocorrect: autocorrect ?? this.autocorrect,
        sendButtonIcon: sendButtonIcon ?? this.sendButtonIcon,
        sendButtonIconSize: sendButtonIconSize ?? this.sendButtonIconSize,
        sendButtonPadding: sendButtonPadding ?? this.sendButtonPadding,
        textCapitalization: textCapitalization ?? this.textCapitalization,
        maxLines: maxLines ?? this.maxLines,
        minLines: minLines ?? this.minLines,
        textInputAction: textInputAction ?? this.textInputAction,
        keyboardType: keyboardType ?? this.keyboardType,
        cursorColor: cursorColor ?? this.cursorColor,
        cursorHeight: cursorHeight ?? this.cursorHeight,
        cursorWidth: cursorWidth ?? this.cursorWidth,
        cursorRadius: cursorRadius ?? this.cursorRadius,
        showCursor: showCursor ?? this.showCursor,
        enableSuggestions: enableSuggestions ?? this.enableSuggestions,
        enableIMEPersonalizedLearning:
            enableIMEPersonalizedLearning ?? this.enableIMEPersonalizedLearning,
        readOnly: readOnly ?? this.readOnly,
        smartDashesType: smartDashesType ?? this.smartDashesType,
        smartQuotesType: smartQuotesType ?? this.smartQuotesType,
        selectionControls: selectionControls ?? this.selectionControls,
        onTap: onTap ?? this.onTap,
        onEditingComplete: onEditingComplete ?? this.onEditingComplete,
        onSubmitted: onSubmitted ?? this.onSubmitted,
        onChanged: onChanged ?? this.onChanged,
        inputFormatters: inputFormatters ?? this.inputFormatters,
        mouseCursor: mouseCursor ?? this.mouseCursor,
        contextMenuBuilder: contextMenuBuilder ?? this.contextMenuBuilder,
        undoController: undoController ?? this.undoController,
        spellCheckConfiguration:
            spellCheckConfiguration ?? this.spellCheckConfiguration,
        magnifierConfiguration:
            magnifierConfiguration ?? this.magnifierConfiguration,
      );

  static Widget _defaultContextMenuBuilder(
    BuildContext context,
    EditableTextState editableTextState,
  ) {
    return AdaptiveTextSelectionToolbar.editableText(
      editableTextState: editableTextState,
    );
  }

  /// Returns the effective text style, considering both the new and deprecated parameters
  TextStyle? get effectiveTextStyle => textStyle ?? inputTextStyle;

  /// Returns the effective decoration, considering both the new and deprecated parameters
  InputDecoration? get effectiveDecoration => decoration ?? inputDecoration;

  /// Factory constructor for creating a glassmorphic input with blur effect
  ///
  /// Creates an input with a frosted glass effect that blurs the content behind it.
  ///
  /// - [colors]: Gradient colors for the background (defaults to blue/purple)
  /// - [borderRadius]: Border radius of the container (defaults to 20)
  /// - [blurStrength]: How strong the blur effect should be (0.5-2.0 recommended)
  /// - [backgroundOpacity]: Opacity of the background color overlay (0.0-1.0)
  /// - [backgroundColor]: Color of the background overlay
  /// - [borderColor]: Color of the border
  /// - [textColor]: Color of the input text
  /// - [hintColor]: Color of the hint text
  /// - [margin]: Margin around the input
  /// - [padding]: Padding inside the glassmorphic container
  /// - [materialElevation]: Elevation for the Material widget (shadow depth)
  /// - [materialColor]: Color for the Material widget
  /// - [materialPadding]: Padding for the Material widget
  /// - [materialShape]: Shape for the Material widget
  /// - [inputHeight]: Explicit height for the text input field
  /// - [inputContainerHeight]: Height for the entire input container
  /// - [inputContainerConstraints]: Constraints for more advanced size control
  /// - [inputContainerWidth]: How to size the container width
  /// - [positionedLeft]: Position from left in a Positioned widget
  /// - [positionedRight]: Position from right in a Positioned widget
  /// - [positionedBottom]: Position from bottom in a Positioned widget
  /// - [positionedTop]: Position from top in a Positioned widget
  /// - [useScaffoldBackground]: Whether to use the scaffold background color
  /// - [useOuterContainer]: Whether to use the outer Material container
  factory InputOptions.glassmorphic({
    List<Color>? colors,
    double borderRadius = 20.0,
    double blurStrength = 1.0,
    double backgroundOpacity = 0.1,
    Color backgroundColor = Colors.transparent,
    Color borderColor = Colors.white,
    Color textColor = Colors.white,
    Color hintColor = Colors.white,
    EdgeInsets? margin,
    EdgeInsets? padding,
    double? materialElevation,
    Color? materialColor,
    EdgeInsets? materialPadding,
    ShapeBorder? materialShape,
    double? positionedLeft,
    double? positionedRight,
    double? positionedBottom,
    double? positionedTop,
    bool useScaffoldBackground = false,
    bool useOuterContainer = true,
    double? inputHeight,
    double? inputContainerHeight,
    BoxConstraints? inputContainerConstraints,
    InputContainerWidth inputContainerWidth = InputContainerWidth.fullWidth,
    String hintText = 'Type a message...',
    Widget Function(VoidCallback onSend)? sendButtonBuilder,
    // Allow passing other standard options
    TextStyle? textStyle,
    bool sendOnEnter = false,
    bool alwaysShowSend = true,
    // Other parameters as needed
  }) {
    return InputOptions(
      textStyle: textStyle ??
          TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: textColor.withOpacity(0.9),
          ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: hintColor.withOpacity(0.7),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: textColor.withOpacity(0.5),
            width: 1,
          ),
        ),
        filled: true,
        fillColor: Colors.transparent,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 12,
        ),
      ),
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      materialElevation: materialElevation ?? 8.0,
      materialColor: materialColor ?? Colors.transparent,
      materialShape: materialShape,
      positionedLeft: positionedLeft,
      positionedRight: positionedRight,
      positionedBottom: positionedBottom,
      positionedTop: positionedTop,
      useScaffoldBackground: useScaffoldBackground,
      useOuterContainer: useOuterContainer,
      materialPadding:
          materialPadding ?? const EdgeInsets.symmetric(vertical: 8),
      inputHeight: inputHeight,
      inputContainerHeight: inputContainerHeight,
      inputContainerConstraints: inputContainerConstraints,
      inputContainerWidth: inputContainerWidth,
      containerDecoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors ??
              [
                Colors.blue.withOpacity(0.4),
                Colors.purple.withOpacity(0.4),
              ],
        ),
        borderRadius: BorderRadius.circular(borderRadius + 5),
        border: Border.all(
          color: borderColor.withOpacity(0.2),
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
      containerBackgroundColor: backgroundColor == Colors.transparent
          ? Colors.transparent
          : backgroundColor.withOpacity(backgroundOpacity),
      blurStrength: blurStrength,
      containerPadding:
          padding ?? const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      clipBehavior: true,
      sendButtonBuilder: sendButtonBuilder,
      sendOnEnter: sendOnEnter,
      alwaysShowSend: alwaysShowSend,
    );
  }

  /// Factory constructor for creating a minimal clean input design
  ///
  /// Creates a simple, clean input field without any outer containers or decorations.
  /// Ideal for developers who want to place the input within their own custom container.
  ///
  /// - [hintText]: Placeholder text for the input field
  /// - [textColor]: Color of the input text
  /// - [hintColor]: Color of the hint text
  /// - [backgroundColor]: Background color of the input field
  /// - [borderRadius]: Border radius of the text field
  /// - [sendButtonBuilder]: Custom builder for the send button
  factory InputOptions.minimal({
    String hintText = 'Type a message...',
    Color? textColor,
    Color? hintColor,
    Color? backgroundColor,
    double borderRadius = 20.0,
    EdgeInsets? contentPadding,
    Widget Function(VoidCallback onSend)? sendButtonBuilder,
    bool sendOnEnter = false,
    bool alwaysShowSend = true,
  }) {
    return InputOptions(
      textStyle: textColor != null ? TextStyle(color: textColor) : null,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: hintColor != null ? TextStyle(color: hintColor) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide.none,
        ),
        contentPadding: contentPadding ??
            const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        filled: true,
        fillColor: backgroundColor,
      ),
      useOuterContainer: false, // No outer container
      sendButtonBuilder: sendButtonBuilder,
      sendOnEnter: sendOnEnter,
      alwaysShowSend: alwaysShowSend,
    );
  }

  /// Factory constructor for complete custom control
  ///
  /// Creates an input field with minimal styling, giving complete control to the developer.
  /// Use this when you want to handle all styling aspects yourself.
  ///
  /// - [decoration]: Custom input decoration
  /// - [sendButtonBuilder]: Custom builder for the send button
  factory InputOptions.custom({
    InputDecoration? decoration,
    TextStyle? textStyle,
    Widget Function(VoidCallback onSend)? sendButtonBuilder,
    bool sendOnEnter = false,
    bool alwaysShowSend = true,
    // Other basic options
    EdgeInsets? margin,
    bool useOuterContainer = false,
  }) {
    return InputOptions(
      textStyle: textStyle,
      decoration: decoration,
      margin: margin,
      useOuterContainer: useOuterContainer,
      sendButtonBuilder: sendButtonBuilder,
      sendOnEnter: sendOnEnter,
      alwaysShowSend: alwaysShowSend,
    );
  }
}
