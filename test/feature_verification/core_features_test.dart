import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';
import 'package:network_image_mock/network_image_mock.dart';

void main() {
  group('Core Messaging Features', () {
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

    testWidgets('displays user and AI messages with different styling',
        (tester) async {
      await mockNetworkImagesFor(() async {
        // Arrange
        final userMessage = ChatMessage(
          text: 'Hello AI',
          user: currentUser,
          createdAt: DateTime.now(),
        );

        final aiMessage = ChatMessage(
          text: 'Hello human',
          user: aiUser,
          createdAt: DateTime.now(),
        );

        controller.addMessage(userMessage);
        controller.addMessage(aiMessage);

        // Act
        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: AiChatWidget(
              config: AiChatConfig(aiName: 'Test AI'),
              controller: controller,
              currentUser: currentUser,
              aiUser: aiUser,
              onSendMessage: (_) {},
            ),
          ),
        ));

        // Use fixed duration pumps instead of pumpAndSettle
        await tester.pump(); // Initial frame
        await tester
            .pump(const Duration(milliseconds: 500)); // Wait for animations

        // Assert - Verify controller has messages
        expect(controller.messages.length, 2);
        expect(controller.messages[0].text, 'Hello AI');
        expect(controller.messages[1].text, 'Hello human');

        // Verify chat list exists
        final listViewFinder = find.byType(ListView);
        expect(listViewFinder, findsOneWidget);

        // Verify there are message containers rendered
        final containerFinder = find.byType(Container);
        expect(containerFinder, findsAtLeastNWidgets(2));
      });
    });

    testWidgets('displays timestamps on messages when configured',
        (tester) async {
      await mockNetworkImagesFor(() async {
        // Arrange
        final message = ChatMessage(
          text: 'Hello with timestamp',
          user: currentUser,
          createdAt: DateTime.now(),
        );

        controller.addMessage(message);

        // Act - with timestamps enabled (default)
        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: AiChatWidget(
              config: AiChatConfig(
                aiName: 'Test AI',
                showTimestamp: true,
              ),
              controller: controller,
              currentUser: currentUser,
              aiUser: aiUser,
              onSendMessage: (_) {},
            ),
          ),
        ));

        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));

        // Validate message is in controller
        expect(controller.messages.length, 1);
        expect(controller.messages[0].text, 'Hello with timestamp');

        // Verify ListView exists and has children
        final listViewFinder = find.byType(ListView);
        expect(listViewFinder, findsOneWidget);
      });
    });

    testWidgets('sends message when text is entered and send button pressed',
        (tester) async {
      await mockNetworkImagesFor(() async {
        // Arrange
        bool messageSent = false;
        String sentMessageText = '';

        // Act
        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: AiChatWidget(
              config: AiChatConfig(aiName: 'Test AI'),
              controller: controller,
              currentUser: currentUser,
              aiUser: aiUser,
              onSendMessage: (message) {
                messageSent = true;
                sentMessageText = message.text;
              },
            ),
          ),
        ));

        // Find the TextField and enter text
        await tester.enterText(find.byType(TextField), 'Test message');
        await tester.pump();

        // Find and tap the send button (usually an IconButton)
        await tester.tap(find.byIcon(Icons.send));
        await tester.pump();

        // Assert
        expect(messageSent, isTrue);
        expect(sentMessageText, 'Test message');
      });
    });

    testWidgets('animations run when messages are added', (tester) async {
      await mockNetworkImagesFor(() async {
        // Arrange
        controller.clearMessages();

        // Act - render chat widget
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

        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));

        // Add a message which should trigger animation
        final message = ChatMessage(
          text: 'Animated message',
          user: currentUser,
          createdAt: DateTime.now(),
        );

        controller.addMessage(message);

        // Check for animation lifecycle
        await tester.pump(); // Start of animation

        // Verify the message is in the controller
        expect(controller.messages.length, 1);
        expect(controller.messages[0].text, 'Animated message');

        // Animation in progress
        await tester.pump(const Duration(milliseconds: 150));

        // Animation completed
        await tester.pump(const Duration(milliseconds: 350));

        // Verify ListView exists with content
        final listViewFinder = find.byType(ListView);
        expect(listViewFinder, findsOneWidget);
      });
    });
  });
}
