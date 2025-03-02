import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';

void main() {
  group('ChatMessagesController Streaming Tests', () {
    test('handles streaming messages correctly', () {
      // Create controller and users
      final controller = ChatMessagesController();
      final currentUser = ChatUser(id: 'user1', name: 'User');
      final aiUser = ChatUser(id: 'ai', name: 'AI Assistant');

      // Initial text and streamed text
      final initialText = 'Initial message';
      final streamedText = 'Initial message with streamed content';

      // Add initial streaming message
      controller.addMessage(
        ChatMessage(
          user: aiUser,
          text: initialText,
          createdAt: DateTime.now(),
          isMarkdown: false,
          customProperties: {'isStreaming': true, 'id': 'msg1'},
        ),
      );

      // Verify initial state
      expect(controller.messages.length, 1);
      expect(controller.messages.first.text, initialText);
      expect(controller.messages.first.customProperties?['isStreaming'], true);

      // Update with streamed content
      controller.updateMessage(
        ChatMessage(
          user: aiUser,
          text: streamedText,
          createdAt: DateTime.now(),
          isMarkdown: false,
          customProperties: {'isStreaming': true, 'id': 'msg1'},
        ),
      );

      // Verify updated state
      expect(controller.messages.length, 1);
      expect(controller.messages.first.text, streamedText);
      expect(controller.messages.first.customProperties?['isStreaming'], true);

      // Complete streaming
      controller.updateMessage(
        ChatMessage(
          user: aiUser,
          text: streamedText,
          createdAt: DateTime.now(),
          isMarkdown: false,
          customProperties: {'isStreaming': false, 'id': 'msg1'},
        ),
      );

      // Verify final state
      expect(controller.messages.length, 1);
      expect(controller.messages.first.text, streamedText);
      expect(controller.messages.first.customProperties?['isStreaming'], false);
    });

    test('message streaming state management', () {
      // Create controller and users
      final controller = ChatMessagesController();
      final aiUser = ChatUser(id: 'ai', name: 'AI Assistant');

      // Add streaming message
      controller.addMessage(
        ChatMessage(
          user: aiUser,
          text: 'Streaming message',
          createdAt: DateTime.now(),
          isMarkdown: false,
          customProperties: {'isStreaming': true, 'id': 'msg1'},
        ),
      );

      // Verify initial streaming state
      expect(controller.messages.first.customProperties?['isStreaming'], true);

      // Update message to complete streaming
      controller.updateMessage(
        ChatMessage(
          user: aiUser,
          text: 'Streaming message completed',
          createdAt: DateTime.now(),
          isMarkdown: false,
          customProperties: {'isStreaming': false, 'id': 'msg1'},
        ),
      );

      // Verify streaming state is now false
      expect(controller.messages.first.customProperties?['isStreaming'], false);
    });
  });
}
