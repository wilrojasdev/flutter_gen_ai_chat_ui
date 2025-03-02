import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';

/// A comprehensive example showcasing pagination features in the chat UI.
/// This example demonstrates:
/// - Loading messages in batches with visual indicators
/// - Support for both automatic and manual loading
/// - Realistic simulation of network conditions
/// - Visual representation of scroll position and loading triggers
/// - Detailed debugging metrics
class PaginationShowcaseExample extends StatefulWidget {
  const PaginationShowcaseExample({super.key});

  @override
  State<PaginationShowcaseExample> createState() =>
      _PaginationShowcaseExampleState();
}

class _PaginationShowcaseExampleState extends State<PaginationShowcaseExample> {
  // Constants for pagination
  static const int _totalMessages = 100;
  static const int _messagesPerPage = 20;
  // For reverse ordered chat, threshold should be high (0.8 or 0.9) to trigger when scrolled up
  static const double _scrollThreshold = 0.8;

  // Chat controller and users
  late final ChatMessagesController _controller;
  final ScrollController _scrollController = ScrollController();
  late final ChatUser _currentUser;
  late final ChatUser _aiUser;

  // State variables
  bool _isLoading = false;
  bool _showDebugStats = true;
  bool _autoLoadEnabled = true;
  bool _isNearThreshold = false;
  double _currentScrollPosition = 0.0;
  int _loadedMessagesCount = 0;
  int _remainingMessages = _totalMessages;
  int _pageLoaded = 0;
  Duration _networkDelay = const Duration(milliseconds: 800);
  String _selectedNetworkSpeed = 'Normal';

  // Performance metrics
  final Stopwatch _loadingStopwatch = Stopwatch();
  Duration _lastLoadDuration = Duration.zero;
  double _avgLoadTime = 0.0;

  // Simulated message database
  final List<ChatMessage> _allMessages = [];
  final Map<String, int> _messageBatchMap = {};

