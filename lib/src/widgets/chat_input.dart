import 'dart:ui';

import 'package:flutter/material.dart';

import '../models/input_options.dart';

/// A custom chat input widget that supports extensive customization options.
class ChatInput extends StatelessWidget {
  const ChatInput({
    super.key,
    required this.controller,
    required this.onSend,
    required this.options,
    this.focusNode,
  });

  /// The text editing controller.
  final TextEditingController controller;

  /// Callback when the send button is pressed.
  final VoidCallback onSend;

  /// The input options for customization.
  final InputOptions options;

  /// Optional focus node for the text field.
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    // Always use the app's text direction from context for consistency
    final appDirection = Directionality.of(context);

    // Basic content of the input area - the TextField and send button
    Widget textField = TextField(
      controller: controller,
      focusNode: focusNode,
      style: options.textStyle,
      // Always use the app's text direction for the TextField
      textDirection: appDirection,
      decoration: options.decoration,
      textCapitalization: options.textCapitalization,
      maxLines: options.maxLines,
      minLines: options.minLines,
      textInputAction: options.textInputAction,
      keyboardType: options.keyboardType,
      cursorColor: options.cursorColor,
      cursorHeight: options.cursorHeight,
      cursorWidth: options.cursorWidth,
      cursorRadius: options.cursorRadius,
      showCursor: options.showCursor,
      enableSuggestions: options.enableSuggestions,
      enableIMEPersonalizedLearning: options.enableIMEPersonalizedLearning,
      readOnly: options.readOnly,
      smartDashesType: options.smartDashesType,
      smartQuotesType: options.smartQuotesType,
      selectionControls: options.selectionControls,
      onTap: options.onTap,
      onEditingComplete: options.onEditingComplete,
      onSubmitted: options.onSubmitted,
      onChanged: options.onChanged,
      inputFormatters: options.inputFormatters,
      mouseCursor: options.mouseCursor,
      contextMenuBuilder: options.contextMenuBuilder,
      undoController: options.undoController,
      spellCheckConfiguration: options.spellCheckConfiguration,
      magnifierConfiguration: options.magnifierConfiguration,
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
    );

    // Apply custom height to text field if specified
    if (options.inputHeight != null) {
      textField = SizedBox(
        height: options.inputHeight,
        child: textField,
      );
    }

    // Create input content with text field and send button
    Widget inputContent;
    if (options.alwaysShowSend ||
        (controller.text.isNotEmpty && !options.alwaysShowSend)) {
      // Show text field with send button
      inputContent = Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        // Use app direction consistently
        textDirection: appDirection,
        children: [
          Flexible(
            child: textField,
          ),
          options.effectiveSendButtonBuilder(onSend),
        ],
      );
    } else {
      // Show only text field
      inputContent = textField;
    }

    // Calculate appropriate background color based on settings
    final effectiveBackgroundColor = options.useScaffoldBackground
        ? Theme.of(context).scaffoldBackgroundColor
        : options.containerBackgroundColor;

    // Prepare constraints for the input container
    final constraints = options.inputContainerConstraints ??
        BoxConstraints(
          minHeight: options.inputContainerHeight ?? 0,
          maxHeight: options.inputContainerHeight ?? double.infinity,
        );

    // Render with container decoration if specified
    if (options.containerDecoration != null) {
      // For glassmorphic effect (with backdrop filter)
      if (options.clipBehavior &&
          options.containerDecoration?.borderRadius != null) {
        final borderRadius =
            options.containerDecoration?.borderRadius as BorderRadius?;

        return ClipRRect(
          borderRadius: borderRadius ?? BorderRadius.zero,
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: options.blurStrength * 10,
              sigmaY: options.blurStrength * 10,
            ),
            child: Container(
              constraints: constraints,
              width: _getContainerWidth(options, context),
              padding: options.containerPadding,
              decoration: options.containerDecoration?.copyWith(
                color: effectiveBackgroundColor,
              ),
              child: Padding(
                // Use app direction consistently for margin resolution
                padding:
                    options.margin?.resolve(appDirection) ?? EdgeInsets.zero,
                child: inputContent,
              ),
            ),
          ),
        );
      }

      // Regular container decoration without backdrop filter
      return Container(
        constraints: constraints,
        width: _getContainerWidth(options, context),
        padding: options.containerPadding,
        decoration: options.containerDecoration,
        child: Padding(
          // Use app direction consistently for margin resolution
          padding: options.margin?.resolve(appDirection) ?? EdgeInsets.zero,
          child: inputContent,
        ),
      );
    }

    // Default rendering without container customization
    Widget result = Padding(
      // Use app direction consistently for margin resolution
      padding: options.margin?.resolve(appDirection) ?? EdgeInsets.zero,
      child: inputContent,
    );

    // Apply constraints if needed when no container decoration is used
    if (options.inputContainerHeight != null ||
        options.inputContainerConstraints != null) {
      result = Container(
        constraints: constraints,
        width: _getContainerWidth(options, context),
        child: result,
      );
    }

    // Optional Material styling
    return Material(
      color: options.materialColor,
      elevation: options.materialElevation,
      shape: options.materialShape,
      shadowColor: Colors.black45,
      child: Padding(
        padding: options.materialPadding,
        child: result,
      ),
    );
  }

  // Helper to get appropriate container width based on settings
  double? _getContainerWidth(InputOptions options, BuildContext context) {
    switch (options.inputContainerWidth) {
      case InputContainerWidth.fullWidth:
        return double.infinity;
      case InputContainerWidth.wrapContent:
        return null;
      case InputContainerWidth.custom:
        return options.inputContainerConstraints?.maxWidth;
      default:
        return double.infinity;
    }
  }
}
