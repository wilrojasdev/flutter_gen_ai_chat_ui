import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';

void main() {
  group('Pagination Controller Tests', () {
    late List<ChatMessage> testMessages;
    late ChatUser currentUser;
    late ChatUser aiUser;

    setUp(() {
      currentUser = const ChatUser(id: 'user-1', name: 'Test User');
      aiUser = const ChatUser(id: 'ai-1', name: 'AI Assistant');

      // Create 30 test messages
      testMessages = List.generate(30, (index) {
        final isUser = index % 2 == 0;
        return ChatMessage(
          text: 'Message ${30 - index}',
          user: isUser ? currentUser : aiUser,
          createdAt: DateTime.now().subtract(Duration(minutes: index * 5)),
        );
      });
    });

    test('Controller handles loading more messages correctly', () async {
      final initialMessages = testMessages.sublist(0, 10);
      final messagesSlice10To20 = testMessages.sublist(10, 20);

      // Create a controller with test data
      final controller = ChatMessagesController(
        initialMessages: initialMessages,
        paginationConfig: const PaginationConfig(
          enabled: true,
          messagesPerPage: 10,
          loadingDelay: Duration(milliseconds: 300),
          reverseOrder: true,
        ),
      );

      // Verify initial state
      expect(controller.messages.length, 10);
      expect(controller.messages.first.text, 'Message 30');
      expect(controller.messages.last.text, 'Message 21');

      // Simulate loading more messages
      await controller.loadMore(() async {
        // Simulate network delay
        await Future.delayed(const Duration(milliseconds: 300));
        return messagesSlice10To20;
      });

      // Verify updated state after loading more
      expect(controller.messages.length, 20);
      expect(controller.messages.first.text, 'Message 30');
      expect(controller.messages.last.text, 'Message 11');
    });

    test('Controller updates loading state correctly', () async {
      final controller = ChatMessagesController(
        paginationConfig: const PaginationConfig(
          enabled: true,
          loadingDelay: Duration(milliseconds: 100),
        ),
      );

      // Verify initial state
      expect(controller.isLoadingMore, false);
      expect(controller.hasMoreMessages, true);

      // Start loading more but don't await
      final loadingFuture = controller.loadMore(() async {
        await Future.delayed(const Duration(milliseconds: 200));
        return [
          ChatMessage(
            text: 'Test message',
            user: currentUser,
            createdAt: DateTime.now(),
          )
        ];
      });

      // Verify loading state during load
      expect(controller.isLoadingMore, true);

      // Complete loading
      await loadingFuture;

      // Verify final state
      expect(controller.isLoadingMore, false);
      expect(controller.messages.length, 1);
    });

    test('Controller updates hasMoreMessages flag correctly', () async {
      final controller = ChatMessagesController(
        paginationConfig: const PaginationConfig(enabled: true),
      );

      // Initially has more messages
      expect(controller.hasMoreMessages, true);

      // Load with empty result
      await controller.loadMore(() async => []);

      // Should now indicate no more messages
      expect(controller.hasMoreMessages, false);
    });
  });
}
