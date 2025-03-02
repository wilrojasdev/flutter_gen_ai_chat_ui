import 'package:flutter/material.dart';

import '../controllers/chat_messages_controller.dart';
import '../models/ai_chat_config.dart';
import '../models/chat/models.dart';
import '../models/example_question_config.dart';
import 'chat_input.dart';
import 'custom_chat_widget.dart';

/// A customizable chat widget for AI conversations.
class AiChatWidget extends StatefulWidget {
  const AiChatWidget({
    super.key,
    required this.config,
    required this.controller,
    required this.currentUser,
    required this.aiUser,
    required this.onSendMessage,
    this.scrollController,
    @Deprecated('Use config.loadingConfig.loadingIndicator instead')
    this.loadingIndicator,
    @Deprecated('Use config.enableAnimation instead')
    this.enableAnimation = true,
    @Deprecated('Use config.welcomeMessageConfig.builder instead')
    this.welcomeMessageBuilder,
    @Deprecated('Use config.loadingConfig.isLoading instead')
    this.isLoading = false,
  });

  /// The chat configuration.
  final AiChatConfig config;

  /// The current user.
  final ChatUser currentUser;

  /// The AI user.
  final ChatUser aiUser;

  /// The chat messages controller.
  final ChatMessagesController controller;

  /// Callback when a message is sent.
  final void Function(ChatMessage) onSendMessage;

  /// Optional scroll controller for the chat list
  final ScrollController? scrollController;

  @Deprecated('Use config.loadingConfig.loadingIndicator instead')
  final Widget? loadingIndicator;

  @Deprecated('Use config.enableAnimation instead')
  final bool enableAnimation;

  @Deprecated('Use config.welcomeMessageConfig.builder instead')
  final Widget Function()? welcomeMessageBuilder;

  @Deprecated('Use config.loadingConfig.isLoading instead')
  final bool isLoading;

  @override
  State<AiChatWidget> createState() => AiChatWidgetState();
}

