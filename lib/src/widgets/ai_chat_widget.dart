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
  final ChatMessagesController controller;
  final Widget? loadingIndicator;
  final bool enableAnimation;
  final Function(String message)? onMessageSubmitted;
  final Function(List<ChatMessage> messages)? onMessagesUpdated;
  final Widget Function()? welcomeMessageBuilder;

  const AiChatWidget({
    Key? key,
    required this.config,
    required this.controller,
    this.loadingIndicator,
    this.enableAnimation = true,
    this.onMessageSubmitted,
    this.onMessagesUpdated,
    this.welcomeMessageBuilder,
  }) : super(key: key);

  @override
  State<AiChatWidget> createState() => AiChatWidgetState();
}

class AiChatWidgetState extends State<AiChatWidget>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  bool _showScrollToBottom = false;
  late final ChatUser _user;
  late final ChatUser _aiUser;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _user = ChatUser(id: '1', firstName: widget.config.userName ?? 'User');
    _aiUser = ChatUser(id: '2', firstName: widget.config.aiName ?? 'AI');
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
    setState(() => _isLoading = true);
    _animationController.reverse();

    try {
      await widget.controller.handleMessage(message, _aiUser);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void handleExampleQuestionTap(String question) {
    widget.controller.handleExampleQuestion(question, _user, _aiUser);
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
              if (widget.controller.showWelcomeMessage &&
                  widget.welcomeMessageBuilder != null)
                widget.welcomeMessageBuilder!(),
              Expanded(
                child: DashChat(
                  currentUser: _user,
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

    return FadeTransition(
      opacity: _animationController,
      child: Container(
        margin: const EdgeInsets.all(16.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[850] : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: isDarkMode ? Colors.black26 : Colors.black12,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome! How can I assist you today?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Here are some questions you can ask:',
              style: TextStyle(
                fontSize: 16,
                color: isDarkMode ? Colors.white70 : Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
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
    return GestureDetector(
      onTap: () => handleExampleQuestionTap(question),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.blueGrey[700] : Colors.blue[50],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          question,
          style: TextStyle(
            color: isDarkMode ? Colors.blue[200] : Colors.blue[700],
            fontSize: 16,
          ),
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
              color: customTheme.messageTextColor,
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
      sendButtonBuilder: (onSend) {
        return IconButton(
          icon: Icon(
            Icons.send_rounded,
            color: customTheme.messageTextColor.withOpacity(0.7),
          ),
          onPressed: onSend,
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
      currentUserTimeTextColor: Colors.grey[600]!,
      messagePadding: EdgeInsets.only(
        left: isTablet ? 20 : 16,
        right:
            isTablet ? 20 : 16, // Reduced right padding since button is outside
        top: isTablet ? 20 : 16,
        bottom: isTablet ? 20 : 16,
      ),
      showTime: widget.config.showTimestamp,
      spaceWhenAvatarIsHidden: 8,
      textColor: customTheme.messageTextColor,
      timeFontSize: 11,
      timePadding: const EdgeInsets.only(top: 4),
      timeTextColor: Colors.grey[600]!,
      messageTextBuilder: (message, previousMessage, nextMessage) {
        if (widget.config.messageBuilder != null) {
          return widget.config.messageBuilder!(message);
        }

        final bool isLatestMessage = widget.controller.messages.isNotEmpty &&
            widget.controller.messages.first.createdAt.millisecondsSinceEpoch ==
                message.createdAt.millisecondsSinceEpoch;
        final bool isUser = message.user.id == _user.id;

        return AnimatedBubble(
          key: ValueKey(message.createdAt.millisecondsSinceEpoch),
          animate: widget.config.enableAnimation && isLatestMessage,
          isUser: isUser,
          child: MouseRegion(
            cursor: SystemMouseCursors.text,
            child: AnimatedTextMessage(
              key: ValueKey(message.createdAt.millisecondsSinceEpoch),
              text: message.text,
              animate: widget.config.enableAnimation && isLatestMessage,
              isUser: isUser,
              style: TextStyle(
                color: customTheme.messageTextColor,
                fontSize: isTablet ? 16 : 15,
                height: 1.4,
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
      chatFooterBuilder: _isLoading
          ? (widget.loadingIndicator ?? const LoadingWidget())
          : null,
      scrollPhysics: const BouncingScrollPhysics(),
      scrollController: _scrollController,
      showDateSeparator: isTablet,
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
