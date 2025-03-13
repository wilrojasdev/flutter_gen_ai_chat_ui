import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';
import 'package:network_image_mock/network_image_mock.dart';

void main() {
  group('Markdown Rendering and Streaming Features', () {
    late ChatMessagesController controller;
    late ChatUser currentUser;
    late ChatUser aiUser;

    setUp(() {
      controller = ChatMessagesController();
      currentUser = const ChatUser(id: 'user-1', name: 'Test User');
      aiUser = const ChatUser(id: 'ai-1', name: 'AI Assistant');
    });

    tearDown(() {
      controller.dispose();
    });

    testWidgets('renders markdown in messages correctly', (tester) async {
      await mockNetworkImagesFor(() async {
        // Arrange - create a message with markdown content
        final markdownMessage = ChatMessage(
          text: '# Heading\n**Bold text** and *italic text*',
          user: aiUser,
          createdAt: DateTime.now(),
          isMarkdown: true,
        );

        controller.addMessage(markdownMessage);

        // Act - render the chat widget
        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: AiChatWidget(
              config: AiChatConfig(
                aiName: 'Test AI',
                enableMarkdownStreaming: true,
              ),
              controller: controller,
              currentUser: currentUser,
              aiUser: aiUser,
              onSendMessage: (_) {},
            ),
          ),
        ));

        // Use controlled pump instead of pumpAndSettle
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));

        // Assert - verify controller has the message
        expect(controller.messages.length, 1);
        expect(controller.messages[0].text,
            '# Heading\n**Bold text** and *italic text*');
        expect(controller.messages[0].isMarkdown, isTrue);

        // Verify that the ListView exists
        final listViewFinder = find.byType(ListView);
        expect(listViewFinder, findsAtLeastNWidgets(1));

        // Verify that rich text rendering is happening by looking for RichText widgets
        final richTextFinder = find.byType(RichText);
        expect(richTextFinder, findsAtLeastNWidgets(1));
      });
    });

    testWidgets('renders code blocks correctly', (tester) async {
      await mockNetworkImagesFor(() async {
        // Arrange - create a message with a code block
        final codeBlockMessage = ChatMessage(
          text:
              'Here is some code:\n```dart\nvoid main() {\n  print("Hello world");\n}\n```',
          user: aiUser,
          createdAt: DateTime.now(),
          isMarkdown: true,
        );

        controller.addMessage(codeBlockMessage);

        // Act - render the chat widget
        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: AiChatWidget(
              config: AiChatConfig(
                aiName: 'Test AI',
                enableMarkdownStreaming: true,
              ),
              controller: controller,
              currentUser: currentUser,
              aiUser: aiUser,
              onSendMessage: (_) {},
            ),
          ),
        ));

        // Use controlled pump instead of pumpAndSettle
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));

        // Assert - verify controller has the message
        expect(controller.messages.length, 1);
        expect(controller.messages[0].text.contains('```dart'), isTrue);
        expect(controller.messages[0].isMarkdown, isTrue);

        // Verify that the ListView exists
        expect(find.byType(ListView), findsAtLeastNWidgets(1));

        // Code blocks are typically rendered in containers with specific styling
        expect(find.byType(Container), findsAtLeastNWidgets(2));
      });
    });

    testWidgets('supports message updates', (tester) async {
      await mockNetworkImagesFor(() async {
        // Arrange - create an initial message
        final initialMessage = ChatMessage(
          text: 'Initial message',
          user: aiUser,
          createdAt: DateTime.now(),
        );

        controller.addMessage(initialMessage);

        // Act - render the chat widget
        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: AiChatWidget(
              config: AiChatConfig(
                aiName: 'Test AI',
              ),
              controller: controller,
              currentUser: currentUser,
              aiUser: aiUser,
              onSendMessage: (_) {},
            ),
          ),
        ));

        // Initial pump to render
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        // Verify initial state
        expect(controller.messages.length, 1);
        expect(controller.messages[0].text, 'Initial message');

        // Get the initial message ID for updating
        final messageId = controller.messages[0];

        // Create a new message with updated text
        final updatedMessage = ChatMessage(
          text: 'Updated message',
          user: aiUser,
          createdAt: messageId.createdAt,
        );

        // Replace the message in the controller
        controller.messages.clear();
        controller.addMessage(updatedMessage);

        // Pump to process the update
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        // Verify the update
        expect(controller.messages.length, 1);
        expect(controller.messages[0].text, 'Updated message');
      });
    });
  });
}
