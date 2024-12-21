import 'package:flutter/material.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class DetailedExample extends StatefulWidget {
  const DetailedExample({super.key});

  @override
  State<DetailedExample> createState() => _DetailedExampleState();
}

class _DetailedExampleState extends State<DetailedExample> {
  late final ChatMessagesController messagesController;
  late final List<ChatExample> exampleQuestions;
  late final ChatUser _currentUser;
  late final ChatUser _aiUser;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _currentUser = ChatUser(id: '1', firstName: 'User');
    _aiUser = ChatUser(id: '2', firstName: 'AI Assistant');

    final initialMessages = [
      ChatMessage(
        text:
            "Hello! I'm your AI assistant. I can help you with various tasks and answer your questions.",
        user: _aiUser,
        createdAt: DateTime.now().subtract(const Duration(minutes: 1)),
      ),
    ];

    messagesController = ChatMessagesController(
      initialMessages: initialMessages,
      onLoadMoreMessages: _loadMoreMessages,
    );
    exampleQuestions = _createExampleQuestions();
  }

  Future<List<ChatMessage>> _loadMoreMessages(ChatMessage? lastMessage) async {
    setState(() => _isLoading = true);
    try {
      await Future.delayed(const Duration(seconds: 1));
      return List.generate(10, (index) {
        final isUser = index.isEven;
        final daysAgo = index ~/ 2 + 1;
        return ChatMessage(
          text: isUser
              ? "This is a historical user message from $daysAgo days ago."
              : "This is a historical AI response with detailed information and formatting examples.",
          user: isUser ? _currentUser : _aiUser,
          createdAt: DateTime.now().subtract(Duration(days: daysAgo)),
        );
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleSendMessage(ChatMessage message) async {
    setState(() => _isLoading = true);
    // Add user message with current timestamp
    final userMessage = ChatMessage(
      text: message.text,
      user: _currentUser,
      createdAt: DateTime.now(),
    );
    messagesController.addMessage(userMessage);

    try {
      // Simulate AI thinking time
      await Future.delayed(const Duration(seconds: 2));

      final response = ChatMessage(
        text: """Thank you for your message. Let me help you with that.

${message.text}

I'm demonstrating different formatting capabilities:
• Bullet points for organization
• Support for multiple paragraphs
• Code examples when needed

Would you like to know more about any specific aspect?""",
        user: _aiUser,
        createdAt: DateTime.now(),
      );
      messagesController.addMessage(response);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  List<ChatExample> _createExampleQuestions() {
    return [
      ChatExample(
        question: 'What features can you demonstrate?',
        onTap: (controller) {
          final message = ChatMessage(
            text:
                'Can you show me the different features and capabilities of this chat interface?',
            user: _currentUser,
            createdAt: DateTime.now(),
          );
          _handleSendMessage(message);
        },
      ),
      ChatExample(
        question: 'Show formatting examples',
        onTap: (controller) {
          final message = ChatMessage(
            text:
                'Can you demonstrate different text formatting and layout options?',
            user: _currentUser,
            createdAt: DateTime.now(),
          );
          _handleSendMessage(message);
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          final isDarkMode = themeProvider.isDark;
          final size = MediaQuery.of(context).size;
          final isTablet = size.width > 600;
          final isDesktop = size.width > 1200;

          final theme = Theme.of(context);
          final customTheme = theme.extension<CustomThemeExtension>();

          // Define colors based on theme
          final aiMessageColor = isDarkMode
              ? const Color(0xFF2C2C2E) // Dark gray in dark mode
              : const Color(0xFFE8F1FF); // Light blue in light mode
          final userMessageColor = isDarkMode
              ? theme.colorScheme.primary.withOpacity(0.3)
              : theme.colorScheme.primary.withOpacity(0.1);
          final textColor = isDarkMode
              ? Colors.white.withOpacity(0.95)
              : Colors.black.withOpacity(0.95);
          final secondaryTextColor =
              isDarkMode ? Colors.white70 : Colors.black87;

          return Theme(
            data: themeProvider.theme,
            child: Scaffold(
              appBar: AppBar(
                title: Text(
                  'AI Assistant',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                elevation: 0,
                scrolledUnderElevation: 1,
                surfaceTintColor: Colors.transparent,
                backgroundColor:
                    isDarkMode ? const Color(0xFF1C1C1E) : Colors.white,
                actions: [
                  IconButton(
                    icon: Icon(
                      isDarkMode ? Icons.light_mode : Icons.dark_mode,
                      color: secondaryTextColor,
                    ),
                    onPressed: () => themeProvider.toggleTheme(),
                    tooltip: isDarkMode ? 'Light mode' : 'Dark mode',
                  ),
                ],
              ),
              body: Center(
                child: AiChatWidget(
                  config: AiChatConfig(
                    userName: 'User',
                    aiName: 'AI Assistant',
                    maxWidth: isDesktop ? 900 : (isTablet ? 700 : null),
                    enableAnimation: true,
                    showTimestamp: true,
                    exampleQuestions: exampleQuestions,
                    enablePagination: true,
                    paginationLoadingIndicatorOffset: 100,
                    inputOptions: InputOptions(
                      sendOnEnter: true,
                      alwaysShowSend: true,
                      inputTextStyle: GoogleFonts.inter(
                        fontSize: 16,
                        color: textColor,
                      ),
                      sendButtonBuilder: (onSend) => IconButton(
                        icon: Icon(
                          Icons.send_rounded,
                          color: theme.colorScheme.primary,
                          size: 24,
                        ),
                        onPressed: onSend,
                      ),
                      inputDecoration: InputDecoration(
                        hintText: 'Type your message...',
                        hintStyle: TextStyle(
                          color: secondaryTextColor.withOpacity(0.7),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: isDarkMode
                                ? Colors.grey[800]!
                                : Colors.grey[300]!,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: isDarkMode
                                ? Colors.grey[800]!
                                : Colors.grey[300]!,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: theme.colorScheme.primary,
                            width: 2,
                          ),
                        ),
                        filled: isDarkMode,
                        fillColor: isDarkMode ? const Color(0xFF2C2C2E) : null,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                    messageOptions: MessageOptions(
                      showTime: true,
                      containerColor: aiMessageColor,
                      currentUserContainerColor: userMessageColor,
                      textColor: textColor,
                      currentUserTextColor: textColor,
                      showCurrentUserAvatar: false,
                      showOtherUsersAvatar: true,
                      spaceWhenAvatarIsHidden: 16,
                      marginDifferentAuthor: const EdgeInsets.only(top: 16),
                      marginSameAuthor: const EdgeInsets.only(top: 8),
                      messagePadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      borderRadius: 20,
                      avatarBuilder: (user, _, __) => Padding(
                        padding: const EdgeInsets.only(right: 5, left: 5),
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: user.id == _currentUser.id
                              ? theme.colorScheme.primary
                              : isDarkMode
                                  ? const Color(0xFF4A4A4C)
                                  : theme.colorScheme.secondary,
                          child: Text(
                            user.firstName?[0] ?? '',
                            style: TextStyle(
                              fontSize: 14,
                              color: user.id == _currentUser.id || !isDarkMode
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ),
                      ),
                      timeFormat: DateFormat('HH:mm'),
                    ),
                  ),
                  currentUser: _currentUser,
                  aiUser: _aiUser,
                  controller: messagesController,
                  onSendMessage: _handleSendMessage,
                  isLoading: _isLoading,
                  loadingIndicator: const LoadingWidget(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    messagesController.dispose();
    super.dispose();
  }
}
