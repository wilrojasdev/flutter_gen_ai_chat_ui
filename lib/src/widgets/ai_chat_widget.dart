import 'package:dash_chat_2/dash_chat_2.dart' as dash;
import 'package:flutter/material.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../models/input_options.dart';
import 'chat_input.dart';

/// A customizable chat widget for AI conversations.
class AiChatWidget extends StatefulWidget {
  const AiChatWidget({
    super.key,
    required this.config,
    required this.currentUser,
    required this.aiUser,
    required this.controller,
    required this.onSendMessage,
    @Deprecated('Use config.loadingIndicator instead') this.loadingIndicator,
    @Deprecated('Use config.enableAnimation instead')
    this.enableAnimation = true,
    @Deprecated('Use config.welcomeMessageBuilder instead')
    this.welcomeMessageBuilder,
    @Deprecated('Use config.isLoading instead') this.isLoading = false,
  });

  final AiChatConfig config;
  final ChatUser currentUser;
  final ChatUser aiUser;
  final ChatMessagesController controller;
  final void Function(ChatMessage message) onSendMessage;
  @Deprecated('Use config.loadingIndicator instead')
  final Widget? loadingIndicator;
  @Deprecated('Use config.enableAnimation instead')
  final bool enableAnimation;
  @Deprecated('Use config.welcomeMessageBuilder instead')
  final Widget Function()? welcomeMessageBuilder;
  @Deprecated('Use config.isLoading instead')
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
      setState(() {
        _showScrollToBottom = _scrollController.position.pixels > 0;
      });
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

  void _handleSend(final ChatMessage message) async {
    widget.onSendMessage(message);
  }

