import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  Timer? _scrollDebounce;
  bool _isNearEdge = false;

  @override
  void initState() {
    super.initState();
    _scrollController =
        widget.messageListOptions.scrollController ?? ScrollController();
    _scrollController.addListener(_handleScroll);
  }

  @override
  void didUpdateWidget(CustomChatWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update the controller if it changed
    if (oldWidget.messageListOptions.scrollController !=
        widget.messageListOptions.scrollController) {
      _scrollController.removeListener(_handleScroll);
      _scrollController =
          widget.messageListOptions.scrollController ?? ScrollController();
      _scrollController.addListener(_handleScroll);
    }
  }

  void _handleScroll() {
    if (!_scrollController.hasClients) return;

    // Debounce scroll events to avoid excessive rebuilds
    _scrollDebounce?.cancel();
    _scrollDebounce = Timer(
        widget.messageListOptions.paginationConfig.loadMoreDebounceTime, () {
      if (!mounted) return;

      final position = _scrollController.position.pixels;
      final maxScroll = _scrollController.position.maxScrollExtent;

      // Update scroll to bottom button visibility
      final shouldShow = position > 100;
      if (shouldShow != _showScrollToBottom) {
        setState(() => _showScrollToBottom = shouldShow);
      }

      // Check if we should load more messages
      final paginationConfig = widget.messageListOptions.paginationConfig;
      if (!paginationConfig.enabled || !paginationConfig.autoLoadOnScroll) {
        return;
      }

      // Determine if we are near the edge for loading more messages
      bool shouldLoadMore;
      if (paginationConfig.reverseOrder) {
        // In reverse mode: Check if we're near the top
        if (paginationConfig.distanceToTriggerLoadPixels > 0) {
          shouldLoadMore = maxScroll > 0 &&
              (maxScroll - position) <=
                  paginationConfig.distanceToTriggerLoadPixels;
        } else {
          shouldLoadMore = maxScroll > 0 &&
              (maxScroll - position) / maxScroll <=
                  (1.0 - paginationConfig.scrollThreshold);
        }
      } else {
        // In chronological mode: Check if we're near the top
        if (paginationConfig.distanceToTriggerLoadPixels > 0) {
          shouldLoadMore =
              position <= paginationConfig.distanceToTriggerLoadPixels;
        } else {
          shouldLoadMore = maxScroll > 0 &&
              position / maxScroll <= paginationConfig.scrollThreshold;
        }
      }

      // If we should load more and weren't previously near the edge,
      // call the load more callback
      if (shouldLoadMore && !_isNearEdge) {
        _isNearEdge = true;
        // Provide haptic feedback if enabled
        if (paginationConfig.enableHapticFeedback) {
          HapticFeedback.lightImpact();
        }
        widget.messageListOptions.onLoadMore?.call();
      } else if (!shouldLoadMore && _isNearEdge) {
        _isNearEdge = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: _buildMessageList(),
            ),
            if (widget.quickReplyOptions.quickReplies != null &&
                widget.quickReplyOptions.quickReplies!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: _buildQuickReplies(),
              ),
          ],
        ),
        if (_showScrollToBottom) _buildScrollToBottomButton(),
      ],
    );
  }

  Widget _buildMessageList() {
    final paginationConfig = widget.messageListOptions.paginationConfig;

    // Build loading header/footer if needed
    Widget? loadingWidget;
    Widget? noMoreMessagesWidget;

    if (widget.messageListOptions.isLoadingMore) {
      loadingWidget = paginationConfig.loadingBuilder?.call() ??
          _buildDefaultLoadingIndicator();
    } else if (!widget.messageListOptions.hasMoreMessages &&
        widget.messages.isNotEmpty) {
      noMoreMessagesWidget = paginationConfig.noMoreMessagesBuilder?.call() ??
          _buildNoMoreMessagesIndicator();
    }

    // Build the list with header/footer as needed
    return ListView.builder(
      key: const PageStorageKey('chat_messages'),
      controller: _scrollController,
      reverse: paginationConfig.reverseOrder,
      physics: widget.messageListOptions.scrollPhysics ??
          const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: widget.messages.length +
          (widget.typingUsers?.isNotEmpty == true ? 1 : 0) +
          (loadingWidget != null ? 1 : 0) +
          (noMoreMessagesWidget != null ? 1 : 0),
      cacheExtent: paginationConfig.cacheExtent,
      itemBuilder: (context, index) {
        // Handle loading indicator at the start (chronological) or end (reverse)
        if (paginationConfig.reverseOrder) {
          // In reverse mode, older messages are at the end
          if (loadingWidget != null &&
              index ==
                  widget.messages.length +
                      (widget.typingUsers?.isNotEmpty == true ? 1 : 0)) {
            return loadingWidget;
          }

          if (noMoreMessagesWidget != null &&
              index ==
                  widget.messages.length +
                      (widget.typingUsers?.isNotEmpty == true ? 1 : 0)) {
            return noMoreMessagesWidget;
          }
        } else {
          // In chronological mode, older messages are at the beginning
          if (loadingWidget != null && index == 0) {
            return loadingWidget;
          }

          if (noMoreMessagesWidget != null && index == 0) {
            return noMoreMessagesWidget;
          }
        }

        // Handle typing indicator
        if (index == widget.messages.length &&
            widget.typingUsers?.isNotEmpty == true) {
          return _buildTypingIndicator();
        }

        // Adjust index for header/footer
        var messageIndex = index;
        if (!paginationConfig.reverseOrder &&
            (loadingWidget != null || noMoreMessagesWidget != null)) {
          messageIndex = index - 1;
        }

        // Render message bubble
        if (messageIndex < widget.messages.length) {
          final message = widget.messages[messageIndex];
          final isUser = message.user.id == widget.currentUser.id;
          final messageId = message.customProperties?['id'] as String? ??
              '${message.user.id}_${message.createdAt.millisecondsSinceEpoch}_${message.text.hashCode}';

          return RepaintBoundary(
            child: KeyedSubtree(
              key: ValueKey(messageId),
              child: _buildMessageBubble(message, isUser),
            ),
          );
        }

        return null;
      },
    );
  }

  Widget _buildMessageBubble(ChatMessage message, bool isUser) {
    // Check for custom message builder from the message itself
    if (message.customBuilder != null) {
      return message.customBuilder!(context, message);
    }

    // Default bubble implementation based on available MessageOptions properties
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Card(
          color: isUser ? Colors.blue[100] : Colors.grey[100],
          margin: EdgeInsets.only(
            top: 8,
            bottom: 8,
            right: isUser ? 8 : 60,
            left: isUser ? 60 : 8,
          ),
          elevation: 1.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: widget.messageOptions.padding ?? const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display user name if needed
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    message.user.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isUser ? Colors.blue[800] : Colors.grey[800],
                    ),
                  ),
                ),
                // Handle markdown or plain text
                message.isMarkdown
                    ? Markdown(
                        key: ValueKey('markdown_${message.text.hashCode}'),
                        data: message.text,
                        selectable: true,
                      )
                    : Text(
                        message.text,
                        style: widget.messageOptions.textStyle,
                      ),
                // Show timestamp if needed
                if (widget.messageOptions.showTime)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      _defaultTimestampFormat(message.createdAt),
                      style: widget.messageOptions.timeTextStyle ??
                          TextStyle(
                            fontSize: 10,
                            color: Colors.grey[500],
                          ),
                      textAlign: TextAlign.right,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _defaultTimestampFormat(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else {
      return '${dateTime.month}/${dateTime.day}';
    }
  }

  Widget _buildQuickReplies() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: widget.quickReplyOptions.quickReplies!.map((quickReply) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ElevatedButton(
              onPressed: () {
                widget.quickReplyOptions.onQuickReplyTap?.call(quickReply);
                widget.onSend(
                  ChatMessage(
                    text: quickReply,
                    user: widget.currentUser,
                    createdAt: DateTime.now(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[200],
                foregroundColor: Colors.black87,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(quickReply),
            ),
          );
        }).toList(),
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

  Widget _buildDefaultLoadingIndicator() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          children: [
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 3),
            ),
            const SizedBox(height: 8),
            Text(
              widget.messageListOptions.paginationConfig.loadingText,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoMoreMessagesIndicator() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Text(
          widget.messageListOptions.paginationConfig.noMoreMessagesText,
          style: const TextStyle(
            fontSize: 12,
            fontStyle: FontStyle.italic,
            color: Colors.grey,
          ),
        ),
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
    _scrollDebounce?.cancel();
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
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: Color.lerp(
              Colors.grey[400],
              Colors.grey[800],
              _animation.value,
            ),
            shape: BoxShape.circle,
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
