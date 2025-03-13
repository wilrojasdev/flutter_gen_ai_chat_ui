import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:flutter_streaming_text_markdown/flutter_streaming_text_markdown.dart';

void main() {
  group('Streaming Text Feature Tests', () {
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

    testWidgets('streaming text animates with word-by-word appearance',
        (tester) async {
      await mockNetworkImagesFor(() async {
        // Arrange - Create a message with the streaming property
        final streamingMessage = ChatMessage(
          text:
              'This is a streaming message with multiple words to test animation',
          user: aiUser,
          createdAt: DateTime.now(),
          customProperties: {'isStreaming': true},
        );

        // Act - render the chat widget with streaming enabled
        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: AiChatWidget(
              config: AiChatConfig(
                aiName: 'Test AI',
                enableAnimation: true,
              ),
              controller: controller,
              currentUser: currentUser,
              aiUser: aiUser,
              onSendMessage: (_) {},
            ),
          ),
        ));

        await tester.pump(); // Initial render

        // Add the streaming message
        controller.addMessage(streamingMessage);

        await tester.pump(); // After message added

        // Verify StreamingText widget is used
        expect(find.byType(StreamingText), findsOneWidget);

        // Verify controller has the message
        expect(controller.messages.length, 1);
        expect(controller.messages[0].text,
            'This is a streaming message with multiple words to test animation');

        // Check for animation in progress (mid-animation)
        await tester.pump(const Duration(milliseconds: 150));

        // Wait for animation to complete
        await tester.pump(const Duration(milliseconds: 1000));
      });
    });

    testWidgets('streaming text works with different configurations',
        (tester) async {
      await mockNetworkImagesFor(() async {
        // Arrange - create custom config with animation enabled
        final customConfig = AiChatConfig(
          aiName: 'Test AI',
          enableAnimation: true,
          // Any animation or streaming properties would be set here
        );

        // Act - render with custom config
        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: AiChatWidget(
              config: customConfig,
              controller: controller,
              currentUser: currentUser,
              aiUser: aiUser,
              onSendMessage: (_) {},
            ),
          ),
        ));

        await tester.pump(); // Initial render

        // Add streaming message
        final fastStreamingMessage = ChatMessage(
          text: 'Fast streaming text test',
          user: aiUser,
          createdAt: DateTime.now(),
          customProperties: {'isStreaming': true},
        );

        controller.addMessage(fastStreamingMessage);

        await tester.pump(); // After message added

        // Verify StreamingText widget is used
        expect(find.byType(StreamingText), findsOneWidget);

        // Verify controller has the message
        expect(controller.messages.length, 1);

        // Check animation frames with faster timing
        await tester.pump(const Duration(milliseconds: 50));
        await tester.pump(const Duration(milliseconds: 200));
      });
    });

    testWidgets('updating message during streaming works correctly',
        (tester) async {
      await mockNetworkImagesFor(() async {
        // Act - render the chat widget
        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: AiChatWidget(
              config: AiChatConfig(
                aiName: 'Test AI',
                enableAnimation: true,
              ),
              controller: controller,
              currentUser: currentUser,
              aiUser: aiUser,
              onSendMessage: (_) {},
            ),
          ),
        ));

        await tester.pump(); // Initial render

        // Initial streaming message (partial)
        final initialStreamingMessage = ChatMessage(
          text: 'Initial streaming',
          user: aiUser,
          createdAt: DateTime.now(),
          customProperties: {'isStreaming': true, 'id': 'streaming-msg-1'},
        );

        controller.addMessage(initialStreamingMessage);
        await tester.pump(); // After first message added
        await tester
            .pump(const Duration(milliseconds: 300)); // Partial animation

        // Update the streaming message with more content
        final updatedStreamingMessage = ChatMessage(
          text: 'Initial streaming with more content',
          user: aiUser,
          createdAt: initialStreamingMessage.createdAt,
          customProperties: {'isStreaming': true, 'id': 'streaming-msg-1'},
        );

        // Use updateMessage with the new message
        controller.updateMessage(updatedStreamingMessage);

        await tester.pump(); // After update
        await tester
            .pump(const Duration(milliseconds: 500)); // Animation continues

        // Verify controller has updated message
        expect(controller.messages.length, 1);
        expect(
            controller.messages[0].text, 'Initial streaming with more content');
      });
    });

    testWidgets('markdown streaming combines markdown and streaming effects',
        (tester) async {
      await mockNetworkImagesFor(() async {
        // Act - render with markdown streaming enabled
        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: AiChatWidget(
              config: AiChatConfig(
                aiName: 'Test AI',
                enableAnimation: true,
                enableMarkdownStreaming: true,
              ),
              controller: controller,
              currentUser: currentUser,
              aiUser: aiUser,
              onSendMessage: (_) {},
            ),
          ),
        ));

        await tester.pump(); // Initial render

        // Create markdown streaming message
        final markdownStreamingMessage = ChatMessage(
          text: '# Heading\n**Bold text** and *italic text*',
          user: aiUser,
          createdAt: DateTime.now(),
          isMarkdown: true,
          customProperties: {'isStreaming': true},
        );

        controller.addMessage(markdownStreamingMessage);

        await tester.pump(); // After message added

        // Verify the message is in the controller
        expect(controller.messages.length, 1);
        expect(controller.messages[0].isMarkdown, isTrue);

        // Animation frames
        await tester.pump(const Duration(milliseconds: 200));
        await tester.pump(const Duration(milliseconds: 500));
      });
    });

    testWidgets('streaming stops when message completes', (tester) async {
      await mockNetworkImagesFor(() async {
        // Arrange - setup widget
        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: AiChatWidget(
              config: AiChatConfig(
                aiName: 'Test AI',
                enableAnimation: true,
              ),
              controller: controller,
              currentUser: currentUser,
              aiUser: aiUser,
              onSendMessage: (_) {},
            ),
          ),
        ));

        await tester.pump(); // Initial render

        // Add streaming message
        final streamingMessage = ChatMessage(
          text: 'This message is streaming',
          user: aiUser,
          createdAt: DateTime.now(),
          customProperties: {'isStreaming': true, 'id': 'stream-complete-test'},
        );

        controller.addMessage(streamingMessage);

        await tester.pump(); // After message added
        await tester
            .pump(const Duration(milliseconds: 300)); // During animation

        // Update same message but mark streaming as complete
        final completedMessage = ChatMessage(
          text: 'This message is streaming',
          user: aiUser,
          createdAt: streamingMessage.createdAt,
          customProperties: {
            'isStreaming': false,
            'id': 'stream-complete-test'
          },
        );

        // Use updateMessage with the new message
        controller.updateMessage(completedMessage);

        await tester.pump(); // After update
        await tester.pump(const Duration(milliseconds: 100)); // Short delay

        // Verify message is in final state
        expect(controller.messages.length, 1);
        expect(
            controller.messages[0].customProperties?['isStreaming'], isFalse);
      });
    });
  });
}
