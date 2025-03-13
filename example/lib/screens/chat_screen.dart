import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';

import '../models/app_state.dart';
import '../services/mock_ai_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  static void clearMessages(BuildContext context) {
    final state = context.findAncestorStateOfType<_ChatScreenState>();
    state?._chatController.clearMessages();
  }

  static void toggleWelcomeMessage(BuildContext context) {
    final state = context.findAncestorStateOfType<_ChatScreenState>();
    state?._toggleWelcomeMessage();
  }

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
  final _chatController = ChatMessagesController();
  final _mockAiService = MockAiService();
  bool _isLoading = false;
  late AnimationController _fadeController;
  bool _welcomeMessageVisible = false; // Track welcome message visibility

  /// Current user for the chat
  final _currentUser = const ChatUser(
    id: 'user1',
    firstName: 'User',
  );

  /// AI assistant user
  final _aiUser = const ChatUser(
    id: 'ai1',
    firstName: 'AI Assistant',
  );

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeController.forward();

    // Add the initial welcome message to the chat
    _addWelcomeMessage();

    // Explicitly hide the welcome container UI
    _chatController.hideWelcomeMessage();
    _welcomeMessageVisible = false;
  }

  @override
  void dispose() {
    _chatController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  // Add an initial welcome message from the AI
  void _addWelcomeMessage() {
    final welcomeMessage = ChatMessage(
      text:
          'Welcome! I\'m an AI assistant to showcase the Flutter Gen AI Chat UI package. Try asking me about:\n\n- Markdown formatting\n- Code examples\n- Features of this UI',
      user: _aiUser,
      createdAt: DateTime.now(),
      isMarkdown: true,
    );

    _chatController.addMessage(welcomeMessage);
  }

  // Handle sending a message
  Future<void> _handleSendMessage(ChatMessage message) async {
    // Add user message to chat
    _chatController.addMessage(message);

    // Hide welcome message after first message
    if (_chatController.showWelcomeMessage) {
      _chatController.hideWelcomeMessage();
    }

    // Set loading state
    setState(() {
      _isLoading = true;
    });

    final appState = Provider.of<AppState>(context, listen: false);

    try {
      // Create an initial placeholder message that will be updated
      final aiMessage = ChatMessage(
        text: '',
        user: _aiUser,
        createdAt: DateTime.now(),
        isMarkdown: true,
        isSending: true,
      );

      // Add the initial empty message
      _chatController.addMessage(aiMessage);

      if (appState.isStreaming) {
        // Stream the response and update the message
        await _handleStreamingResponse(message.text, aiMessage);
      } else {
        // Get a full response and update the message
        await _handleStandardResponse(message.text, aiMessage);
      }
    } catch (e) {
      // Create an error message
      final errorMessage = ChatMessage(
        text: 'Sorry, there was an error generating a response.',
        user: _aiUser,
        createdAt: DateTime.now(),
        hasError: true,
        errorMessage: e.toString(),
      );
      _chatController.addMessage(errorMessage);
    } finally {
      // Clear loading state
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Handle a streaming response by updating the message as words come in
  Future<void> _handleStreamingResponse(
      String input, ChatMessage initialMessage) async {
    final appState = Provider.of<AppState>(context, listen: false);

    // Start streaming the response
    final stream = _mockAiService.streamResponse(
      input,
      includeCodeBlock: appState.showCodeBlocks,
    );

    await for (final text in stream) {
      // Update the message with the current accumulated text
      final updatedMessage = initialMessage.copyWith(
        text: text,
        isSending: false,
      );

      _chatController.updateMessage(updatedMessage);
    }
  }

  // Handle a standard response by getting the full text at once
  Future<void> _handleStandardResponse(
      String input, ChatMessage initialMessage) async {
    final appState = Provider.of<AppState>(context, listen: false);

    // Get the full response text
    final responseText = await _mockAiService.getResponse(
      input,
      includeCodeBlock: appState.showCodeBlocks,
    );

    // Update the message with the complete response
    final updatedMessage = initialMessage.copyWith(
      text: responseText,
      isSending: false,
    );

    _chatController.updateMessage(updatedMessage);
  }

  BoxDecoration _getMessageContainerDecoration(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return BoxDecoration(
      borderRadius: BorderRadius.circular(24),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: isDarkMode
            ? [
                const Color(0xFF1E1E1E).withOpacity(0.95),
                const Color(0xFF252525).withOpacity(0.95),
              ]
            : [
                Colors.white.withOpacity(0.95),
                const Color(0xFFF8F9FA).withOpacity(0.95),
              ],
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(isDarkMode ? 0.25 : 0.1),
          blurRadius: 20,
          offset: const Offset(0, 8),
          spreadRadius: -5,
        ),
      ],
      border: Border.all(
        color: isDarkMode
            ? Colors.white.withOpacity(0.1)
            : Colors.black.withOpacity(0.05),
        width: 0.5,
      ),
    );
  }

  // Creates a stylized code block decoration based on the current theme
  BoxDecoration _getCodeBlockDecoration(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: isDarkMode ? const Color(0xFF0D1117) : const Color(0xFFF6F8FA),
      border: Border.all(
        color: isDarkMode ? const Color(0xFF30363D) : const Color(0xFFE1E4E8),
        width: 1,
      ),
    );
  }

  // Creates a gradient background for user messages
  BoxDecoration _getUserMessageDecoration(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: isDarkMode
            ? [
                colorScheme.primary.withOpacity(0.2),
                colorScheme.primary.withOpacity(0.1),
              ]
            : [
                colorScheme.primary.withOpacity(0.15),
                colorScheme.primary.withOpacity(0.05),
              ],
      ),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: colorScheme.primary.withOpacity(isDarkMode ? 0.3 : 0.2),
        width: 1,
      ),
    );
  }

  // Creates a gradient background for AI messages
  BoxDecoration _getAiMessageDecoration(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: isDarkMode
            ? [
                const Color(0xFF252525).withOpacity(0.9),
                const Color(0xFF1E1E1E).withOpacity(0.9),
              ]
            : [
                Colors.white,
                const Color(0xFFF8F9FA),
              ],
      ),
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(isDarkMode ? 0.2 : 0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
          spreadRadius: -2,
        ),
      ],
      border: Border.all(
        color: isDarkMode
            ? Colors.white.withOpacity(0.1)
            : Colors.black.withOpacity(0.05),
        width: 0.5,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return FadeTransition(
      opacity: _fadeController,
      child: Stack(
        children: [
          // Gradient background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDarkMode
                    ? [
                        colorScheme.surface,
                        const Color(0xFF0A1929),
                      ]
                    : [
                        colorScheme.primary.withOpacity(0.05),
                        colorScheme.secondary.withOpacity(0.1),
                      ],
              ),
            ),
          ),

          // Pattern overlay for visual interest
          Opacity(
            opacity: 0.03,
            child: Image.network(
              'https://transparenttextures.com/patterns/cubes.png',
              repeat: ImageRepeat.repeat,
              width: double.infinity,
              height: double.infinity,
            ),
          ),

          // Main chat UI
          SafeArea(
            child: AiChatWidget(
              config: AiChatConfig(
                aiName: 'AI',
                hintText: 'Type a message...',
                enableAnimation: appState.enableAnimation,
                maxWidth: 800, // Constrain width on larger screens
                padding: const EdgeInsets.all(8),
                exampleQuestions: [
                  ExampleQuestion(
                    question: 'What features does this UI have?',
                    config: ExampleQuestionConfig(
                      containerDecoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            colorScheme.primary.withOpacity(0.1),
                            colorScheme.primary.withOpacity(0.2),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: colorScheme.primary.withOpacity(0.3),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.primary.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      textStyle: TextStyle(
                        color: isDarkMode ? Colors.white : colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                      iconColor: colorScheme.primary,
                      iconData: Icons.auto_awesome_outlined,
                      trailingIconColor: colorScheme.primary,
                      containerPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                  ExampleQuestion(
                    question: 'Show me some markdown examples',
                    config: ExampleQuestionConfig(
                      containerDecoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            colorScheme.secondary.withOpacity(0.1),
                            colorScheme.secondary.withOpacity(0.2),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: colorScheme.secondary.withOpacity(0.3),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.secondary.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      textStyle: TextStyle(
                        color:
                            isDarkMode ? Colors.white : colorScheme.secondary,
                        fontWeight: FontWeight.w500,
                      ),
                      iconColor: colorScheme.secondary,
                      iconData: Icons.format_quote_outlined,
                      trailingIconColor: colorScheme.secondary,
                      containerPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                  ExampleQuestion(
                    question: 'Can you show me a code example?',
                    config: ExampleQuestionConfig(
                      containerDecoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            colorScheme.tertiary.withOpacity(0.1),
                            colorScheme.tertiary.withOpacity(0.2),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: colorScheme.tertiary.withOpacity(0.3),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.tertiary.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      textStyle: TextStyle(
                        color: isDarkMode ? Colors.white : colorScheme.tertiary,
                        fontWeight: FontWeight.w500,
                      ),
                      iconColor: colorScheme.tertiary,
                      iconData: Icons.code_outlined,
                      trailingIconColor: colorScheme.tertiary,
                      containerPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
                persistentExampleQuestions: _welcomeMessageVisible,

                // ===== Welcome Message Configuration =====
                // To disable the welcome message container entirely:
                // 1. Set welcomeMessageConfig to null, OR
                // 2. In initState, call _chatController.hideWelcomeMessage()
                //
                // To disable only the outer container but keep welcome text as a message:
                // 1. Set containerDecoration to null, OR
                // 2. Create a minimal decoration without shadows and borders
                //
                // To customize the appearance:
                // - Modify containerDecoration to change the container style
                // - Adjust containerPadding and containerMargin for spacing
                // - Set custom title and titleStyle for the welcome text
                welcomeMessageConfig: _welcomeMessageVisible
                    ? WelcomeMessageConfig(
                        title: 'Welcome to the Flutter Gen AI Chat UI Demo',
                        titleStyle: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isDarkMode
                                  ? Colors.white
                                  : colorScheme.primary,
                            ),
                        containerDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: isDarkMode
                                ? [
                                    const Color(0xFF1E1E1E).withOpacity(0.95),
                                    const Color(0xFF252525).withOpacity(0.95),
                                  ]
                                : [
                                    Colors.white.withOpacity(0.95),
                                    const Color(0xFFF8F9FA).withOpacity(0.95),
                                  ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black
                                  .withOpacity(isDarkMode ? 0.25 : 0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                              spreadRadius: -5,
                            ),
                          ],
                          border: Border.all(
                            color: isDarkMode
                                ? Colors.white.withOpacity(0.1)
                                : Colors.black.withOpacity(0.05),
                            width: 0.5,
                          ),
                        ),
                        containerPadding: const EdgeInsets.all(24),
                        containerMargin: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 16),
                      )
                    : null, // Set to null to disable welcome container completely

                // Input configuration
                inputOptions: InputOptions(
                  sendOnEnter: true,
                  alwaysShowSend: true,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                  useOuterContainer: false,
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    hintStyle: TextStyle(
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      fontWeight: FontWeight.normal,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide(
                        color:
                            isDarkMode ? Colors.grey[850]! : Colors.grey[300]!,
                        width: 1,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide(
                        color:
                            isDarkMode ? Colors.grey[850]! : Colors.grey[300]!,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide(
                        color: colorScheme.primary.withOpacity(0.6),
                        width: 1.5,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    filled: true,
                    fillColor: isDarkMode
                        ? const Color(
                            0xFF0F0F0F) // Darker background in dark mode
                        : Colors.white,
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 12, right: 8),
                      child: Icon(
                        Icons.chat_bubble_outline_rounded,
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                        size: 20,
                      ),
                    ),
                    isDense: true,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                  ),
                  containerBackgroundColor: Colors.transparent,
                  sendButtonBuilder: (onSend) => Container(
                    margin: const EdgeInsets.only(left: 8, right: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          colorScheme.primary,
                          colorScheme.primary.withBlue(
                              (colorScheme.primary.blue + 40).clamp(0, 255)),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.primary.withOpacity(0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                          spreadRadius: -2,
                        ),
                      ],
                    ),
                    child: IconButton(
                      onPressed: onSend,
                      icon: const Icon(Icons.send_rounded, color: Colors.white),
                      padding: const EdgeInsets.all(12),
                      iconSize: 22,
                    ),
                  ),
                ),

                // Message options
                messageOptions: MessageOptions(
                  showTime: true,
                  showUserName: true,
                  userNameStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                    fontSize: 13,
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  bubbleStyle: BubbleStyle(
                    userBubbleColor: isDarkMode
                        ? colorScheme.primary.withOpacity(0.15)
                        : colorScheme.primary.withOpacity(0.08),
                    aiBubbleColor:
                        isDarkMode ? const Color(0xFF202020) : Colors.white,
                    userBubbleTopLeftRadius: 22,
                    userBubbleTopRightRadius: 4,
                    aiBubbleTopLeftRadius: 4,
                    aiBubbleTopRightRadius: 22,
                    bottomLeftRadius: 22,
                    bottomRightRadius: 22,
                    enableShadow: true,
                    shadowOpacity: isDarkMode ? 0.3 : 0.1,
                    shadowBlurRadius: 12,
                    shadowOffset: const Offset(0, 4),
                    userNameColor:
                        isDarkMode ? Colors.grey[300] : colorScheme.primary,
                    aiNameColor:
                        isDarkMode ? Colors.grey[300] : colorScheme.secondary,
                    copyIconColor: colorScheme.primary,
                  ),
                  containerMargin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  timeTextStyle: TextStyle(
                    fontSize: 11,
                    color: isDarkMode ? Colors.grey[500] : Colors.grey[600],
                  ),
                  showCopyButton: true,
                ),

                // Markdown style sheet for message formatting
                markdownStyleSheet: MarkdownStyleSheet(
                  p: TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    color: isDarkMode ? Colors.white : Colors.black87,
                    letterSpacing: 0.2,
                  ),
                  h1: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black87,
                    letterSpacing: -0.5,
                    height: 1.3,
                  ),
                  h2: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black87,
                    letterSpacing: -0.5,
                    height: 1.3,
                  ),
                  h3: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black87,
                    letterSpacing: -0.3,
                    height: 1.3,
                  ),
                  code: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 14,
                    backgroundColor: isDarkMode
                        ? const Color(0xFF0D1117).withOpacity(0.6)
                        : const Color(0xFFF6F8FA).withOpacity(0.8),
                    color: isDarkMode
                        ? const Color(0xFF79C0FF)
                        : const Color(0xFF0550AE),
                    letterSpacing: 0,
                    height: 1.5,
                  ),
                  codeblockDecoration: BoxDecoration(
                    color: isDarkMode
                        ? const Color(0xFF0D1117)
                        : const Color(0xFFF6F8FA),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDarkMode
                          ? const Color(0xFF30363D)
                          : const Color(0xFFE1E4E8),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color:
                            Colors.black.withOpacity(isDarkMode ? 0.2 : 0.05),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                        spreadRadius: -2,
                      ),
                    ],
                  ),
                  codeblockPadding: const EdgeInsets.all(16),
                  blockquote: TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                    fontStyle: FontStyle.italic,
                    letterSpacing: 0.2,
                  ),
                  blockquoteDecoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color:
                            isDarkMode ? Colors.grey[700]! : Colors.grey[400]!,
                        width: 4,
                      ),
                    ),
                  ),
                  blockquotePadding: const EdgeInsets.only(
                      left: 16, top: 4, bottom: 4, right: 8),
                  tableHead: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  tableBorder: TableBorder.all(
                    color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
                    width: 1,
                  ),
                  tableBody: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: isDarkMode ? Colors.grey[300] : Colors.black87,
                  ),
                  tableCellsPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  a: TextStyle(
                    color: colorScheme.primary,
                    decoration: TextDecoration.underline,
                    decorationColor: colorScheme.primary.withOpacity(0.3),
                  ),
                  em: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                  ),
                  strong: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  img: TextStyle(
                    fontSize: 0, // Hide image alt text
                  ),
                  listBullet: TextStyle(
                    fontSize: 16,
                    color: isDarkMode
                        ? colorScheme.primary
                        : colorScheme.primary.withOpacity(0.8),
                  ),
                ),

                // Loading configuration
                loadingConfig: LoadingConfig(
                  isLoading: _isLoading,
                  typingIndicatorColor: colorScheme.primary,
                  loadingIndicator: SizedBox(
                    height: 24,
                    width: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        3,
                        (index) => _buildPulsingDot(
                          context,
                          delay: Duration(milliseconds: index * 300),
                        ),
                      ),
                    ),
                  ),
                ),

                // Pagination configuration
                paginationConfig: const PaginationConfig(
                  enabled: true,
                  messagesPerPage: 20,
                  loadingDelay: Duration(milliseconds: 500),
                ),

                // Scroll to bottom options
                scrollToBottomOptions: ScrollToBottomOptions(
                  scrollToBottomBuilder: (controller) => Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          colorScheme.primary,
                          colorScheme.primary.withBlue(
                              (colorScheme.primary.blue + 40).clamp(0, 255)),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(8),
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
              controller: _chatController,
              currentUser: _currentUser,
              aiUser: _aiUser,
              onSendMessage: _handleSendMessage,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPulsingDot(BuildContext context, {required Duration delay}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 1500),
        curve: Curves.easeInOut,
        builder: (context, value, child) {
          return Opacity(
            opacity: (value < 0.5) ? value * 2 : (1 - value) * 2,
            child: Transform.scale(
              scale: 0.5 + ((value < 0.5) ? value : (1 - value)) * 0.5,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Method to toggle welcome message visibility
  void _toggleWelcomeMessage() {
    setState(() {
      _welcomeMessageVisible = !_welcomeMessageVisible;

      if (_welcomeMessageVisible) {
        // We can't directly manipulate controller's internal state,
        // so we'll use a workaround to "reset" the welcome message state

        // Save current messages
        final currentMessages =
            List<ChatMessage>.from(_chatController.messages);

        // Clear messages (which resets welcome message state internally)
        _chatController.clearMessages();

        // Add back the saved messages
        for (final msg in currentMessages) {
          _chatController.addMessage(msg);
        }
      } else {
        // Hide welcome message
        _chatController.hideWelcomeMessage();
      }
    });
  }
}