  @override
  void initState() {
    super.initState();
    _initializeUsers();
    _generateMessages();

    // Initialize with first page of messages
    _controller = ChatMessagesController(
      paginationConfig: PaginationConfig(
        enabled: true,
        messagesPerPage: _messagesPerPage,
        loadingDelay: _networkDelay,
        scrollThreshold: _scrollThreshold,
        autoLoadOnScroll: _autoLoadEnabled,
        enableHapticFeedback: true,
        distanceToTriggerLoadPixels: 200,
        // Ensure reverse order is true for chat-style pagination (newer messages at bottom)
        reverseOrder: true,
      ),
    );

    // Add scroll listener to track position
    _scrollController.addListener(_updateScrollPosition);

    // Load initial messages
    _loadMoreMessages();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateScrollPosition);
    _scrollController.dispose();
    super.dispose();
  }

  void _updateScrollPosition() {
    if (!_scrollController.hasClients) return;

    setState(() {
      if (_scrollController.position.maxScrollExtent > 0) {
        _currentScrollPosition = _scrollController.offset /
            _scrollController.position.maxScrollExtent;
      } else {
        _currentScrollPosition = 0.0;
      }

      // Check if near loading threshold
      // For reverse chat UI, the threshold should be near the top (high value)
      _isNearThreshold = _currentScrollPosition >= _scrollThreshold - 0.05 &&
          _currentScrollPosition <= _scrollThreshold + 0.05;
    });
  }

  void _initializeUsers() {
    _currentUser = const ChatUser(
      id: 'user-1',
      name: 'You',
      avatar: 'https://i.pravatar.cc/300?img=5',
    );

    _aiUser = const ChatUser(
      id: 'ai-1',
      name: 'AI Assistant',
      avatar: 'https://i.pravatar.cc/300?img=8',
    );
  }

  void _generateMessages() {
    final random = Random();
    final loremIpsum = [
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
      'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris.',
      'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum.',
      'Excepteur sint occaecat cupidatat non proident.',
      'Sunt in culpa qui officia deserunt mollit anim id est laborum.',
      'Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit.',
      'Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet.',
    ];

    // Generate messages with timestamps going back in time
    final now = DateTime.now();

    // For chat UI with proper pagination:
    // - Most recent messages should be loaded first
    // - Older messages should be loaded when scrolling up

    // Start with most recent messages (end of the array)
    for (int i = 0; i < _totalMessages; i++) {
      final isUser = i % 2 == 0;
      // Create messages with decreasing timestamps as we go further back
      final messageTime = now.subtract(Duration(minutes: i * 5));
      final messageId = 'msg-${i + 1}';

      // Calculate which batch this message belongs to (for visualization)
      final batchNumber = i ~/ _messagesPerPage;
      _messageBatchMap[messageId] = batchNumber;

      _allMessages.add(
        ChatMessage(
          text:
              '${isUser ? "You" : "AI"} (msg #${i + 1}): ${loremIpsum[random.nextInt(loremIpsum.length)]}',
          user: isUser ? _currentUser : _aiUser,
          createdAt: messageTime,
          customProperties: {
            'id': messageId,
            'batchNumber': batchNumber,
          },
        ),
      );
    }

    // Ensure messages are sorted newest first (for proper batch loading)
    _allMessages.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  void _resetDemo() {
    setState(() {
      _loadedMessagesCount = 0;
      _remainingMessages = _totalMessages;
      _pageLoaded = 0;
      _avgLoadTime = 0.0;
      _controller.clearMessages();
    });
    _loadMoreMessages();
  }

  Future<void> _loadMoreMessages() async {
    if (_isLoading || _remainingMessages <= 0) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Start timing the loading process
      _loadingStopwatch.reset();
      _loadingStopwatch.start();

      // Simulate network delay based on selected speed
      await Future.delayed(_networkDelay);

      // Calculate how many messages to load
      final messagesToLoad = min(_messagesPerPage, _remainingMessages);

      // In a chat with proper pagination:
      // - First batch is the most recent messages
      // - When loading more, we get older messages
      final startIndex = _loadedMessagesCount;
      final endIndex = _loadedMessagesCount + messagesToLoad;

      // Get the next batch of messages (older messages)
      final nextBatch = _allMessages.sublist(startIndex, endIndex);

      // Add batch information to messages
      for (var message in nextBatch) {
        message.customProperties?['loadedInBatch'] = _pageLoaded + 1;
      }

      // Provide haptic feedback before loading
      if (_controller.paginationConfig.enableHapticFeedback) {
        HapticFeedback.mediumImpact();
      }

      // Update controller with new messages
      await _controller.loadMore(() async => nextBatch);

      // Stop timing and record metrics
      _loadingStopwatch.stop();
      _lastLoadDuration = _loadingStopwatch.elapsed;

      if (_avgLoadTime == 0.0) {
        _avgLoadTime = _lastLoadDuration.inMilliseconds.toDouble();
      } else {
        _avgLoadTime = (_avgLoadTime + _lastLoadDuration.inMilliseconds) / 2;
      }

      // Update state
      setState(() {
        _loadedMessagesCount += messagesToLoad;
        _remainingMessages -= messagesToLoad;
        _pageLoaded++;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      debugPrint('Error loading messages: $e');

      // Show error snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading messages: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _simulateLoadingError() {
    setState(() {
      _isLoading = true;
    });

    Future.delayed(_networkDelay, () {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Simulated network error while loading messages'),
          backgroundColor: Colors.red,
        ),
      );
    });
  }

  void _handleSendMessage(String text) {
    if (text.trim().isEmpty) return;

    final newMessage = ChatMessage(
      text: text,
      user: _currentUser,
      createdAt: DateTime.now(),
    );

    _controller.addMessage(newMessage);

    // Simulate AI response after a delay
    Future.delayed(const Duration(seconds: 1), () {
      final aiResponse = ChatMessage(
        text: 'Thanks for your message! This is a simulated response.',
        user: _aiUser,
        createdAt: DateTime.now(),
      );
      _controller.addMessage(aiResponse);
    });
  }

  void _updateNetworkSpeed(String? speed) {
    if (speed == null) return;

    setState(() {
      _selectedNetworkSpeed = speed;
      switch (speed) {
        case 'Very Fast':
          _networkDelay = const Duration(milliseconds: 200);
          break;
        case 'Fast':
          _networkDelay = const Duration(milliseconds: 500);
          break;
        case 'Normal':
          _networkDelay = const Duration(milliseconds: 800);
          break;
        case 'Slow':
          _networkDelay = const Duration(seconds: 2);
          break;
        case 'Very Slow':
          _networkDelay = const Duration(seconds: 5);
          break;
      }

      // Use the correct parameter name for initialization
      _controller = ChatMessagesController(
        initialMessages: _controller.messages,
        paginationConfig: PaginationConfig(
          enabled: true,
          messagesPerPage: _messagesPerPage,
          loadingDelay: _networkDelay,
          scrollThreshold: _scrollThreshold,
          autoLoadOnScroll: _autoLoadEnabled,
          enableHapticFeedback: true,
          distanceToTriggerLoadPixels: 200,
          reverseOrder: true,
        ),
      );
    });
  }

  void _updateAutoLoadSetting(bool? value) {
    if (value == null) return;

    setState(() {
      _autoLoadEnabled = value;

      // Use the correct parameter name for initialization
      _controller = ChatMessagesController(
        initialMessages: _controller.messages,
        paginationConfig: PaginationConfig(
          enabled: true,
          messagesPerPage: _messagesPerPage,
          loadingDelay: _networkDelay,
          scrollThreshold: _scrollThreshold,
          autoLoadOnScroll: _autoLoadEnabled,
          enableHapticFeedback: true,
          distanceToTriggerLoadPixels: 200,
          reverseOrder: true,
        ),
      );
    });
  }

  Widget _buildDebugStats() {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Pagination Debug Panel',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const Divider(color: Colors.white30),
          Text('Total Messages: $_totalMessages',
              style: const TextStyle(color: Colors.white)),
          Text('Loaded: $_loadedMessagesCount',
              style: const TextStyle(color: Colors.white)),
          Text('Remaining: $_remainingMessages',
              style: const TextStyle(color: Colors.white)),
          Text('Pages Loaded: $_pageLoaded',
              style: const TextStyle(color: Colors.white)),
          Text('Is Loading: $_isLoading',
              style:
                  TextStyle(color: _isLoading ? Colors.yellow : Colors.white)),
          Text('Has More: ${_remainingMessages > 0}',
              style: TextStyle(
                  color: _remainingMessages > 0 ? Colors.green : Colors.red)),
          Text(
              'Scroll Position: ${(_currentScrollPosition * 100).toStringAsFixed(1)}%',
              style: TextStyle(
                  color: _isNearThreshold ? Colors.orange : Colors.white)),
          // In reverse ordered chat, threshold should be near 0.8-0.9 (top of list)
          Text('Threshold: ${(_scrollThreshold * 100).toStringAsFixed(1)}%',
              style: const TextStyle(color: Colors.white)),
          Text('Auto-Load: $_autoLoadEnabled',
              style: TextStyle(
                  color: _autoLoadEnabled ? Colors.green : Colors.grey)),
          Text('Network Delay: ${_networkDelay.inMilliseconds}ms',
              style: const TextStyle(color: Colors.white)),
          Text('Last Load Time: ${_lastLoadDuration.inMilliseconds}ms',
              style: const TextStyle(color: Colors.yellow)),
          Text('Avg Load Time: ${_avgLoadTime.toStringAsFixed(1)}ms',
              style: const TextStyle(color: Colors.yellow)),
        ],
      ),
    );
  }

  Widget _buildNetworkControls() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.blueGrey.withOpacity(0.8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Pagination Controls',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const Divider(color: Colors.white30),

          // Network speed selector
          Row(
            children: [
              const Text('Network Speed:',
                  style: TextStyle(color: Colors.white)),
              const SizedBox(width: 8),
              DropdownButton<String>(
                value: _selectedNetworkSpeed,
                dropdownColor: Colors.blueGrey,
                style: const TextStyle(color: Colors.white),
                underline: Container(height: 1, color: Colors.white30),
                items: const [
                  DropdownMenuItem(
                      value: 'Very Fast', child: Text('Very Fast (200ms)')),
                  DropdownMenuItem(value: 'Fast', child: Text('Fast (500ms)')),
                  DropdownMenuItem(
                      value: 'Normal', child: Text('Normal (800ms)')),
                  DropdownMenuItem(value: 'Slow', child: Text('Slow (2s)')),
                  DropdownMenuItem(
                      value: 'Very Slow', child: Text('Very Slow (5s)')),
                ],
                onChanged: _updateNetworkSpeed,
              ),
            ],
          ),

          // Auto-load toggle
          Row(
            children: [
              const Text('Auto-load on scroll:',
                  style: TextStyle(color: Colors.white)),
              const SizedBox(width: 8),
              Switch(
                value: _autoLoadEnabled,
                onChanged: _updateAutoLoadSetting,
                activeColor: Colors.green,
              ),
            ],
          ),

          // Controls
          Row(
            children: [
              // Manual load button
              if (!_autoLoadEnabled && _remainingMessages > 0)
                ElevatedButton(
                  onPressed: _isLoading ? null : _loadMoreMessages,
                  child: Text(_isLoading
                      ? 'Loading...'
                      : 'Load ${min(_messagesPerPage, _remainingMessages)} Older'),
                ),
              const SizedBox(width: 8),

              // Error simulation
              ElevatedButton(
                onPressed: _isLoading ? null : _simulateLoadingError,
                style:
                    ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                child: const Text('Simulate Error'),
              ),

              const SizedBox(width: 8),

              // Reset button
              ElevatedButton(
                onPressed: _resetDemo,
                child: const Text('Reset'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScrollPositionIndicator() {
    return Container(
      width: 8,
      height: MediaQuery.of(context).size.height,
      color: Colors.transparent,
      child: Stack(
        children: [
          // Threshold marker - for reverse chat, should be near the top
          Positioned(
            top: MediaQuery.of(context).size.height * _scrollThreshold,
            child: Container(
              width: 8,
              height: 25,
              decoration: BoxDecoration(
                color: _isNearThreshold ? Colors.orange : Colors.blue,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),

          // Current position marker
          if (_scrollController.hasClients)
            Positioned(
              top: MediaQuery.of(context).size.height * _currentScrollPosition,
              child: Container(
                width: 8,
                height: 15,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBatchSeparator(int batchNumber) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.blueGrey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blueGrey.withOpacity(0.3)),
      ),
      child: Text(
        'Older Messages - Batch #${batchNumber + 1}',
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.blueGrey,
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: _isLoading ? 50 : 0,
      color: Colors.amber.withOpacity(0.2),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: 10),
            Text(_remainingMessages > 0
                ? 'Loading older messages ${_loadedMessagesCount + 1} - ${_loadedMessagesCount + min(_messagesPerPage, _remainingMessages)}...'
                : 'Loading...'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enhanced Pagination Demo'),
        actions: [
          IconButton(
            icon:
                Icon(_showDebugStats ? Icons.visibility_off : Icons.visibility),
            onPressed: () => setState(() => _showDebugStats = !_showDebugStats),
            tooltip: 'Toggle Debug Panel',
          ),
        ],
      ),
      body: Column(
        children: [
          // For reverse-ordered chat, the loading indicator should be at the top
          _buildLoadingIndicator(),

          // Main content
          Expanded(
            child: Stack(
              children: [
                AiChatWidget(
                  config: AiChatConfig(
                    aiName: 'AI Assistant',
                    messageOptions: const MessageOptions(
                      showTime: true,
                      textStyle: TextStyle(fontSize: 16),
                    ),
                    messageListOptions: MessageListOptions(
                      isLoadingMore: _isLoading,
                      hasMoreMessages: _remainingMessages > 0,
                      onLoadMore: _autoLoadEnabled ? _loadMoreMessages : null,
                      paginationConfig: PaginationConfig(
                        enabled: true,
                        messagesPerPage: _messagesPerPage,
                        loadingDelay: _networkDelay,
                        scrollThreshold: _scrollThreshold,
                        autoLoadOnScroll: _autoLoadEnabled,
                        enableHapticFeedback: true,
                        distanceToTriggerLoadPixels: 200,
                        loadingText: 'Loading earlier messages...',
                        noMoreMessagesText: 'Beginning of conversation',
                        // Essential for proper chat pagination - newer messages at bottom
                        reverseOrder: true,
                      ),
                      scrollController: _scrollController,
                    ),
                    welcomeMessageConfig: const WelcomeMessageConfig(
                      title: 'Enhanced Pagination Demo',
                      questionsSectionTitle: 'How to use this demo:',
                    ),
                    exampleQuestions: [
                      const ExampleQuestion(
                        question:
                            'This chat contains $_totalMessages messages with enhanced pagination visualization.',
                      ),
                      const ExampleQuestion(
                        question:
                            'Scroll up to see the batch separators showing where older message batches are loaded.',
                      ),
                      const ExampleQuestion(
                        question:
                            'Try different network speeds and toggle between auto and manual loading.',
                      ),
                      const ExampleQuestion(
                        question:
                            'Watch the scroll position indicator on the left side to see loading thresholds.',
                      ),
                    ],
                  ),
                  controller: _controller,
                  currentUser: _currentUser,
                  aiUser: _aiUser,
                  onSendMessage: (message) {
                    _handleSendMessage(message.text);
                  },
                ),

                // Scroll position indicator on the left edge
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: _buildScrollPositionIndicator(),
                ),

                // Debug stats panel
                if (_showDebugStats)
                  Positioned(
                    bottom: 80,
                    right: 8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildNetworkControls(),
                        const SizedBox(height: 8),
                        _buildDebugStats(),
                      ],
                    ),
                  ),

                // Add batch indicators using an overlay
                if (_controller.messages.isNotEmpty)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: ListView.builder(
                        controller: ScrollController(),
                        // Since we're showing batches from oldest to newest, reverse this list
                        reverse: true,
                        itemCount: _pageLoaded + 1, // Number of batches
                        itemBuilder: (context, index) {
                          // We want to show separators at the beginning of each batch except the first
                          if (index == 0)
                            return const SizedBox
                                .shrink(); // Skip for first/newest batch

                          return Align(
                            alignment: Alignment.topCenter,
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: 80.0 +
                                    (index *
                                        200.0), // Approximate position based on batch
                              ),
                              child: _buildBatchSeparator(index),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
