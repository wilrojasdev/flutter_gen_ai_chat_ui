import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
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
  bool _isDarkMode = true;
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
      // Simulate streaming response
      final responseText =
          "I'm demonstrating custom styling capabilities! Your message was: '${message.text}'\n\nNotice how the chat bubbles, colors, and overall theme adapt to dark/light mode. The animations are smooth, and the interface is responsive.";

      // Create initial empty message
      final response = ChatMessage(
        text: "",
        user: _aiUser,
        createdAt: DateTime.now(),
      );
      _controller.addMessage(response);

      // Stream the response word by word
      final words = responseText.split(' ');
      String currentText = '';

      for (var word in words) {
        await Future.delayed(const Duration(milliseconds: 50));
        currentText += (currentText.isEmpty ? '' : ' ') + word;
        _controller.messages.removeWhere((m) =>
            m.createdAt == response.createdAt && m.user.id == _aiUser.id);
        _controller.addMessage(ChatMessage(
          text: currentText,
          user: _aiUser,
          createdAt: response.createdAt,
        ));
      }
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
          chatBackground:
              _isDarkMode ? const Color(0xFF171717) : Colors.grey[50]!,
          messageBubbleColor:
              _isDarkMode ? const Color(0xFF262626) : Colors.white,
          userBubbleColor:
              _isDarkMode ? const Color(0xFF1A4B8F) : const Color(0xFFE3F2FD),
          messageTextColor:
              _isDarkMode ? const Color(0xFFE5E5E5) : Colors.grey[800]!,
          inputBackgroundColor:
              _isDarkMode ? const Color(0xFF262626) : Colors.white,
          inputBorderColor:
              _isDarkMode ? const Color(0xFF404040) : Colors.grey[300]!,
          inputTextColor: _isDarkMode ? Colors.white : Colors.grey[800]!,
          hintTextColor:
              _isDarkMode ? const Color(0xFF9CA3AF) : Colors.grey[600]!,
          backToBottomButtonColor:
              _isDarkMode ? const Color(0xFF60A5FA) : Colors.blue,
          sendButtonColor: Colors.transparent,
          sendButtonIconColor:
              _isDarkMode ? const Color(0xFF60A5FA) : Colors.blue,
        ),
      ],
    );

    return Theme(
      data: _isDarkMode
          ? ThemeData.dark(useMaterial3: true).copyWith(
              scaffoldBackgroundColor: const Color(0xFF171717),
              appBarTheme: const AppBarTheme(
                backgroundColor: Color(0xFF171717),
              ),
            )
          : ThemeData.light(useMaterial3: true),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Custom Styling Example',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: _isDarkMode ? const Color(0xFFE5E5E5) : Colors.grey[800],
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                _isDarkMode ? Icons.light_mode : Icons.dark_mode,
                color: _isDarkMode ? const Color(0xFF60A5FA) : Colors.grey[700],
              ),
              onPressed: () => setState(() => _isDarkMode = !_isDarkMode),
            ),
          ],
        ),
        body: Theme(
          data: theme,
          child: AiChatWidget(
            config: AiChatConfig(
              hintText: 'Send a message...',
              enableAnimation: true,
              showTimestamp: true,
              messageOptions: MessageOptions(
                containerColor:
                    _isDarkMode ? const Color(0xFF262626) : Colors.white,
                currentUserContainerColor: _isDarkMode
                    ? const Color(0xFF1A4B8F)
                    : const Color(0xFFE3F2FD),
                textColor:
                    _isDarkMode ? const Color(0xFFE5E5E5) : Colors.grey[800]!,
                currentUserTextColor:
                    _isDarkMode ? const Color(0xFFE5E5E5) : Colors.grey[800]!,
                messagePadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                showCurrentUserAvatar: false,
                showOtherUsersAvatar: true,
                showTime: true,
                timeTextColor:
                    _isDarkMode ? const Color(0xFF9CA3AF) : Colors.grey[600]!,
                currentUserTimeTextColor:
                    _isDarkMode ? const Color(0xFF9CA3AF) : Colors.grey[600]!,
              ),
              inputDecoration: InputDecoration(
                hintText: 'Type your message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(
                    color: _isDarkMode
                        ? const Color(0xFF404040)
                        : Colors.grey[300]!,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(
                    color: _isDarkMode
                        ? const Color(0xFF404040)
                        : Colors.grey[300]!,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(
                    color: _isDarkMode ? const Color(0xFF60A5FA) : Colors.blue,
                    width: 2,
                  ),
                ),
                filled: true,
                fillColor: _isDarkMode ? const Color(0xFF262626) : Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
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
                    color: _isDarkMode ? const Color(0xFF60A5FA) : Colors.blue,
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
