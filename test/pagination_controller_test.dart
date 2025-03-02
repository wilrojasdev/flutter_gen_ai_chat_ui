import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';

void main() {
  group('Pagination Controller Integration Tests', () {
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

    test('Controller loads more messages correctly in reverse mode', () async {
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

    test('Controller loads more messages correctly in chronological mode',
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

    test('Controller handles multiple load more operations correctly',
        () async {
      // Create controller with reverse pagination
      final controller = ChatMessagesController(
        paginationConfig: const PaginationConfig(
          enabled: true,
          messagesPerPage: 10,
          loadingDelay: Duration(milliseconds: 100),
          reverseOrder: true,
        ),
      );

      // Initial batch of messages (newest 10)
      controller.setMessages(testMessages.sublist(40, 50));
      expect(controller.messages.length, 10);

      // First load more
      await controller.loadMore(() async => testMessages.sublist(30, 40));
      expect(controller.messages.length, 20);

      // Second load more
      await controller.loadMore(() async => testMessages.sublist(20, 30));
      expect(controller.messages.length, 30);

      // Third load more
      await controller.loadMore(() async => testMessages.sublist(10, 20));
      expect(controller.messages.length, 40);

      // Verify ordering is maintained
      expect(controller.messages.first.text, 'Message 50');
      expect(controller.messages.last.text, 'Message 20');

      controller.dispose();
    });
  });
}
