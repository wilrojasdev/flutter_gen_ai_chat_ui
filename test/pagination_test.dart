import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';
import 'package:network_image_mock/network_image_mock.dart';

void main() {
  group('Chat UI Pagination Tests', () {
    late ChatMessagesController controller;
    late List<ChatMessage> mockMessages;
    late ChatUser currentUser;
    late ChatUser aiUser;

    setUp(() {
      // Set up test users
      currentUser = const ChatUser(id: 'user-1', name: 'Test User');
      aiUser = const ChatUser(id: 'ai-1', name: 'AI Assistant');

      // Generate mock messages
      mockMessages = List.generate(50, (index) {
        final isUser = index % 2 == 0;
        return ChatMessage(
          text: 'Test message ${50 - index}',
          user: isUser ? currentUser : aiUser,
          createdAt: DateTime.now().subtract(Duration(minutes: index * 5)),
          customProperties: {'id': 'msg-${50 - index}'},
        );
      });

      // Initialize controller with pagination config
      controller = ChatMessagesController(
        paginationConfig: const PaginationConfig(
          enabled: true,
          messagesPerPage: 10,
          loadingDelay: Duration(milliseconds: 100), // Faster for tests
          scrollThreshold: 0.8,
          reverseOrder: true,
        ),
      );
    });

    tearDown(() {
      controller.dispose();
    });

    testWidgets('Initial messages are displayed correctly',
        (WidgetTester tester) async {
      // Add first batch of messages
      final initialMessages = mockMessages.take(10).toList();
      controller.setMessages(initialMessages);

      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: AiChatWidget(
              config: AiChatConfig(
                aiName: 'Test AI',
                messageListOptions: MessageListOptions(
                  hasMoreMessages: true,
                  isLoadingMore: false,
                  paginationConfig: const PaginationConfig(
                    enabled: true,
                    reverseOrder: true,
                  ),
                ),
              ),
              controller: controller,
              currentUser: currentUser,
              aiUser: aiUser,
              onSendMessage: (_) {},
            ),
          ),
        ));

        await tester.pumpAndSettle();

        // Verify initial messages are displayed
        for (var i = 0; i < initialMessages.length; i++) {
          expect(find.text('Test message ${50 - i}'), findsOneWidget);
        }
      });
    });

    testWidgets('Loading indicator is shown when loading more messages',
        (WidgetTester tester) async {
      // Add first batch of messages
      controller.setMessages(mockMessages.take(10).toList());

      bool loadMoreCalled = false;

      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: AiChatWidget(
              config: AiChatConfig(
                aiName: 'Test AI',
                messageListOptions: MessageListOptions(
                  hasMoreMessages: true,
                  isLoadingMore: true, // Set loading state to true
                  paginationConfig: const PaginationConfig(
                    enabled: true,
                    reverseOrder: true,
                    loadingText: 'Loading more messages...',
                  ),
                  onLoadMore: () async {
                    loadMoreCalled = true;
                  },
                ),
              ),
              controller: controller,
              currentUser: currentUser,
              aiUser: aiUser,
              onSendMessage: (_) {},
            ),
          ),
        ));

        await tester.pumpAndSettle();

        // Verify loading indicator is shown
        expect(find.text('Loading more messages...'), findsOneWidget);
      });
    });

    testWidgets(
        'No more messages indicator is shown when hasMoreMessages is false',
        (WidgetTester tester) async {
      // Add messages
      controller.setMessages(mockMessages.take(10).toList());

      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: AiChatWidget(
              config: AiChatConfig(
                aiName: 'Test AI',
                messageListOptions: MessageListOptions(
                  hasMoreMessages: false, // No more messages
                  isLoadingMore: false,
                  paginationConfig: const PaginationConfig(
                    enabled: true,
                    reverseOrder: true,
                    noMoreMessagesText: 'No more messages',
                  ),
                ),
              ),
              controller: controller,
              currentUser: currentUser,
              aiUser: aiUser,
              onSendMessage: (_) {},
            ),
          ),
        ));

        await tester.pumpAndSettle();

        // Verify no more messages indicator is shown
        expect(find.text('No more messages'), findsOneWidget);
      });
    });

    testWidgets('Order of messages is correct in reverse mode',
        (WidgetTester tester) async {
      // Add messages in reverse order (newest first)
      controller.setMessages(mockMessages.take(10).toList());

      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: AiChatWidget(
              config: AiChatConfig(
                aiName: 'Test AI',
                messageListOptions: MessageListOptions(
                  paginationConfig: const PaginationConfig(
                    enabled: true,
                    reverseOrder: true, // Newest messages first
                  ),
                ),
              ),
              controller: controller,
              currentUser: currentUser,
              aiUser: aiUser,
              onSendMessage: (_) {},
            ),
          ),
        ));

        await tester.pumpAndSettle();

        // Get positions of message widgets to verify order
        final pos41 = tester.getCenter(find.text('Test message 41'));
        final pos42 = tester.getCenter(find.text('Test message 42'));
        final pos43 = tester.getCenter(find.text('Test message 43'));

        // In reverse mode, newer messages (higher numbers) should be higher on screen (lower y value)
        expect(pos41.dy, greaterThan(pos42.dy));
        expect(pos42.dy, greaterThan(pos43.dy));
      });
    });

    testWidgets('Order of messages is correct in chronological mode',
        (WidgetTester tester) async {
      // Add messages in chronological order (oldest first)
      final chronologicalMessages =
          mockMessages.take(10).toList().reversed.toList();

      // Use non-reverse pagination
      controller = ChatMessagesController(
        paginationConfig: const PaginationConfig(
          enabled: true,
          messagesPerPage: 10,
          reverseOrder: false, // Oldest messages first
        ),
      );
      controller.setMessages(chronologicalMessages);

      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: AiChatWidget(
              config: AiChatConfig(
                aiName: 'Test AI',
                messageListOptions: MessageListOptions(
                  paginationConfig: const PaginationConfig(
                    enabled: true,
                    reverseOrder: false, // Oldest messages first
                  ),
                ),
              ),
              controller: controller,
              currentUser: currentUser,
              aiUser: aiUser,
              onSendMessage: (_) {},
            ),
          ),
        ));

        await tester.pumpAndSettle();

        // Get positions of message widgets to verify order
        final pos41 = tester.getCenter(find.text('Test message 41'));
        final pos42 = tester.getCenter(find.text('Test message 42'));
        final pos43 = tester.getCenter(find.text('Test message 43'));

        // In chronological mode, older messages (lower numbers) should be higher on screen (lower y value)
        expect(pos41.dy, lessThan(pos42.dy));
        expect(pos42.dy, lessThan(pos43.dy));
      });
    });

    testWidgets('LoadMore callback is triggered when scrolling to threshold',
        (WidgetTester tester) async {
      // Add more messages to enable scrolling
      controller.setMessages(mockMessages.take(20).toList());

      bool loadMoreCalled = false;

      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: AiChatWidget(
              config: AiChatConfig(
                aiName: 'Test AI',
                messageListOptions: MessageListOptions(
                  hasMoreMessages: true,
                  isLoadingMore: false,
                  paginationConfig: const PaginationConfig(
                    enabled: true,
                    reverseOrder: true,
                    autoLoadOnScroll: true,
                    scrollThreshold: 0.9,
                  ),
                  onLoadMore: () async {
                    loadMoreCalled = true;
                  },
                ),
              ),
              controller: controller,
              currentUser: currentUser,
              aiUser: aiUser,
              onSendMessage: (_) {},
            ),
          ),
        ));

        await tester.pumpAndSettle();

        // Scroll to near the end to trigger load more
        await tester.dragFrom(
            tester.getCenter(find.byType(AiChatWidget)), const Offset(0, -500));
        await tester.pumpAndSettle(const Duration(seconds: 1));

        // Verify the loadMore callback was called
        expect(loadMoreCalled, isTrue);
      });
    });
  });
}
