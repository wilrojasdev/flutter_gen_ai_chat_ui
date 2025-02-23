import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';

void main() {
  late ChatMessagesController controller;
  late ChatUser testUser;
  late ChatUser aiUser;

  setUp(() {
    controller = ChatMessagesController();
    testUser = const ChatUser(id: 'user', name: 'Test User');
    aiUser = const ChatUser(id: 'ai', name: 'AI Assistant');
  });

  tearDown(() {
    controller.dispose();
  });

  group('ChatMessagesController Message Management', () {
    test('initializes with empty message list', () {
      expect(controller.messages, isEmpty);
      expect(controller.showWelcomeMessage, isTrue);
    });

    test('adds message correctly', () {
      final message = ChatMessage(
        text: 'Test message',
        user: testUser,
        createdAt: DateTime.now(),
      );
      controller.addMessage(message);

      expect(controller.messages.length, 1);
      expect(controller.messages.first.text, 'Test message');
    });

    test('prevents duplicate messages', () {
      final message = ChatMessage(
        text: 'Test message',
        user: testUser,
        createdAt: DateTime.now(),
        customProperties: {'id': 'test_id'},
      );

      controller.addMessage(message);
      controller.addMessage(message);

      expect(controller.messages.length, 1);
    });

    test('updates existing message', () {
      final originalMessage = ChatMessage(
        text: 'Original text',
        user: testUser,
        createdAt: DateTime.now(),
        customProperties: {'id': 'test_id'},
      );

      final updatedMessage = ChatMessage(
        text: 'Updated text',
        user: testUser,
        createdAt: DateTime.now(),
        customProperties: {'id': 'test_id'},
      );

      controller.addMessage(originalMessage);
      controller.updateMessage(updatedMessage);

      expect(controller.messages.length, 1);
      expect(controller.messages.first.text, 'Updated text');
    });

    test('clears messages correctly', () {
      controller.addMessage(ChatMessage(
        text: 'Test message',
        user: testUser,
        createdAt: DateTime.now(),
      ));

      controller.clearMessages();

      expect(controller.messages, isEmpty);
    });
  });

  group('ChatMessagesController Pagination', () {
    test('handles load more correctly', () async {
      final messages = List.generate(
        5,
        (i) => ChatMessage(
          text: 'Message $i',
          user: testUser,
          createdAt: DateTime.now(),
        ),
      );

      controller = ChatMessagesController(
        onLoadMoreMessages: (lastMessage) async => messages,
      );

      await controller.loadMore();

      expect(controller.messages.length, 5);
      expect(controller.isLoadingMore, isFalse);
    });

    test('handles empty load more response', () async {
      controller = ChatMessagesController(
        onLoadMoreMessages: (lastMessage) async => [],
      );

      await controller.loadMore();

      expect(controller.messages, isEmpty);
      expect(controller.hasMoreMessages, isFalse);
    });

    test('prevents concurrent load more calls', () async {
      int callCount = 0;
      controller = ChatMessagesController(
        onLoadMoreMessages: (lastMessage) async {
          callCount++;
          await Future.delayed(const Duration(milliseconds: 100));
          return [];
        },
      );

      // Attempt multiple concurrent loads
      final futures = List.generate(3, (_) => controller.loadMore());
      await Future.wait(futures);

      expect(callCount, 1);
    });

    test('handles load more errors gracefully', () async {
      final controller = ChatMessagesController(
        onLoadMoreMessages: (lastMessage) async {
          throw Exception('Test error');
        },
      );

      // Trigger load more
      try {
        await controller.loadMore();
        fail('Should throw an exception');
      } catch (e) {
        expect(e, isA<Exception>());
        expect(e.toString(), contains('Test error'));
      }

      // Verify controller state
      expect(controller.isLoadingMore, false);
      expect(controller.hasMoreMessages, true);
    });
  });

  group('ChatMessagesController Welcome Message', () {
    test('hides welcome message correctly', () {
      expect(controller.showWelcomeMessage, isTrue);

      controller.hideWelcomeMessage();

      expect(controller.showWelcomeMessage, isFalse);
    });

    test('handles example questions correctly', () {
      controller.handleExampleQuestion(
        'Test question',
        testUser,
        aiUser,
      );

      expect(controller.showWelcomeMessage, isFalse);
      expect(controller.messages.length, 1);
      expect(controller.messages.first.text, 'Test question');
    });
  });

  group('ChatMessagesController Error Handling', () {
    test('handles null onLoadMoreMessages', () async {
      controller = ChatMessagesController();
      await controller.loadMore();

      expect(controller.messages, isEmpty);
      expect(controller.isLoadingMore, isFalse);
    });

    test('handles load more errors gracefully', () async {
      controller = ChatMessagesController(
        onLoadMoreMessages: (lastMessage) async =>
            throw Exception('Test error'),
      );

      await controller.loadMore();

      expect(controller.messages, isEmpty);
      expect(controller.isLoadingMore, isFalse);
    });
  });
}