  void handleExampleQuestionTap(final String question) {
    widget.controller
        .handleExampleQuestion(question, widget.currentUser, widget.aiUser);
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
                    child: Padding(
                      padding: const EdgeInsets.only(
                          bottom: 80), // Add bottom padding for input box
                      child: dash.DashChat(
                        currentUser: widget.currentUser,
                        messages: widget.controller.messages,
                        onSend: _handleSend,
                        messageOptions: _buildMessageOptions(context),
                        inputOptions: const dash.InputOptions(
                          sendOnEnter: false,
                          alwaysShowSend: false,
                        ),
                        typingUsers: widget.config.typingUsers,
                        messageListOptions: _buildMessageListOptions(context),
                        readOnly: true,
                        quickReplyOptions: _buildQuickReplyOptions(context),
                        scrollToBottomOptions:
                            _buildScrollToBottomOptions(context),
                      ),
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
                            widget.onSendMessage(
                              dash.ChatMessage(
                                text: _textController.text,
                                user: widget.currentUser,
                                createdAt: DateTime.now(),
                                isMarkdown: false,
                              ),
                            );
                            _textController.clear();
                          }
                        },
                        options: _buildInputOptions(context),
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
                      'Here are some questions you can ask:',
                  style: welcomeConfig?.questionsSectionTitleStyle ??
                      TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: isDarkMode ? Colors.white : Colors.black87,
                        letterSpacing: 0.1,
                        height: 1.5,
                      ),
                ),
              ),
              const SizedBox(height: 16),
              ...widget.config.exampleQuestions!.map(
                (final example) => Padding(
                  padding: EdgeInsets.only(
                    bottom: welcomeConfig?.questionSpacing ?? 12,
                  ),
                  child: _buildExampleQuestion(
                    example,
                    isDarkMode,
                    defaultQuestionConfig,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildExampleQuestion(
    final ExampleQuestion example,
    final bool isDarkMode,
    final ExampleQuestionConfig? defaultConfig,
  ) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    final config = example.config ?? defaultConfig;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (config?.onTap != null) {
            config!.onTap!(example.question);
          } else {
            handleExampleQuestionTap(example.question);
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: config?.containerPadding ??
              const EdgeInsets.symmetric(
                vertical: 14,
                horizontal: 16,
              ),
          decoration: config?.containerDecoration ??
              BoxDecoration(
                color: primaryColor.withAlpha(isDarkMode ? 77 : 38),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: primaryColor.withAlpha(isDarkMode ? 128 : 77),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(isDarkMode ? 77 : 13),
                    blurRadius: 8,
                    spreadRadius: -2,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
          child: Row(
            children: [
              Icon(
                config?.iconData ?? Icons.chat_bubble_outline_rounded,
                size: config?.iconSize ?? 20,
                color: config?.iconColor ??
                    (isDarkMode ? Colors.white : primaryColor),
              ),
              SizedBox(width: config?.spacing ?? 12),
              Expanded(
                child: Text(
                  example.question,
                  style: config?.textStyle ??
                      TextStyle(
                        color: isDarkMode ? Colors.white : primaryColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.2,
                        height: 1.4,
                      ),
                ),
              ),
              SizedBox(width: config?.spacing ?? 12),
              Icon(
                config?.trailingIconData ?? Icons.arrow_forward_rounded,
                size: config?.trailingIconSize ?? 20,
                color: config?.trailingIconColor ??
                    (isDarkMode ? Colors.white : primaryColor),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper methods to build various options
  dash.ScrollToBottomOptions _buildScrollToBottomOptions(
      final BuildContext context) {
    return dash.ScrollToBottomOptions(
      disabled: !_showScrollToBottom,
      onScrollToBottomPress: _scrollToBottom,
      scrollToBottomBuilder: widget.config.scrollToBottomBuilder ??
          (final scrollController) => _defaultScrollToBottomBuilder(),
    );
  }

  InputOptions _buildInputOptions(final BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // Get the base input options from config or create default

    return InputOptions(
      // Apply styling from config or use defaults
      inputTextStyle: widget.config.inputTextStyle ??
          TextStyle(
            color: isDarkMode ? Colors.white : Colors.black87,
            fontSize: 16,
            height: 1.5,
          ),
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 4,
      ),
      inputDecoration: widget.config.inputDecoration ??
          InputDecoration(
            isDense: true,
            filled: true,
            fillColor: isDarkMode ? const Color(0xFF2A2A2A) : Colors.grey[50],
            hintText: widget.config.hintText,
            hintStyle: TextStyle(
              color: isDarkMode ? Colors.white.withAlpha(102) : Colors.black38,
              fontSize: 16,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: isTablet ? 20 : 16,
              vertical: isTablet ? 14 : 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: isDarkMode
                    ? Colors.white.withAlpha(26)
                    : Colors.black.withAlpha(13),
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: isDarkMode
                    ? Colors.white.withAlpha(26)
                    : Colors.black.withAlpha(13),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: theme.primaryColor.withAlpha(128),
                width: 1.5,
              ),
            ),
          ),
      sendButtonBuilder: widget.config.sendButtonBuilder ??
          (final onSend) => Container(
                margin: const EdgeInsets.only(left: 8, right: 4),
                decoration: BoxDecoration(
                  color: theme.primaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  key: const Key('sendButton'),
                  icon: Icon(
                    widget.config.sendButtonIcon ?? Icons.send_rounded,
                    color: Colors.white,
                    size: widget.config.sendButtonIconSize ?? 20,
                  ),
                  onPressed: onSend,
                ),
              ),
    );
  }

  dash.MessageOptions _buildMessageOptions(final BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    final backgroundColor =
        isDarkMode ? const Color(0xFF2A2A2A) : Colors.grey[50]!;
    final textColor = isDarkMode ? Colors.white : Colors.black87;

    return dash.MessageOptions(
      containerColor: backgroundColor,
      currentUserContainerColor: theme.primaryColor.withAlpha(26),
      currentUserTextColor: textColor,
      currentUserTimeTextColor:
          isDarkMode ? Colors.grey[400]! : Colors.grey[600]!,
      messagePadding: EdgeInsets.symmetric(
        horizontal: isTablet ? 20 : 16,
        vertical: isTablet ? 14 : 12,
      ),
      showTime: widget.config.showTimestamp,
      spaceWhenAvatarIsHidden: 8,
      textColor: textColor,
      timeFontSize: 11,
      timePadding: const EdgeInsets.only(top: 4),
      timeTextColor: isDarkMode ? Colors.grey[400]! : Colors.grey[600]!,
      messageTextBuilder:
          (final message, final previousMessage, final nextMessage) {
        if (widget.config.messageBuilder != null) {
          return widget.config.messageBuilder!(message);
        }

        final isLatestMessage = widget.controller.messages.isNotEmpty &&
            widget.controller.messages.first.createdAt.millisecondsSinceEpoch ==
                message.createdAt.millisecondsSinceEpoch;
        final isUser = message.user.id == widget.currentUser.id;

        return AnimatedBubble(
          key: ValueKey(message.createdAt.millisecondsSinceEpoch),
          animate: widget.config.enableAnimation && isLatestMessage,
          isUser: isUser,
          child: MouseRegion(
            cursor: SystemMouseCursors.text,
            child: AnimatedTextMessage(
              key: ValueKey(
                '${message.createdAt.millisecondsSinceEpoch}_'
                '${message.text.length}',
              ),
              text: message.text,
              animate: widget.config.enableAnimation && isLatestMessage,
              isUser: isUser,
              isStreaming: isLatestMessage && !isUser && widget.isLoading,
              style: TextStyle(
                color: textColor,
                fontSize: isTablet ? 16 : 15,
                height: 1.5,
                letterSpacing: 0.1,
              ),
              textBuilder: (final text, final style) {
                // Check if the message is markdown
                if (message.isMarkdown == true) {
                  return MarkdownBody(
                    data: text,
                    selectable: true,
                    styleSheet: MarkdownStyleSheet(
                      p: style,
                      code: style.copyWith(
                        fontFamily: 'monospace',
                        backgroundColor: isDarkMode
                            ? Colors.white.withValues(alpha: 26)
                            : Colors.black.withValues(alpha: 26),
                        fontSize: style.fontSize,
                      ),
                      codeblockDecoration: BoxDecoration(
                        color: isDarkMode
                            ? Colors.white.withValues(alpha: 26)
                            : Colors.black.withValues(alpha: 26),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      blockquote: style,
                      blockquoteDecoration: BoxDecoration(
                        color: isDarkMode
                            ? Colors.white.withValues(alpha: 26)
                            : Colors.black.withValues(alpha: 26),
                        borderRadius: BorderRadius.circular(8),
                        border: Border(
                          left: BorderSide(
                            color: isDarkMode
                                ? Colors.white.withValues(alpha: 77)
                                : Colors.black.withValues(alpha: 77),
                            width: 4,
                          ),
                        ),
                      ),
                      h1: style.copyWith(
                        fontSize: style.fontSize! * 1.5,
                        fontWeight: FontWeight.bold,
                      ),
                      h2: style.copyWith(
                        fontSize: style.fontSize! * 1.3,
                        fontWeight: FontWeight.bold,
                      ),
                      h3: style.copyWith(
                        fontSize: style.fontSize! * 1.2,
                        fontWeight: FontWeight.bold,
                      ),
                      listBullet: style,
                    ),
                  );
                }
                return SelectableText(text, style: style);
              },
            ),
          ),
        );
      },
    );
  }

  dash.MessageListOptions _buildMessageListOptions(final BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return dash.MessageListOptions(
      dateSeparatorBuilder: (final date) => Padding(
        padding: EdgeInsets.symmetric(
          vertical: isTablet ? 24 : 20,
        ),
        child: Text(
          date.toLocal().toString().split(' ')[0],
          style: TextStyle(
            color: Colors.grey[500],
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      chatFooterBuilder: widget.isLoading
          ? (widget.loadingIndicator ?? const LoadingWidget())
          : null,
      scrollPhysics: const BouncingScrollPhysics(),
      scrollController: _scrollController,
      showDateSeparator: isTablet,
      // Update pagination options to use correct parameters
      onLoadEarlier: widget.config.enablePagination
          ? () => widget.controller.loadMore()
          : null,
      loadEarlierBuilder: const LoadingWidget(),
    );
  }

  dash.QuickReplyOptions _buildQuickReplyOptions(BuildContext context) {
    return widget.config.quickReplyOptions ?? const dash.QuickReplyOptions();
  }

  Widget _defaultScrollToBottomBuilder() {
    final customTheme = Theme.of(context).extension<CustomThemeExtension>()!;

    return Positioned(
      bottom: 8,
      right: 0,
      left: 0,
      child: Center(
        child: Container(
          height: 32,
          width: 32,
          decoration: BoxDecoration(
            color: (customTheme.backToBottomButtonColor ?? Colors.grey)
                .withAlpha(204),
            borderRadius: BorderRadius.circular(16),
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: customTheme.chatBackground ?? Colors.white,
              size: 24,
            ),
            onPressed: _scrollToBottom,
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
