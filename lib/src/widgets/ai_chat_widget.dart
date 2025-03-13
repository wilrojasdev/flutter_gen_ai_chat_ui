import 'package:flutter/material.dart';

import '../controllers/chat_messages_controller.dart';
import '../models/ai_chat_config.dart';
import '../models/chat/models.dart';
import '../models/example_question_config.dart';
import '../models/input_options.dart';
import '../theme/custom_theme_extension.dart';
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
  State<AiChatWidget> createState() => _AiChatWidgetState();
}

class _AiChatWidgetState extends State<AiChatWidget>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  bool _showScrollToBottom = false;
  late AnimationController _animationController;
  late TextEditingController _textController;
  late FocusNode _inputFocusNode;
  bool _isComposing = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animationController.forward();

    _textController =
        widget.config.inputOptions?.textController ?? TextEditingController();
    _inputFocusNode = FocusNode();

    _textController.addListener(() {
      final isComposing = _textController.text.isNotEmpty;
      if (isComposing != _isComposing) {
        setState(() {
          _isComposing = isComposing;
        });
      }
    });
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

  /// Returns the effective typing users list, including the AI user when loading
  /// if no other typing users are provided
  List<ChatUser> _getEffectiveTypingUsers() {
    final isLoading = widget.config.loadingConfig.isLoading || widget.isLoading;

    // If we have explicitly set typing users, use those regardless of loading state
    if (widget.config.typingUsers != null &&
        widget.config.typingUsers!.isNotEmpty) {
      return widget.config.typingUsers!;
    }

    // If we're loading and don't have typing users, add the AI user as typing
    if (isLoading) {
      return [widget.aiUser];
    }

    // No typing users
    return [];
  }

  @override
  Widget build(final BuildContext context) => ListenableBuilder(
        listenable: widget.controller,
        builder: (final context, final child) => Material(
          color: Colors.transparent,
          child: Container(
            width: widget.config.maxWidth ?? double.infinity,
            height: double.infinity,
            padding: widget.config.padding,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (widget.controller.showWelcomeMessage) ...[
                      // Wrap in a container with finite height to prevent it from
                      // taking too much space
                      Container(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.4,
                        ),
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: widget.welcomeMessageBuilder?.call() ??
                              _buildWelcomeMessage(context),
                        ),
                      ),
                    ],
                    // Show persistent example questions if enabled and welcome message is hidden
                    if (!widget.controller.showWelcomeMessage &&
                        widget.config.persistentExampleQuestions &&
                        widget.config.exampleQuestions != null &&
                        widget.config.exampleQuestions!.isNotEmpty) ...[
                      Container(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.15,
                        ),
                        margin: const EdgeInsets.only(
                          left: 16,
                          right: 16,
                          top: 4,
                          bottom: 12,
                        ),
                        child: _buildPersistentExampleQuestions(context),
                      ),
                    ],
                    Expanded(
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          // Add padding at the bottom to prevent content from being hidden behind input
                          Padding(
                            padding: EdgeInsets.only(
                                bottom: !widget.config.readOnly ? 80 : 0),
                            child: CustomChatWidget(
                              controller: widget.controller,
                              currentUser: widget.currentUser,
                              messages: widget.controller.messages,
                              onSend: _handleSend,
                              messageOptions: widget.config.messageOptions ??
                                  const MessageOptions(),
                              inputOptions: widget.config.inputOptions ??
                                  const InputOptions(),
                              typingUsers: _getEffectiveTypingUsers(),
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
                              typingIndicator:
                                  (widget.config.loadingConfig.isLoading ||
                                          widget.isLoading)
                                      ? widget.config.loadingConfig
                                              .loadingIndicator ??
                                          widget.loadingIndicator
                                      : null,
                            ),
                          ),
                          if ((widget.config.loadingConfig.isLoading ||
                                  widget.isLoading) &&
                              widget.config.loadingConfig.showCenteredIndicator)
                            Center(
                              child: widget
                                      .config.loadingConfig.loadingIndicator ??
                                  widget.loadingIndicator ??
                                  const CircularProgressIndicator(),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (!widget.config.readOnly)
                  Positioned(
                    left: widget.config.inputOptions?.positionedLeft ?? 0,
                    right: widget.config.inputOptions?.positionedRight ?? 0,
                    bottom: widget.config.inputOptions?.positionedBottom ?? 0.1,
                    child: widget.config.inputOptions?.useOuterContainer ==
                            false
                        ? _buildChatInput() // Render input directly without container
                        : Material(
                            elevation:
                                widget.config.inputOptions?.materialElevation ??
                                    0,
                            color: widget.config.inputOptions
                                        ?.useScaffoldBackground ==
                                    true
                                ? Theme.of(context).scaffoldBackgroundColor
                                : widget.config.inputOptions?.materialColor,
                            shape: widget.config.inputOptions?.materialShape ??
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(22),
                                  side: BorderSide.none,
                                ),
                            clipBehavior: Clip.antiAlias,
                            child: Padding(
                              padding:
                                  widget.config.inputOptions?.materialPadding ??
                                      const EdgeInsets.all(8.0),
                              child: _buildChatInput(),
                            ),
                          ),
                  ),
              ],
            ),
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
              vertical: 12,
            ),
        padding: welcomeConfig?.containerPadding ?? const EdgeInsets.all(24),
        decoration: welcomeConfig?.containerDecoration ??
            BoxDecoration(
              color: isDarkMode ? const Color(0xFF1E2026) : Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.08),
                  blurRadius: 20,
                  spreadRadius: -4,
                  offset: const Offset(0, 8),
                ),
              ],
              border: Border.all(
                color: primaryColor.withOpacity(isDarkMode ? 0.2 : 0.15),
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
                      horizontal: 16,
                      vertical: 12,
                    ),
                decoration: welcomeConfig?.questionsSectionDecoration ??
                    BoxDecoration(
                      color: primaryColor.withOpacity(isDarkMode ? 0.15 : 0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: primaryColor.withOpacity(isDarkMode ? 0.3 : 0.2),
                      ),
                    ),
                child: Text(
                  welcomeConfig?.questionsSectionTitle ??
                      'Try asking one of these questions:',
                  style: welcomeConfig?.questionsSectionTitleStyle ??
                      TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                ),
              ),
              const SizedBox(height: 16),
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
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => handleExampleQuestionTap(question.question),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: config?.containerPadding ??
                const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
            decoration: config?.containerDecoration ??
                BoxDecoration(
                  color: primaryColor.withOpacity(isDarkMode ? 0.12 : 0.06),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: primaryColor.withOpacity(isDarkMode ? 0.3 : 0.15),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(isDarkMode ? 0.12 : 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                      spreadRadius: -2,
                    ),
                  ],
                ),
            child: Row(
              children: [
                Icon(
                  config?.iconData ?? Icons.chat_bubble_outline_rounded,
                  size: config?.iconSize ?? 18,
                  color: config?.iconColor ??
                      (isDarkMode
                          ? Colors.white.withOpacity(0.8)
                          : primaryColor.withOpacity(0.8)),
                ),
                SizedBox(width: config?.spacing ?? 12),
                Expanded(
                  child: Text(
                    question.question,
                    style: config?.textStyle ??
                        TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isDarkMode
                              ? Colors.white.withOpacity(0.9)
                              : Colors.black.withOpacity(0.8),
                          height: 1.4,
                        ),
                  ),
                ),
                SizedBox(width: 8),
                Icon(
                  config?.trailingIconData ?? Icons.arrow_forward_ios_rounded,
                  size: config?.trailingIconSize ?? 14,
                  color: config?.trailingIconColor ??
                      (isDarkMode
                          ? Colors.white.withOpacity(0.5)
                          : primaryColor.withOpacity(0.5)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Add a new method for building just the example questions without the welcome message
  Widget _buildPersistentExampleQuestions(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final primaryColor = theme.primaryColor;
    final defaultQuestionConfig = widget.config.exampleQuestionConfig;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: isDarkMode
            ? const Color(0xFF1E2026).withOpacity(0.9)
            : Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.2 : 0.06),
            blurRadius: 15,
            offset: const Offset(0, 5),
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, bottom: 12),
            child: Text(
              'Suggested Questions',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDarkMode ? Colors.white70 : Colors.black87,
              ),
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: widget.config.exampleQuestions!
                    .map(
                      (question) => _buildPersistentQuestionChip(
                        question,
                        defaultQuestionConfig,
                        isDarkMode,
                        primaryColor,
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // New method for building question chips in a more compact form
  Widget _buildPersistentQuestionChip(
    ExampleQuestion question,
    ExampleQuestionConfig? config,
    bool isDarkMode,
    Color primaryColor,
  ) {
    final chipColor = isDarkMode
        ? primaryColor.withValues(alpha: 0.15 * 255)
        : primaryColor.withValues(alpha: 0.08 * 255);

    return InkWell(
      onTap: () => handleExampleQuestionTap(question.question),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: chipColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: primaryColor.withValues(alpha: 0.2 * 255),
            width: 1,
          ),
        ),
        child: Text(
          question.question,
          style: TextStyle(
            fontSize: 13,
            color: isDarkMode ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // Update the _buildChatInput method
  Widget _buildChatInput() {
    if (widget.config.readOnly) {
      return const SizedBox.shrink();
    }

    // Get the app's text direction
    final appDirection = Directionality.of(context);
    final theme = Theme.of(context);
    final themeExtension = theme.extension<CustomThemeExtension>();
    final isDarkMode = theme.brightness == Brightness.dark;

    // Get the appropriate input options
    final baseInputOptions = widget.config.inputOptions ?? const InputOptions();

    // Get default decoration
    final decoration = baseInputOptions.decoration;

    // Apply theme-specific colors
    final effectiveDecoration = decoration?.copyWith(
      fillColor: themeExtension?.inputBackgroundColor ??
          (isDarkMode ? const Color(0xFF1E2026) : Colors.white),
    );

    // Create input options without dynamic direction changes
    final effectiveInputOptions = InputOptions(
      // Preserve original properties
      textStyle: baseInputOptions.textStyle,
      decoration: effectiveDecoration,
      margin: baseInputOptions.margin,
      containerDecoration: baseInputOptions.containerDecoration?.copyWith(
        color: themeExtension?.inputBackgroundColor ??
            (isDarkMode ? const Color(0xFF1E2026) : Colors.white),
      ),
      containerBackgroundColor: baseInputOptions.containerBackgroundColor,
      blurStrength: baseInputOptions.blurStrength,
      containerPadding: baseInputOptions.containerPadding,
      clipBehavior: baseInputOptions.clipBehavior,
      materialElevation: baseInputOptions.materialElevation,
      materialColor: themeExtension?.inputBackgroundColor ??
          (isDarkMode ? const Color(0xFF1E2026) : Colors.white),
      materialShape: baseInputOptions.materialShape,
      useScaffoldBackground: baseInputOptions.useScaffoldBackground,
      materialPadding: baseInputOptions.materialPadding,
      inputHeight: baseInputOptions.inputHeight,
      inputContainerHeight: baseInputOptions.inputContainerHeight,
      inputContainerConstraints: baseInputOptions.inputContainerConstraints,
      inputContainerWidth: baseInputOptions.inputContainerWidth,
      sendButtonBuilder: baseInputOptions.sendButtonBuilder,
      sendOnEnter: baseInputOptions.sendOnEnter,
      alwaysShowSend: baseInputOptions.alwaysShowSend,
      autocorrect: baseInputOptions.autocorrect,

      // Use app direction instead of dynamic direction
      inputTextDirection: appDirection,
    );

    return ChatInput(
      controller: _textController,
      focusNode: _inputFocusNode,
      options: effectiveInputOptions,
      onSend: _handleSubmitted,
    );
  }

  void _handleSubmitted() {
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
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();

    _textController.removeListener(() {});

    // Don't dispose if using external controller
    if (widget.config.inputOptions?.textController == null) {
      _textController.dispose();
    }
    _inputFocusNode.dispose();
    super.dispose();
  }
}
