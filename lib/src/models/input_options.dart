import 'package:dash_chat_2/dash_chat_2.dart' as dash;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show TextInputFormatter;

/// Extended input options for the chat UI.
/// Provides additional customization options on top of the base DashChat InputOptions.
class InputOptions {
  const InputOptions({
    // Base options
    this.sendOnEnter = false,
    this.alwaysShowSend = true,
    this.autocorrect = true,

    // Style options
    this.inputTextStyle,
    this.inputDecoration,
    this.sendButtonBuilder,
    this.margin = const EdgeInsets.all(20),

    // Extended options
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
    this.toolbarOptions,
    this.smartDashesType,
    this.smartQuotesType,
    this.selectionControls,
    this.onTap,
    this.onEditingComplete,
    this.onSubmitted,
    this.onChanged,
    this.inputFormatters,
    this.mouseCursor,
    this.contextMenuBuilder,
    this.undoController,
    this.spellCheckConfiguration,
    this.magnifierConfiguration,
  });

  /// Whether to send the message when Enter is pressed.
  final bool sendOnEnter;

  /// Whether to always show the send button.
  final bool alwaysShowSend;

  /// Whether to enable autocorrect.
  final bool autocorrect;

  /// The style to use for the text being edited.
  final TextStyle? inputTextStyle;

  /// The decoration to show around the text field.
  final InputDecoration? inputDecoration;

  /// Builder for the send button.
  final Widget Function(VoidCallback onSend)? sendButtonBuilder;

  /// The margin around the input box.
  final EdgeInsets margin;

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

  /// Configuration of toolbar options.
  final ToolbarOptions? toolbarOptions;

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
  final EditableTextContextMenuBuilder? contextMenuBuilder;

  /// Controller for undo/redo operations.
  final UndoHistoryController? undoController;

  /// Configuration for spell check.
  final SpellCheckConfiguration? spellCheckConfiguration;

  /// Configuration for the magnifier.
  final TextMagnifierConfiguration? magnifierConfiguration;

  /// Creates a copy of this InputOptions with the given fields replaced with new values.
  InputOptions copyWith({
    bool? sendOnEnter,
    bool? alwaysShowSend,
    bool? autocorrect,
    TextStyle? inputTextStyle,
    InputDecoration? inputDecoration,
    Widget Function(VoidCallback)? sendButtonBuilder,
    EdgeInsets? margin,
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
    ToolbarOptions? toolbarOptions,
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
        sendOnEnter: sendOnEnter ?? this.sendOnEnter,
        alwaysShowSend: alwaysShowSend ?? this.alwaysShowSend,
        autocorrect: autocorrect ?? this.autocorrect,
        inputTextStyle: inputTextStyle ?? this.inputTextStyle,
        inputDecoration: inputDecoration ?? this.inputDecoration,
        sendButtonBuilder: sendButtonBuilder ?? this.sendButtonBuilder,
        margin: margin ?? this.margin,
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
        toolbarOptions: toolbarOptions ?? this.toolbarOptions,
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
}
