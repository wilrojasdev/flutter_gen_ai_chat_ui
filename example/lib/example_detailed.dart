import 'package:flutter/material.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';
import 'package:dash_chat_2/dash_chat_2.dart'; // Add this import
import 'package:provider/provider.dart'; // Add this import

class ExampleDetailed extends StatefulWidget {
  const ExampleDetailed({super.key});

  @override
  State<ExampleDetailed> createState() => _ExampleDetailedState();
}

// Advanced example showcasing all major features including themes, pagination, and customization
class _ExampleDetailedState extends State<ExampleDetailed> {
  static const int _pageSize = 20; // Number of messages to load per page
  late final ChatMessagesController messagesController;
  late final List<ChatExample> exampleQuestions;
  late final ChatUser _currentUser;
  late final ChatUser _aiUser;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize chat participants
    _currentUser = ChatUser(id: '1', firstName: 'User');
    _aiUser = ChatUser(id: '2', firstName: 'AI Assistant');

    // Create sample historical messages
    final initialMessages = [
      ChatMessage(
        text: "Welcome back! Your last session was about Flutter development.",
        user: _aiUser,
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
      ),
      ChatMessage(
        text: "Can you help me with state management?",
        user: _currentUser,
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
      ),
      ChatMessage(
        text: "Here's a summary of different state management solutions...",
        user: _aiUser,
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
      ),
      // Add more messages as needed
    ];

    // Initialize controller with pagination support
    messagesController = ChatMessagesController(
      initialMessages: initialMessages,
      onLoadMoreMessages: _loadMoreMessages, // Enable pagination
    );
    exampleQuestions = _createExampleQuestions();
  }

  // Simulated API pagination - Replace with actual backend integration
  Future<List<ChatMessage>> _loadMoreMessages(ChatMessage? lastMessage) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      // Simulate cursor-based pagination using message dates
      final lastMessageDate = lastMessage?.createdAt ?? DateTime.now();

      // Return mock historical messages
      // In production, replace with actual API call:
      // final response = await http.get(
      //   Uri.parse('your-api-url/messages').replace(
      //     queryParameters: {
      //       'cursor': lastMessage?.createdAt.toIso8601String(),
      //       'limit': '$_pageSize',
      //     },
      //   ),
      // );
      return [
        ChatMessage(
          text: "This is an older message from API",
          user: _aiUser,
          createdAt: lastMessageDate.subtract(const Duration(days: 1)),
        ),
        ChatMessage(
          text: "Another historical message",
          user: _currentUser,
          createdAt:
              lastMessageDate.subtract(const Duration(days: 1, hours: 2)),
        ),
        ChatMessage(
          text: "Some more history...",
          user: _aiUser,
          createdAt: lastMessageDate.subtract(const Duration(days: 2)),
        ),
      ];
    } catch (e) {
      debugPrint('Error loading more messages: $e');
      return [];
    }
  }

  Future<void> _handleSendMessage(ChatMessage message) async {
    // Fixed typo from ChatMesseage to ChatMessage
    setState(() => _isLoading = true);
    messagesController.addMessage(message);

    try {
      // Simulate AI response
      await Future.delayed(const Duration(seconds: 1));
      final response = "Response to: ${message.text}";

      final aiMessage = ChatMessage(
        text: response,
        user: _aiUser,
        createdAt: DateTime.now(),
      );

      messagesController.addMessage(aiMessage);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  List<ChatExample> _createExampleQuestions() {
    return [
      ChatExample(
        question: 'What is the weather like today?',
        onTap: (controller) => controller.handleExampleQuestion(
          'What is the weather like today?',
          _currentUser,
          _aiUser,
        ),
      ),
      ChatExample(
        question: 'Tell me a joke.',
        onTap: (controller) => controller.handleExampleQuestion(
          'Tell me a joke.',
          _currentUser,
          _aiUser,
        ),
      ),
    ];
  }

  Widget _buildWelcomeMessage(BuildContext context, List<ChatExample> examples,
      ChatMessagesController controller) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        final isDarkMode = themeProvider.isDark;
        return Container(
          margin: const EdgeInsets.all(16.0),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey[900] : Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: isDarkMode ? Colors.black38 : Colors.black12,
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
              for (var example in examples)
                GestureDetector(
                  onTap: () => example.onTap(controller),
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 12.0,
                    ),
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.grey[800] : Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      example.question,
                      style: TextStyle(
                        color: isDarkMode ? Colors.blue[100] : Colors.blue[700],
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          final isDarkMode = themeProvider.isDark;
          final size = MediaQuery.of(context).size;
          final isTablet = size.width > 600;
          final isDesktop = size.width > 1200;

          // Configure DashChat input customization
          final inputOptions = InputOptions(
            sendOnEnter: true,
            alwaysShowSend: true,
            inputTextStyle: const TextStyle(fontSize: 16),
            inputDecoration: InputDecoration(
              hintText: 'Type a message...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );

          // Configure message appearance
          final messageOptions = MessageOptions(
            showTime: true,
            avatarBuilder: (user, onPressAvatar, onLongPressAvatar) =>
                CircleAvatar(
              child: Text(user.firstName?[0] ?? ''),
            ),
            messagePadding: const EdgeInsets.all(12),
            containerColor: Colors.blue.shade100,
            textColor: Colors.black,
          );

          // Configure message list and pagination
          final messageListOptions = MessageListOptions(
            showDateSeparator: true,
            separatorFrequency: SeparatorFrequency.days,
            scrollPhysics: const BouncingScrollPhysics(),
            onLoadEarlier: () => messagesController.loadMore(),
            loadEarlierBuilder: const SizedBox(
              height: 40,
              width: 40,
              child: CircularProgressIndicator(),
            ),
          );

          return Theme(
            data: themeProvider.theme,
            child: Scaffold(
              appBar: AppBar(
                title: const Text('AI Chat'),
                elevation: 0,
                surfaceTintColor: Colors.transparent,
                actions: [
                  IconButton(
                    icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
                    onPressed: () {
                      themeProvider.toggleTheme();
                    },
                  ),
                ],
              ),
              body: Center(
                child: AiChatWidget(
                  config: AiChatConfig(
                    // Basic configuration
                    userName: 'User',
                    aiName: 'AI Assistant',

                    // Responsive layout
                    maxWidth: isDesktop ? 900 : (isTablet ? 700 : null),

                    // Features configuration
                    enableAnimation: true,
                    showTimestamp: true,
                    exampleQuestions: exampleQuestions,

                    // DashChat customization
                    inputOptions: inputOptions,
                    messageOptions: messageOptions,
                    messageListOptions: messageListOptions,

                    // Pagination setup
                    enablePagination: true,
                    paginationLoadingIndicatorOffset: 100,
                    loadMoreIndicator: (bool isLoading) => const SizedBox(
                      height: 40,
                      width: 40,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  currentUser: _currentUser,
                  aiUser: _aiUser,
                  controller: messagesController,
                  onSendMessage: _handleSendMessage,
                  isLoading: _isLoading,
                  welcomeMessageBuilder: () => _buildWelcomeMessage(
                    context,
                    exampleQuestions,
                    messagesController,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    messagesController.dispose();
    super.dispose();
  }
}
