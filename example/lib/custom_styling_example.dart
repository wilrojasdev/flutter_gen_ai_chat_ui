import 'package:flutter/material.dart';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';

class CustomStylingExample extends StatefulWidget {
  const CustomStylingExample({super.key});

  @override
  State<CustomStylingExample> createState() => _CustomStylingExampleState();
}

class _CustomStylingExampleState extends State<CustomStylingExample> {
  late final ChatMessagesController _controller;
  late final ChatUser _currentUser;
  late final ChatUser _aiUser;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _currentUser = ChatUser(id: "user1", firstName: "User");
    _aiUser = ChatUser(id: "ai", firstName: "AI Assistant");
    _controller = ChatMessagesController();

    // Add initial welcome message
    _controller.addMessage(ChatMessage(
      text:
          "Hi! I'm your AI assistant. I can help you with various tasks and answer your questions. Try the dark mode toggle in the top right!",
      user: _aiUser,
      createdAt: DateTime.now(),
    ));
  }

  Future<void> _handleSendMessage(ChatMessage message) async {
    setState(() => _isLoading = true);
    _controller.addMessage(message);

    try {
      // Simulate AI response delay
      await Future.delayed(const Duration(seconds: 1));

      // Example responses based on user's message
      String response = '';
      if (message.text.toLowerCase().contains('hello') ||
          message.text.toLowerCase().contains('hi')) {
        response = "Hello! How can I help you today?";
      } else if (message.text.toLowerCase().contains('style') ||
          message.text.toLowerCase().contains('theme')) {
        response =
            "The chat interface is styled to match ChatGPT's design, with support for both light and dark modes. The light mode uses ChatGPT's signature green color (#10A37F) and clean, minimal design.";
      } else if (message.text.toLowerCase().contains('dark mode') ||
          message.text.toLowerCase().contains('light mode')) {
        response =
            "The theme automatically adapts to your system's dark/light mode preference. In dark mode, it uses your app's theme colors, while in light mode it uses ChatGPT's signature styling.";
      } else {
        response =
            "I understand you're asking about '${message.text}'. This is an example response to demonstrate the chat interface styling. Feel free to ask about the styling, themes, or try different messages!";
      }

      final aiMessage = ChatMessage(
        text: response,
        user: _aiUser,
        createdAt: DateTime.now(),
      );
      _controller.addMessage(aiMessage);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(
      extensions: [
        CustomThemeExtension(
          chatBackground: Theme.of(context).scaffoldBackgroundColor,
          messageBubbleColor: Theme.of(context).brightness == Brightness.dark
              ? Theme.of(context).colorScheme.surface
              : const Color(0xFFF7F7F8),
          userBubbleColor: Theme.of(context).brightness == Brightness.dark
              ? Theme.of(context).colorScheme.primary
              : const Color(0xFF10A37F),
          messageTextColor: Theme.of(context).brightness == Brightness.dark
              ? Theme.of(context).colorScheme.onSurface
              : const Color(0xFF353740),
          inputBackgroundColor: Theme.of(context).brightness == Brightness.dark
              ? Theme.of(context).colorScheme.surface
              : Colors.white,
          inputBorderColor: Theme.of(context).brightness == Brightness.dark
              ? Theme.of(context).colorScheme.outline
              : const Color(0xFFD9D9E3),
          inputTextColor: Theme.of(context).brightness == Brightness.dark
              ? Theme.of(context).colorScheme.onSurface
              : const Color(0xFF353740),
          hintTextColor: const Color(0xFF8E8EA0),
          backToBottomButtonColor:
              Theme.of(context).brightness == Brightness.dark
                  ? Theme.of(context).colorScheme.primary
                  : const Color(0xFF10A37F),
          sendButtonColor: Colors.transparent,
          sendButtonIconColor: Theme.of(context).brightness == Brightness.dark
              ? Theme.of(context).colorScheme.primary
              : const Color(0xFF10A37F),
        ),
      ],
    );

    return Theme(
      data: Theme.of(context),
      child: Scaffold(
        body: Theme(
          data: theme,
          child: AiChatWidget(
            config: AiChatConfig(
              hintText: 'Send a message',
              enableAnimation: true,
              showTimestamp: true,
              messageOptions: MessageOptions(
                containerColor: Theme.of(context).brightness == Brightness.dark
                    ? Theme.of(context).colorScheme.surface
                    : const Color(0xFFF7F7F8),
                currentUserContainerColor:
                    Theme.of(context).brightness == Brightness.dark
                        ? Theme.of(context).colorScheme.primary
                        : const Color(0xFF10A37F),
                textColor: Theme.of(context).brightness == Brightness.dark
                    ? Theme.of(context).colorScheme.onSurface
                    : const Color(0xFF353740),
                currentUserTextColor: Colors.white,
                messagePadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                showCurrentUserAvatar: false,
                showOtherUsersAvatar: true,
                showTime: true,
                timeTextColor: const Color(0xFF8E8EA0),
                currentUserTimeTextColor: const Color(0xFF8E8EA0),
                borderRadius: 12,
              ),
              inputDecoration: InputDecoration(
                hintText: 'Send a message',
                hintStyle: const TextStyle(
                  color: Color(0xFF8E8EA0),
                ),
                filled: true,
                fillColor: Theme.of(context).brightness == Brightness.dark
                    ? Theme.of(context).colorScheme.surface
                    : Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Theme.of(context).colorScheme.outline
                        : const Color(0xFFD9D9E3),
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Theme.of(context).colorScheme.outline
                        : const Color(0xFFD9D9E3),
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Theme.of(context).colorScheme.primary
                        : const Color(0xFF10A37F),
                    width: 1.5,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              sendButtonIcon: Icons.send_rounded,
              sendButtonIconSize: 24,
              sendButtonPadding: const EdgeInsets.all(8),
              sendButtonBuilder: (onSend) => Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.send_rounded,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Theme.of(context).colorScheme.primary
                        : const Color(0xFF10A37F),
                    size: 24,
                  ),
                  onPressed: onSend,
                ),
              ),
              exampleQuestions: [
                ChatExample(
                  question: 'How does the styling work?',
                  onTap: (controller) {
                    controller.handleExampleQuestion(
                      'How does the styling work?',
                      _currentUser,
                      _aiUser,
                    );
                  },
                ),
                ChatExample(
                  question: 'Show me dark mode features',
                  onTap: (controller) {
                    controller.handleExampleQuestion(
                      'Show me dark mode features',
                      _currentUser,
                      _aiUser,
                    );
                  },
                ),
              ],
            ),
            controller: _controller,
            currentUser: _currentUser,
            aiUser: _aiUser,
            onSendMessage: _handleSendMessage,
            isLoading: _isLoading,
            loadingIndicator: LoadingWidget(
              texts: const ['Loading...', 'Please wait...', 'Almost there...'],
              interval: const Duration(seconds: 2),
              textStyle: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
