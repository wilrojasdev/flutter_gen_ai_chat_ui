import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_streaming_text_markdown/flutter_streaming_text_markdown.dart';

import '../models/chat/models.dart';
import '../models/input_options.dart';

class CustomChatWidget extends StatefulWidget {
  final ChatUser currentUser;
  final List<ChatMessage> messages;
  final Function(ChatMessage) onSend;
  final MessageOptions messageOptions;
  final InputOptions inputOptions;
  final List<ChatUser>? typingUsers;
  final MessageListOptions messageListOptions;
  final bool readOnly;
  final QuickReplyOptions quickReplyOptions;
  final ScrollToBottomOptions scrollToBottomOptions;

  const CustomChatWidget({
    super.key,
    required this.currentUser,
    required this.messages,
    required this.onSend,
    required this.messageOptions,
    required this.inputOptions,
    required this.typingUsers,
    required this.messageListOptions,
    required this.readOnly,
    required this.quickReplyOptions,
    required this.scrollToBottomOptions,
  });

  @override
  State<CustomChatWidget> createState() => _CustomChatWidgetState();
}

class _CustomChatWidgetState extends State<CustomChatWidget> {
  late ScrollController _scrollController;
  bool _showScrollToBottom = false;

  @override
  void initState() {
    super.initState();
    _scrollController =
        widget.messageListOptions.scrollController ?? ScrollController();
    _scrollController.addListener(_handleScroll);
  }

  void _handleScroll() {
    if (_scrollController.hasClients) {
      final shouldShow = _scrollController.position.pixels > 100;
      if (shouldShow != _showScrollToBottom) {
        setState(() => _showScrollToBottom = shouldShow);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: ListView.builder(
                key: const PageStorageKey('chat_messages'),
                controller: _scrollController,
                reverse: true,
                physics: widget.messageListOptions.scrollPhysics ??
                    const BouncingScrollPhysics(),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: widget.messages.length +
                    (widget.typingUsers?.isNotEmpty == true ? 1 : 0),
                cacheExtent: 1000, // Cache more items for smoother scrolling
                itemBuilder: (context, index) {
                  if (index == widget.messages.length &&
                      widget.typingUsers?.isNotEmpty == true) {
                    return _buildTypingIndicator();
                  }

                  final message = widget.messages[index];
                  final isUser = message.user.id == widget.currentUser.id;
                  final messageId = message.customProperties?['id']
                          as String? ??
                      '${message.user.id}_${message.createdAt.millisecondsSinceEpoch}_${message.text.hashCode}';

                  return RepaintBoundary(
                    child: KeyedSubtree(
                      key: ValueKey(messageId),
                      child: _buildMessageBubble(message, isUser),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        if (_showScrollToBottom) _buildScrollToBottomButton(),
      ],
    );
  }

  Widget _buildMessageBubble(ChatMessage message, bool isUser) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final messageId = message.customProperties?['id'] as String? ??
        '${message.user.id}_${message.createdAt.millisecondsSinceEpoch}_${message.text.hashCode}';

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
      tween: Tween<double>(begin: 0.0, end: 1.0),
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisAlignment:
                  isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                if (!isUser && message.user.avatar != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(message.user.avatar!),
                      radius: 16,
                    ),
                  ),
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isUser
                          ? theme.primaryColor.withOpacity(0.1)
                          : isDarkMode
                              ? Colors.grey[800]
                              : Colors.grey[200],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: message.customBuilder != null
                        ? message.customBuilder!(context, message)
                        : message.isMarkdown == true
                            ? MarkdownBody(
                                data: message.text,
                                selectable: true,
                                styleSheet: MarkdownStyleSheet(
                                  p: TextStyle(
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.black87,
                                    fontSize: 16,
                                  ),
                                ),
                              )
                            : message.customProperties?['isStreaming'] == true
                                ? StreamingTextMarkdown(
                                    key: ValueKey(messageId),
                                    text: message.text,
                                    typingSpeed:
                                        const Duration(milliseconds: 50),
                                    fadeInEnabled: true,
                                    styleSheet: MarkdownStyleSheet(
                                      p: TextStyle(
                                        color: isDarkMode
                                            ? Colors.white
                                            : Colors.black87,
                                        fontSize: 16,
                                      ),
                                    ),
                                  )
                                : SelectableText(
                                    message.text,
                                    style: TextStyle(
                                      color: isDarkMode
                                          ? Colors.white
                                          : Colors.black87,
                                      fontSize: 16,
                                    ),
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

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              children: [
                _DotIndicator(),
                SizedBox(width: 4),
                _DotIndicator(delay: 0.2),
                SizedBox(width: 4),
                _DotIndicator(delay: 0.4),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScrollToBottomButton() {
    if (!_showScrollToBottom && !widget.scrollToBottomOptions.alwaysVisible) {
      return const SizedBox.shrink();
    }

    return widget.scrollToBottomOptions.scrollToBottomBuilder
            ?.call(_scrollController) ??
        Positioned(
          bottom: 8,
          right: 8,
          child: AnimatedOpacity(
            opacity: _showScrollToBottom ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 150),
            child: FloatingActionButton.small(
              key: const Key('scrollToBottomButton'),
              onPressed: () {
                if (_scrollController.hasClients) {
                  _scrollController.animateTo(
                    0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );
                }
                widget.scrollToBottomOptions.onScrollToBottomPress?.call();
              },
              child: const Icon(Icons.keyboard_arrow_down),
            ),
          ),
        );
  }

  @override
  void dispose() {
    if (widget.messageListOptions.scrollController == null) {
      _scrollController.dispose();
    }
    super.dispose();
  }
}

class _DotIndicator extends StatefulWidget {
  final double delay;

  const _DotIndicator({this.delay = 0.0});

  @override
  State<_DotIndicator> createState() => _DotIndicatorState();
}

class _DotIndicatorState extends State<_DotIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _animation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(widget.delay, 1.0, curve: Curves.easeInOut),
      ),
    );

    _controller.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, -2 * _animation.value),
          child: Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
