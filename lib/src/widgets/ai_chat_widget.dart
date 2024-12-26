import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';

/// A customizable chat widget for AI conversations.
class AiChatWidget extends StatefulWidget {
  const AiChatWidget({
    super.key,
    required this.config,
    required this.currentUser,
    required this.aiUser,
    required this.controller,
    required this.onSendMessage,
    this.loadingIndicator,
    this.enableAnimation = true,
    this.welcomeMessageBuilder,
    this.isLoading = false,
  });
  final AiChatConfig config;
  final ChatUser currentUser;
  final ChatUser aiUser;
  final ChatMessagesController controller;
  final Widget? loadingIndicator;
  final bool enableAnimation;
  final void Function(ChatMessage message) onSendMessage;
  final Widget Function()? welcomeMessageBuilder;
  final bool isLoading;

  @override
  State<AiChatWidget> createState() => AiChatWidgetState();
}

class AiChatWidgetState extends State<AiChatWidget>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  bool _showScrollToBottom = false;
  late AnimationController _animationController;

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
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _handleSend(final ChatMessage message) async {
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
          child: Column(
            children: [
              if (widget.controller.showWelcomeMessage)
                widget.welcomeMessageBuilder?.call() ??
                    _buildWelcomeMessage(context),
              Expanded(
                child: DashChat(
                  currentUser: widget.currentUser,
                  onSend: _handleSend,
                  messages: widget.controller.messages,
                  inputOptions:
                      widget.config.inputOptions ?? _buildInputOptions(context),
                  messageOptions: widget.config.messageOptions ??
                      _buildMessageOptions(context),
                  messageListOptions: widget.config.messageListOptions ??
                      _buildMessageListOptions(),
                  quickReplyOptions: widget.config.quickReplyOptions ??
                      const QuickReplyOptions(),
                  scrollToBottomOptions: widget.config.scrollToBottomOptions ??
                      _buildScrollOptions(),
                  readOnly: widget.config.readOnly,
                  typingUsers: widget.config.typingUsers,
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildWelcomeMessage(final BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final customTheme = theme.extension<CustomThemeExtension>();

    // If no custom theme is specified, use the app's theme colors

    return FadeTransition(
      opacity: _animationController,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: isDarkMode
                  ? Colors.black.withOpacity(0.3)
                  : Colors.black.withOpacity(0.06),
              blurRadius: 20,
              spreadRadius: -4,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(
            color: isDarkMode
                ? Colors.white.withOpacity(0.1)
                : Colors.black.withOpacity(0.05),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.config.aiName ?? 'Welcome! How can I assist you today?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.5,
                color: isDarkMode ? Colors.white : Colors.black87,
                height: 1.3,
              ),
            ),
            if (widget.config.exampleQuestions?.isNotEmpty ?? false) ...[
              const SizedBox(height: 16),
              Text(
                'Here are some questions you can ask:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isDarkMode
                      ? Colors.white.withOpacity(0.7)
                      : Colors.black54,
                  letterSpacing: 0.1,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              ...widget.config.exampleQuestions!.map(
                (final example) => _buildExampleQuestion(
                  example.question,
                  isDarkMode,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildExampleQuestion(final String question, final bool isDarkMode) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;

    return GestureDetector(
      onTap: () => handleExampleQuestionTap(question),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isDarkMode
              ? primaryColor.withOpacity(0.15)
              : primaryColor.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDarkMode
                ? primaryColor.withOpacity(0.3)
                : primaryColor.withOpacity(0.2),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                question,
                style: TextStyle(
                  color:
                      isDarkMode ? primaryColor.withOpacity(0.9) : primaryColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.2,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Icon(
              Icons.arrow_forward_rounded,
              size: 18,
              color: isDarkMode
                  ? primaryColor.withOpacity(0.7)
                  : primaryColor.withOpacity(0.8),
            ),
          ],
        ),
      ),
    );
  }

  // Helper methods to build various options
  ScrollToBottomOptions _buildScrollOptions() => ScrollToBottomOptions(
        disabled: !_showScrollToBottom,
        onScrollToBottomPress: _scrollToBottom,
        scrollToBottomBuilder: widget.config.scrollToBottomBuilder ??
            (final scrollController) => _defaultScrollToBottomBuilder(),
      );

  InputOptions _buildInputOptions(final BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return InputOptions(
      sendOnEnter: true,
      autocorrect: false,
      inputTextStyle: widget.config.inputTextStyle ??
          TextStyle(
            color: isDarkMode ? Colors.white : Colors.black87,
            fontSize: 16,
            height: 1.5,
          ),
      inputDecoration: widget.config.inputDecoration ??
          InputDecoration(
            isDense: true,
            filled: true,
            fillColor: isDarkMode ? const Color(0xFF2A2A2A) : Colors.grey[50],
            hintText: widget.config.hintText ?? 'Type a message...',
            hintStyle: TextStyle(
              color:
                  isDarkMode ? Colors.white.withOpacity(0.4) : Colors.black38,
              fontSize: 16,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: isTablet ? 24 : 20,
              vertical: isTablet ? 16 : 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: isDarkMode
                    ? Colors.white.withOpacity(0.1)
                    : Colors.black.withOpacity(0.05),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: isDarkMode
                    ? Colors.white.withOpacity(0.1)
                    : Colors.black.withOpacity(0.05),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: theme.primaryColor.withOpacity(0.5),
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
                  icon: Icon(
                    widget.config.sendButtonIcon ?? Icons.send_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: onSend,
                ),
              ),
    );
  }

  MessageOptions _buildMessageOptions(final BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    final backgroundColor =
        isDarkMode ? const Color(0xFF2A2A2A) : Colors.grey[50]!;
    final textColor = isDarkMode ? Colors.white : Colors.black87;

    return MessageOptions(
      containerColor: backgroundColor,
      currentUserContainerColor: theme.primaryColor.withOpacity(0.1),
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
              textBuilder: (final text, final style) => SelectableText(
                text,
                style: style,
              ),
            ),
          ),
        );
      },
    );
  }

  MessageListOptions _buildMessageListOptions() {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return MessageListOptions(
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

  Widget _defaultScrollToBottomBuilder() {
    final theme = Theme.of(context);
    final customTheme = theme.extension<CustomThemeExtension>() ??
        ThemeProvider.lightTheme.extension<CustomThemeExtension>();

    return Positioned(
      bottom: 8,
      right: 0,
      left: 0,
      child: Center(
        child: Container(
          height: 32,
          width: 32,
          decoration: BoxDecoration(
            color: customTheme?.backToBottomButtonColor?.withOpacity(0.8) ??
                Colors.grey,
            borderRadius: BorderRadius.circular(16),
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: customTheme?.chatBackground ?? Colors.white,
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
    super.dispose();
  }
}
