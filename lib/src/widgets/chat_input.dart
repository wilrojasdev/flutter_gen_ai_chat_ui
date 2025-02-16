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
    return Padding(
      padding: options.margin,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              style: options.inputTextStyle,
              decoration: options.inputDecoration,
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
              enableIMEPersonalizedLearning:
                  options.enableIMEPersonalizedLearning,
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
            ),
          ),
          if (options.sendButtonBuilder != null)
            options.sendButtonBuilder!(onSend),
        ],
      ),
    );
  }
}
