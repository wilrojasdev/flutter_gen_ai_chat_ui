import 'package:flutter/material.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart'
    hide CustomThemeExtension;
import 'package:flutter_gen_ai_chat_ui/src/providers/theme_provider.dart'
    show CustomThemeExtension;
import 'package:flutter_gen_ai_chat_ui/src/widgets/animated_bubble.dart';
import 'package:flutter_gen_ai_chat_ui/src/widgets/animated_text.dart';

class AiChatWidget extends StatefulWidget {
  final AiChatConfig config;
  final ChatUser currentUser;
  final ChatUser aiUser;
  final ChatMessagesController controller;
  final Widget? loadingIndicator;
  final bool enableAnimation;
  final Function(ChatMessage message) onSendMessage;
  final Widget Function()? welcomeMessageBuilder;
  final bool isLoading;

  const AiChatWidget({
    Key? key,
    required this.config,
    required this.currentUser,
    required this.aiUser,
    required this.controller,
    required this.onSendMessage,
    this.loadingIndicator,
    this.enableAnimation = true,
    this.welcomeMessageBuilder,
    this.isLoading = false,
  }) : super(key: key);

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
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _handleSend(ChatMessage message) async {
    widget.onSendMessage(message);
  }

  void handleExampleQuestionTap(String question) {
    widget.controller
        .handleExampleQuestion(question, widget.currentUser, widget.aiUser);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, child) {
        return Container(
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
        );
      },
    );
  }

  Widget _buildWelcomeMessage(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final customTheme = theme.extension<CustomThemeExtension>() ??
        ThemeProvider.lightTheme.extension<CustomThemeExtension>()!;

    return FadeTransition(
      opacity: _animationController,
      child: Container(
        margin: const EdgeInsets.all(16.0),
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF242424) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: isDarkMode
                  ? Colors.black.withOpacity(0.2)
                  : Colors.black.withOpacity(0.08),
              blurRadius: 16,
              spreadRadius: -4,
              offset: const Offset(0, 6),
            ),
          ],
          border: Border.all(
            color:
                isDarkMode ? const Color(0xFF3D3D3D) : const Color(0xFFE0E0E0),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome! How can I assist you today?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.1,
                color: customTheme.messageTextColor,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Here are some questions you can ask:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: customTheme.messageTextColor.withOpacity(0.8),
                letterSpacing: 0.1,
              ),
            ),
            const SizedBox(height: 16),
            _buildExampleQuestion(
                'What is the weather like today?', isDarkMode),
            _buildExampleQuestion('Tell me a joke.', isDarkMode),
            _buildExampleQuestion('How do I reset my password?', isDarkMode),
          ],
        ),
      ),
    );
  }

  Widget _buildExampleQuestion(String question, bool isDarkMode) {
    final theme = Theme.of(context);
    final customTheme = theme.extension<CustomThemeExtension>() ??
        ThemeProvider.lightTheme.extension<CustomThemeExtension>()!;

    return GestureDetector(
      onTap: () => handleExampleQuestionTap(question),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6.0),
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: isDarkMode
              ? customTheme.userBubbleColor.withOpacity(0.15)
              : customTheme.userBubbleColor.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDarkMode
                ? customTheme.userBubbleColor.withOpacity(0.3)
                : customTheme.userBubbleColor.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                question,
                style: TextStyle(
                  color: isDarkMode
                      ? customTheme.userBubbleColor.withOpacity(0.9)
                      : customTheme.userBubbleColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.2,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: isDarkMode
                  ? customTheme.userBubbleColor.withOpacity(0.7)
                  : customTheme.userBubbleColor.withOpacity(0.6),
            ),
          ],
        ),
      ),
    );
  }

  // Helper methods to build various options
  ScrollToBottomOptions _buildScrollOptions() {
    return ScrollToBottomOptions(
      disabled: !_showScrollToBottom,
      onScrollToBottomPress: _scrollToBottom,
      scrollToBottomBuilder: widget.config.scrollToBottomBuilder ??
          (scrollController) => _defaultScrollToBottomBuilder(),
    );
  }

  InputOptions _buildInputOptions(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final theme = Theme.of(context);
    final customTheme = theme.extension<CustomThemeExtension>() ??
        ThemeProvider.lightTheme.extension<CustomThemeExtension>()!;

    return InputOptions(
      sendOnEnter: true,
      autocorrect: false,
      inputTextStyle: widget.config.inputTextStyle ??
          FontHelper.getAppropriateFont(
            text: LocaleHelper.isRTL(context) ? 'ئ' : 'a',
            baseStyle: TextStyle(
              color: customTheme.inputTextColor,
              fontSize: 16,
            ),
          ),
      inputDecoration: widget.config.inputDecoration ??
          InputDecoration(
            isDense: true,
            filled: true,
            fillColor: customTheme.inputBackgroundColor,
            hintText: widget.config.hintText,
            hintStyle: FontHelper.getAppropriateFont(
              text: LocaleHelper.isRTL(context) ? 'ئ' : 'a',
              baseStyle: TextStyle(
                color: customTheme.hintTextColor,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: isTablet ? 24 : 20,
              vertical: isTablet ? 16 : 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: customTheme.inputBorderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: customTheme.inputBorderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: customTheme.inputBorderColor),
            ),
          ),
      sendButtonBuilder: widget.config.sendButtonBuilder ??
          (onSend) {
            return Container(
              margin:
                  widget.config.sendButtonPadding ?? const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: customTheme.sendButtonColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                icon: Icon(
                  widget.config.sendButtonIcon ?? Icons.send_rounded,
                  color: customTheme.sendButtonIconColor,
                  size: widget.config.sendButtonIconSize ?? 24,
                ),
                onPressed: onSend,
              ),
            );
          },
    );
  }

  MessageOptions _buildMessageOptions(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final theme = Theme.of(context);
    final customTheme = theme.extension<CustomThemeExtension>() ??
        ThemeProvider.lightTheme.extension<CustomThemeExtension>()!;

    return MessageOptions(
      containerColor: customTheme.messageBubbleColor,
      currentUserContainerColor: customTheme.userBubbleColor,
      currentUserTextColor: customTheme.messageTextColor,
      currentUserTimeTextColor: theme.brightness == Brightness.dark
          ? Colors.grey[400]!
          : Colors.grey[600]!,
      messagePadding: EdgeInsets.only(
        left: isTablet ? 20 : 16,
        right: isTablet ? 20 : 16,
        top: isTablet ? 20 : 16,
        bottom: isTablet ? 20 : 16,
      ),
      showTime: widget.config.showTimestamp,
      spaceWhenAvatarIsHidden: 8,
      textColor: customTheme.messageTextColor,
      timeFontSize: 11,
      timePadding: const EdgeInsets.only(top: 4),
      timeTextColor: theme.brightness == Brightness.dark
          ? Colors.grey[400]!
          : Colors.grey[600]!,
      messageTextBuilder: (message, previousMessage, nextMessage) {
        if (widget.config.messageBuilder != null) {
          return widget.config.messageBuilder!(message);
        }

        final bool isLatestMessage = widget.controller.messages.isNotEmpty &&
            widget.controller.messages.first.createdAt.millisecondsSinceEpoch ==
                message.createdAt.millisecondsSinceEpoch;
        final bool isUser = message.user.id == widget.currentUser.id;

        return AnimatedBubble(
          key: ValueKey(message.createdAt.millisecondsSinceEpoch),
          animate: widget.config.enableAnimation && isLatestMessage,
          isUser: isUser,
          child: MouseRegion(
            cursor: SystemMouseCursors.text,
            child: AnimatedTextMessage(
              key: ValueKey(
                  '${message.createdAt.millisecondsSinceEpoch}_${message.text.length}'),
              text: message.text,
              animate: widget.config.enableAnimation && isLatestMessage,
              isUser: isUser,
              isStreaming: isLatestMessage && !isUser && widget.isLoading,
              style: TextStyle(
                color: isUser
                    ? (widget.config.messageOptions?.currentUserTextColor
                            as Color?) ??
                        customTheme.messageTextColor
                    : (widget.config.messageOptions?.textColor as Color?) ??
                        customTheme.messageTextColor,
                fontSize: isTablet ? 16 : 15,
                height: 1.4,
              ),
              textBuilder: (text, style) => SelectableText(
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
      dateSeparatorBuilder: (date) => Padding(
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
        ThemeProvider.lightTheme.extension<CustomThemeExtension>()!;

    return Positioned(
      bottom: 8,
      right: 0,
      left: 0,
      child: Center(
        child: Container(
          height: 32,
          width: 32,
          decoration: BoxDecoration(
            color: customTheme.backToBottomButtonColor.withOpacity(0.8),
            borderRadius: BorderRadius.circular(16),
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: customTheme.chatBackground,
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
