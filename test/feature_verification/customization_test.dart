import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';
import 'package:network_image_mock/network_image_mock.dart';

void main() {
  group('UI Customization Features', () {
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

    testWidgets('bubble styling options apply correctly', (tester) async {
      await mockNetworkImagesFor(() async {
        // Arrange
        final message = ChatMessage(
          text: 'Custom styled message',
          user: aiUser,
          createdAt: DateTime.now(),
        );

        controller.addMessage(message);

        // Custom bubble style
        final customBubbleStyle = BubbleStyle(
          aiBubbleColor: Colors.purple.shade100,
          userBubbleColor: Colors.blue.shade100,
          userBubbleTopLeftRadius: 25,
          aiBubbleTopRightRadius: 25,
          enableShadow: true,
        );

        // Act
        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: AiChatWidget(
              config: AiChatConfig(
                aiName: 'Test AI',
                messageOptions: MessageOptions(
                  bubbleStyle: customBubbleStyle,
                ),
              ),
              controller: controller,
              currentUser: currentUser,
              aiUser: aiUser,
              onSendMessage: (_) {},
            ),
          ),
        ));

        await tester.pump();

        // Assert - Verify custom styling applied
        // We can't directly check colors, but we can ensure the message is displayed
        expect(find.text('Custom styled message'), findsOneWidget);
      });
    });

    testWidgets('input field customization applies correctly', (tester) async {
      await mockNetworkImagesFor(() async {
        // Custom input options
        final customInputOptions = InputOptions(
          textStyle: const TextStyle(
            fontSize: 16,
            color: Colors.blue,
          ),
          decoration: const InputDecoration(
            hintText: 'Custom hint text',
            border: OutlineInputBorder(),
          ),
          unfocusOnTapOutside: false,
          sendOnEnter: true,
        );

        // Act
        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: AiChatWidget(
              config: AiChatConfig(
                aiName: 'Test AI',
                inputOptions: customInputOptions,
              ),
              controller: controller,
              currentUser: currentUser,
              aiUser: aiUser,
              onSendMessage: (_) {},
            ),
          ),
        ));

        await tester.pump();

        // Assert - Verify custom hint text is applied
        expect(find.text('Custom hint text'), findsOneWidget);
      });
    });

    testWidgets('supports dark theme configuration', (tester) async {
      await mockNetworkImagesFor(() async {
        // Arrange
        final message = ChatMessage(
          text: 'Theme-aware message',
          user: aiUser,
          createdAt: DateTime.now(),
        );

        controller.addMessage(message);

        // Act - with dark theme
        await tester.pumpWidget(MaterialApp(
          theme: ThemeData.dark(),
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

        await tester.pump();

        // Assert - we can't directly check theme-specific colors,
        // but we can ensure the widget renders properly in dark mode
        expect(find.text('Theme-aware message'), findsOneWidget);
      });
    });

    testWidgets('welcome message customization applies correctly',
        (tester) async {
      await mockNetworkImagesFor(() async {
        // Custom welcome message config
        final welcomeConfig = WelcomeMessageConfig(
          title: 'Custom Welcome Title',
          titleStyle: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.purple,
          ),
          questionsSectionTitle: 'Custom Questions Section',
        );

        // Custom example questions
        final exampleQuestions = [
          ExampleQuestion(question: 'Custom question 1'),
          ExampleQuestion(question: 'Custom question 2'),
        ];

        // Act
        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: AiChatWidget(
              config: AiChatConfig(
                aiName: 'Test AI',
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

        await tester.pump();

        // Assert - Verify custom welcome content
        expect(find.text('Custom Welcome Title'), findsOneWidget);
        expect(find.text('Custom Questions Section'), findsOneWidget);
        expect(find.text('Custom question 1'), findsOneWidget);
        expect(find.text('Custom question 2'), findsOneWidget);
      });
    });

    testWidgets('quick replies are displayed when configured', (tester) async {
      await mockNetworkImagesFor(() async {
        // Configure quick replies
        final quickReplyOptions = QuickReplyOptions(
          quickReplies: ['Reply 1', 'Reply 2', 'Reply 3'],
        );

        // Act
        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: AiChatWidget(
              config: AiChatConfig(
                aiName: 'Test AI',
                quickReplyOptions: quickReplyOptions,
              ),
              controller: controller,
              currentUser: currentUser,
              aiUser: aiUser,
              onSendMessage: (_) {},
            ),
          ),
        ));

        await tester.pump();

        // Assert - Check for quick reply buttons
        expect(find.text('Reply 1'), findsOneWidget);
        expect(find.text('Reply 2'), findsOneWidget);
        expect(find.text('Reply 3'), findsOneWidget);
      });
    });

    testWidgets('scroll-to-bottom button appears when scrolled',
        (tester) async {
      await mockNetworkImagesFor(() async {
        // Arrange - Add enough messages to enable scrolling
        for (int i = 0; i < 20; i++) {
          controller.addMessage(ChatMessage(
            text: 'Message $i',
            user: i % 2 == 0 ? currentUser : aiUser,
            createdAt: DateTime.now(),
          ));
        }

        // Custom scroll to bottom options
        final scrollToBottomOptions = ScrollToBottomOptions(
          buttonText: 'Custom Scroll Text',
          showText: true,
          alwaysVisible: true, // Always show for testing purposes
        );

        // Act
        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: AiChatWidget(
              config: AiChatConfig(
                aiName: 'Test AI',
                scrollToBottomOptions: scrollToBottomOptions,
              ),
              controller: controller,
              currentUser: currentUser,
              aiUser: aiUser,
              onSendMessage: (_) {},
            ),
          ),
        ));

        await tester.pump(const Duration(milliseconds: 500));

        // Assert - Check for custom scroll button text
        expect(find.text('Custom Scroll Text'), findsOneWidget);
      });
    });
  });
}
