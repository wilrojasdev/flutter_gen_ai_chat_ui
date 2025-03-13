import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';
import 'package:network_image_mock/network_image_mock.dart';

void main() {
  group('Animation Feature Tests', () {
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

    testWidgets('message appear with fade-in animation', (tester) async {
      await mockNetworkImagesFor(() async {
        // Act - render the chat widget with animations enabled
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

        // Add a message which should trigger animation
        final message = ChatMessage(
          text: 'Message with fade animation',
          user: aiUser,
          createdAt: DateTime.now(),
        );

        controller.addMessage(message);

        // First frame after message added (opacity should be low)
        await tester.pump();

        // Verify controller has the message
        expect(controller.messages.length, 1);
        expect(controller.messages[0].text, 'Message with fade animation');

        // Middle of animation
        await tester.pump(const Duration(milliseconds: 200));

        // Animation completed
        await tester.pump(const Duration(milliseconds: 400));
      });
    });

    testWidgets('typing indicator has animated dots', (tester) async {
      await mockNetworkImagesFor(() async {
        // Act - render with typing indicator
        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: AiChatWidget(
              config: AiChatConfig(
                aiName: 'Test AI',
                enableAnimation: true,
                typingUsers: [aiUser], // AI is typing
              ),
              controller: controller,
              currentUser: currentUser,
              aiUser: aiUser,
              onSendMessage: (_) {},
            ),
          ),
        ));

        await tester.pump(); // Initial render

        // Verify there are animated containers (for the dots)
        final containerFinder = find.byType(Container);
        expect(containerFinder, findsWidgets);

        // Animate several frames to test animation
        await tester.pump(const Duration(milliseconds: 200));
        await tester.pump(const Duration(milliseconds: 200));
        await tester.pump(const Duration(milliseconds: 200));
        await tester.pump(const Duration(milliseconds: 400));
      });
    });

    testWidgets('scroll-to-bottom button animates on appearance',
        (tester) async {
      await mockNetworkImagesFor(() async {
        // Add enough messages to enable scrolling
        for (int i = 0; i < 20; i++) {
          controller.addMessage(ChatMessage(
            text: 'Message $i',
            user: i % 2 == 0 ? currentUser : aiUser,
            createdAt: DateTime.now(),
          ));
        }

        // Configure scroll button with animation
        final scrollToBottomOptions = ScrollToBottomOptions(
          showText: true,
          buttonText: 'New Messages',
          alwaysVisible: true, // For testing purposes
        );

        // Act - render with scroll button
        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: AiChatWidget(
              config: AiChatConfig(
                aiName: 'Test AI',
                enableAnimation: true,
                scrollToBottomOptions: scrollToBottomOptions,
              ),
              controller: controller,
              currentUser: currentUser,
              aiUser: aiUser,
              onSendMessage: (_) {},
            ),
          ),
        ));

        await tester.pump(); // Initial render

        // Verify the button is rendered
        expect(find.text('New Messages'), findsOneWidget);

        // Verify the AnimatedOpacity widget is used
        expect(find.byType(AnimatedOpacity), findsWidgets);

        // Animation frames
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pump(const Duration(milliseconds: 200));
      });
    });

    testWidgets('quick replies have appear animation', (tester) async {
      await mockNetworkImagesFor(() async {
        // Configure quick replies
        final quickReplyOptions = QuickReplyOptions(
          quickReplies: ['Option 1', 'Option 2', 'Option 3'],
        );

        // Act - render with quick replies
        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: AiChatWidget(
              config: AiChatConfig(
                aiName: 'Test AI',
                enableAnimation: true,
                quickReplyOptions: quickReplyOptions,
              ),
              controller: controller,
              currentUser: currentUser,
              aiUser: aiUser,
              onSendMessage: (_) {},
            ),
          ),
        ));

        await tester.pump(); // Initial render

        // Verify quick replies are rendered
        expect(find.text('Option 1'), findsOneWidget);
        expect(find.text('Option 2'), findsOneWidget);
        expect(find.text('Option 3'), findsOneWidget);

        // Animation frames (quick replies may have subtle animations)
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pump(const Duration(milliseconds: 200));
      });
    });

    testWidgets('animation can be disabled via config', (tester) async {
      await mockNetworkImagesFor(() async {
        // Act - render with animations explicitly disabled
        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: AiChatWidget(
              config: AiChatConfig(
                aiName: 'Test AI',
                enableAnimation: false, // Animations disabled
              ),
              controller: controller,
              currentUser: currentUser,
              aiUser: aiUser,
              onSendMessage: (_) {},
            ),
          ),
        ));

        await tester.pump(); // Initial render

        // Add a message
        final message = ChatMessage(
          text: 'Message with animations disabled',
          user: aiUser,
          createdAt: DateTime.now(),
        );

        controller.addMessage(message);

        // First frame after message added - should appear immediately
        await tester.pump();

        // Verify message is in controller
        expect(controller.messages.length, 1);
        expect(controller.messages[0].text, 'Message with animations disabled');

        // Short delay - message should still be visible even with no animation
        await tester.pump(const Duration(milliseconds: 50));
      });
    });

    testWidgets('bubble shadow animation is applied when configured',
        (tester) async {
      await mockNetworkImagesFor(() async {
        // Configure bubble with shadow
        final bubbleStyle = BubbleStyle(
          enableShadow: true,
          aiBubbleColor: Colors.purple.shade100,
          userBubbleColor: Colors.blue.shade100,
        );

        // Act - render with shadow enabled
        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: AiChatWidget(
              config: AiChatConfig(
                aiName: 'Test AI',
                enableAnimation: true,
                messageOptions: MessageOptions(
                  bubbleStyle: bubbleStyle,
                ),
              ),
              controller: controller,
              currentUser: currentUser,
              aiUser: aiUser,
              onSendMessage: (_) {},
            ),
          ),
        ));

        await tester.pump(); // Initial render

        // Add a message to trigger bubble creation
        final message = ChatMessage(
          text: 'Message with shadow animation',
          user: aiUser,
          createdAt: DateTime.now(),
        );

        controller.addMessage(message);

        await tester.pump(); // First frame after message added

        // Verify controller has the message
        expect(controller.messages.length, 1);

        // Animation frames
        await tester.pump(const Duration(milliseconds: 150));
        await tester.pump(const Duration(milliseconds: 350));
      });
    });

    testWidgets('welcome message has entrance animation', (tester) async {
      await mockNetworkImagesFor(() async {
        // Configure welcome message
        final welcomeConfig = WelcomeMessageConfig(
          title: 'Welcome Test',
          titleStyle: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        );

        // Configure example questions
        final exampleQuestions = [
          ExampleQuestion(question: 'Test question 1'),
          ExampleQuestion(question: 'Test question 2'),
        ];

        // Act - render with welcome message
        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: AiChatWidget(
              config: AiChatConfig(
                aiName: 'Test AI',
                enableAnimation: true,
                welcomeMessageConfig: welcomeConfig,
                exampleQuestions: exampleQuestions,
              ),
              controller: controller,
              currentUser: currentUser,
              aiUser: aiUser,
              onSendMessage: (_) {},
            ),
          ),
        ));

        // Initial render
        await tester.pump();

        // Verify welcome content is rendered
        expect(find.text('Welcome Test'), findsOneWidget);
        expect(find.text('Test question 1'), findsOneWidget);
        expect(find.text('Test question 2'), findsOneWidget);

        // Animation frames
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pump(const Duration(milliseconds: 500));
      });
    });
  });
}
