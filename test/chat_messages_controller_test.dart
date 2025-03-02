import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';

void main() {
  group('ChatMessagesController Pagination Tests', () {
    late ChatUser currentUser;
    late ChatUser aiUser;
    late List<ChatMessage> testMessages;

    setUp(() {
      currentUser = const ChatUser(id: 'user-1', name: 'Test User');
      aiUser = const ChatUser(id: 'ai-1', name: 'AI Assistant');

      // Create test messages with sequential timestamps (1 to 50)
      testMessages = List.generate(50, (index) {
        final isUser = index % 2 == 0;
        return ChatMessage(
          text: 'Message ${index + 1}',
          user: isUser ? currentUser : aiUser,
          createdAt:
              DateTime.now().subtract(Duration(minutes: (50 - index) * 5)),
          customProperties: {'id': 'msg-${index + 1}'},
        );
      });
    });

    test('loadMore adds messages in correct order (reverse mode)', () async {
      // Create controller with reverse pagination
      final controller = ChatMessagesController(
        paginationConfig: const PaginationConfig(
          enabled: true,
          messagesPerPage: 10,
          loadingDelay: Duration(milliseconds: 100),
          reverseOrder: true,
        ),
      );

      // Initial batch of messages (newest 10, messages 41-50)
      final initialBatch = testMessages.sublist(40, 50);
      controller.setMessages(initialBatch);
      expect(controller.messages.length, 10);
      expect(controller.messages.first.text, 'Message 50');
      expect(controller.messages.last.text, 'Message 41');

      // Load more (next 10 messages, 31-40)
      final nextBatch = testMessages.sublist(30, 40);
      await controller.loadMore(() async => nextBatch);

      // Should now have 20 messages, with correct ordering
      expect(controller.messages.length, 20);
      expect(controller.messages.first.text, 'Message 50');
      expect(controller.messages.last.text, 'Message 40');

      controller.dispose();
    });

    test('loadMore adds messages in correct order (chronological mode)',
        () async {
      // Create controller with chronological pagination
      final controller = ChatMessagesController(
        paginationConfig: const PaginationConfig(
          enabled: true,
          messagesPerPage: 10,
          loadingDelay: Duration(milliseconds: 100),
          reverseOrder: false,
        ),
      );

      // Initial batch of messages (oldest 10, messages 1-10)
      final initialBatch = testMessages.sublist(0, 10);
      controller.setMessages(initialBatch);
      expect(controller.messages.length, 10);
      expect(controller.messages.first.text, 'Message 1');
      expect(controller.messages.last.text, 'Message 10');

      // Load more (next 10 messages, 11-20)
      final nextBatch = testMessages.sublist(10, 20);
      await controller.loadMore(() async => nextBatch);

      // Should now have 20 messages, with correct ordering
      expect(controller.messages.length, 20);
      expect(controller.messages.first.text, 'Message 1');
      expect(controller.messages.last.text, 'Message 20');

      controller.dispose();
    });

    test('hasMoreMessages flag updates correctly', () async {
      final controller = ChatMessagesController(
        paginationConfig: const PaginationConfig(
          enabled: true,
          messagesPerPage: 10,
        ),
      );

      // Initial state
      expect(controller.hasMoreMessages, true);

      // Add initial messages
      controller.setMessages(testMessages.take(10).toList());

      // Load more with empty result
      await controller.loadMore(() async => []);
      expect(controller.hasMoreMessages, false);

      // Reset pagination
      controller.resetPagination();
      expect(controller.hasMoreMessages, true);

      controller.dispose();
    });

    test('isLoadingMore flag updates correctly during loadMore', () async {
      final controller = ChatMessagesController(
        paginationConfig: const PaginationConfig(
          enabled: true,
          messagesPerPage: 10,
          loadingDelay: Duration(milliseconds: 50),
        ),
      );

      // Initial state
      expect(controller.isLoadingMore, false);

      // Start loading
      final loadFuture = controller.loadMore(() async {
        // Check that isLoadingMore is true during loading
        expect(controller.isLoadingMore, true);
        return testMessages.take(5).toList();
      });

      // Wait a moment to ensure loading state is set
      await Future.delayed(const Duration(milliseconds: 10));
      expect(controller.isLoadingMore, true);

      // Wait for loading to complete
      await loadFuture;
      expect(controller.isLoadingMore, false);

      controller.dispose();
    });

    test('currentPage updates correctly when loading more messages', () async {
      final controller = ChatMessagesController(
        paginationConfig: const PaginationConfig(
          enabled: true,
          messagesPerPage: 10,
        ),
      );

      // Initial page
      expect(controller.currentPage, 1);

      // Load more
      await controller.loadMore(() async => testMessages.take(5).toList());
      expect(controller.currentPage, 2);

      // Load more again
      await controller
          .loadMore(() async => testMessages.skip(5).take(5).toList());
      expect(controller.currentPage, 3);

      // Reset pagination
      controller.resetPagination();
      expect(controller.currentPage, 1);

      controller.dispose();
    });

    test('loadMore does nothing when pagination is disabled', () async {
      final controller = ChatMessagesController(
        paginationConfig: const PaginationConfig(
          enabled: false,
          messagesPerPage: 10,
        ),
      );

      controller.setMessages(testMessages.take(5).toList());
      expect(controller.messages.length, 5);

      bool callbackCalled = false;
      await controller.loadMore(() async {
        callbackCalled = true;
        return testMessages.skip(5).take(5).toList();
      });

      // Callback should not be called and message count shouldn't change
      expect(callbackCalled, false);
      expect(controller.messages.length, 5);

      controller.dispose();
    });

    test('loadMore handles errors correctly', () async {
      final controller = ChatMessagesController(
        paginationConfig: const PaginationConfig(
          enabled: true,
          messagesPerPage: 10,
        ),
      );

      // Initial state
      expect(controller.isLoadingMore, false);
      expect(controller.hasMoreMessages, true);

      // Trigger error during loading
      try {
        await controller.loadMore(() async => throw Exception('Test error'));
        fail('Exception should be propagated');
      } catch (e) {
        // Exception should be propagated
        expect(e.toString(), contains('Test error'));
      }

      // Should reset loading state but keep hasMoreMessages true to allow retry
      expect(controller.isLoadingMore, false);
      expect(controller.hasMoreMessages, true);

      controller.dispose();
    });

    test('loadMore does nothing when already loading', () async {
      final controller = ChatMessagesController(
        paginationConfig: const PaginationConfig(
          enabled: true,
          messagesPerPage: 10,
          loadingDelay: Duration(milliseconds: 100),
        ),
      );

      // Start first loading operation
      int callCount = 0;
      final firstLoad = controller.loadMore(() async {
        callCount++;
        await Future.delayed(const Duration(milliseconds: 200));
        return testMessages.take(5).toList();
      });

      // Try to start second loading while first is in progress
      await controller.loadMore(() async {
        callCount++;
        return testMessages.skip(5).take(5).toList();
      });

      // Wait for first operation to complete
      await firstLoad;

      // Callback should only be called once
      expect(callCount, 1);

      controller.dispose();
    });

    test('loadMore does nothing when no more messages', () async {
      final controller = ChatMessagesController(
        paginationConfig: const PaginationConfig(
          enabled: true,
          messagesPerPage: 10,
        ),
      );

      // Set hasMoreMessages to false
      await controller.loadMore(() async => []);
      expect(controller.hasMoreMessages, false);

      // Try to load more
      bool callbackCalled = false;
      await controller.loadMore(() async {
        callbackCalled = true;
        return testMessages.take(5).toList();
      });

      // Callback should not be called
      expect(callbackCalled, false);

      controller.dispose();
    });
  });
}