class AiChatWidgetState extends State<AiChatWidget>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  bool _showScrollToBottom = false;
  late AnimationController _animationController;
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animationController.forward();
  }

  void _scrollListener() {
    if (_scrollController.hasClients) {
      final shouldShowButton =
          _scrollController.position.pixels > 100; // Show after scrolling 100px
      if (shouldShowButton != _showScrollToBottom) {
        setState(() {
          _showScrollToBottom = shouldShowButton;
        });
      }
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _handleSend(final ChatMessage message) {
    widget.onSendMessage(message);
  }

  void handleExampleQuestionTap(final String question) {
    // Hide welcome message first
    widget.controller.hideWelcomeMessage();

    // Create and send the message
    final message = ChatMessage(
      text: question,
      user: widget.currentUser,
      createdAt: DateTime.now(),
    );

    // Call the onSendMessage callback to trigger AI response
    widget.onSendMessage(message);
  }

  @override
  Widget build(final BuildContext context) => ListenableBuilder(
        listenable: widget.controller,
        builder: (final context, final child) => Container(
          width: widget.config.maxWidth ?? double.infinity,
          padding: widget.config.padding,
          child: Stack(
            children: [
              Column(
                children: [
                  if (widget.controller.showWelcomeMessage)
                    SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: widget.welcomeMessageBuilder?.call() ??
                          _buildWelcomeMessage(context),
                    ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 80),
                          child: CustomChatWidget(
                            currentUser: widget.currentUser,
                            messages: widget.controller.messages,
                            onSend: _handleSend,
                            messageOptions: widget.config.messageOptions ??
                                const MessageOptions(),
                            inputOptions: widget.config.inputOptions,
                            typingUsers: widget.config.typingUsers,
                            messageListOptions:
                                widget.config.messageListOptions ??
                                    const MessageListOptions(),
                            readOnly: widget.config.readOnly,
                            quickReplyOptions:
                                widget.config.quickReplyOptions ??
                                    const QuickReplyOptions(),
                            scrollToBottomOptions:
                                widget.config.scrollToBottomOptions ??
                                    const ScrollToBottomOptions(),
                          ),
                        ),
                        if (widget.config.loadingConfig.isLoading)
                          Center(
                            child:
                                widget.config.loadingConfig.loadingIndicator ??
                                    const CircularProgressIndicator(),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              if (!widget.config.readOnly)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Material(
                    elevation: 8,
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: ChatInput(
                        controller: _textController,
                        focusNode: _focusNode,
                        onSend: () {
                          if (_textController.text.trim().isNotEmpty) {
                            _handleSend(
                              ChatMessage(
                                text: _textController.text,
                                user: widget.currentUser,
                                createdAt: DateTime.now(),
                                isMarkdown: false,
                              ),
                            );
                            _textController.clear();
                          }
                        },
                        options: widget.config.inputOptions,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      );

  Widget _buildWelcomeMessage(final BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final primaryColor = theme.primaryColor;

    final welcomeConfig = widget.config.welcomeMessageConfig;
    final defaultQuestionConfig = widget.config.exampleQuestionConfig;

    return FadeTransition(
      opacity: _animationController,
      child: Container(
        margin: welcomeConfig?.containerMargin ??
            const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
        padding: welcomeConfig?.containerPadding ?? const EdgeInsets.all(16),
        decoration: welcomeConfig?.containerDecoration ??
            BoxDecoration(
              color: isDarkMode ? const Color(0xFF141414) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(isDarkMode ? 128 : 31),
                  blurRadius: 24,
                  spreadRadius: -2,
                  offset: const Offset(0, 8),
                ),
              ],
              border: Border.all(
                color: primaryColor.withAlpha(isDarkMode ? 77 : 38),
                width: 1.5,
              ),
            ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              welcomeConfig?.title ?? widget.config.aiName,
              style: welcomeConfig?.titleStyle ??
                  TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.5,
                    color: isDarkMode ? Colors.white : Colors.black,
                    height: 1.3,
                  ),
            ),
            if (widget.config.exampleQuestions?.isNotEmpty ?? false) ...[
              const SizedBox(height: 20),
              Container(
                padding: welcomeConfig?.questionsSectionPadding ??
                    const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                decoration: welcomeConfig?.questionsSectionDecoration ??
                    BoxDecoration(
                      color: primaryColor.withAlpha(isDarkMode ? 38 : 20),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: primaryColor.withAlpha(isDarkMode ? 77 : 51),
                      ),
                    ),
                child: Text(
                  welcomeConfig?.questionsSectionTitle ??
                      'Try asking one of these questions:',
                  style: welcomeConfig?.questionsSectionTitleStyle ??
                      TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                ),
              ),
              const SizedBox(height: 12),
              ...widget.config.exampleQuestions!.map(
                (question) => _buildExampleQuestion(
                  question,
                  defaultQuestionConfig,
                  isDarkMode,
                  primaryColor,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildExampleQuestion(
    final ExampleQuestion question,
    final ExampleQuestionConfig? config,
    final bool isDarkMode,
    final Color primaryColor,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => handleExampleQuestionTap(question.question),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: config?.containerPadding ??
                const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
            decoration: config?.containerDecoration ??
                BoxDecoration(
                  color: primaryColor.withAlpha(isDarkMode ? 26 : 13),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: primaryColor.withAlpha(isDarkMode ? 51 : 26),
                  ),
                ),
            child: Row(
              children: [
                Icon(
                  config?.iconData ?? Icons.chat_bubble_outline_rounded,
                  size: config?.iconSize ?? 16,
                  color: config?.iconColor ??
                      (isDarkMode ? Colors.white70 : Colors.black54),
                ),
                SizedBox(width: config?.spacing ?? 8),
                Expanded(
                  child: Text(
                    question.question,
                    style: config?.textStyle ??
                        TextStyle(
                          fontSize: 14,
                          color: isDarkMode ? Colors.white70 : Colors.black87,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}
