import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';
import 'package:network_image_mock/network_image_mock.dart';

void main() {
  group('Welcome Message Behavior Tests', () {
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

    testWidgets('Welcome message should hide when user sends a message',
        (tester) async {
      await mockNetworkImagesFor(() async {
        // Arrange - setup welcome message
        bool messageSent = false;

        // Create a welcome message config
        final welcomeConfig = WelcomeMessageConfig(
          title: 'Welcome to the chat',
        );

        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: AiChatWidget(
              aiName: 'Test AI',
              welcomeMessageConfig: welcomeConfig,
              inputOptions: const InputOptions(
                unfocusOnTapOutside: false,
                sendOnEnter: true,
              ),
              controller: controller,
              currentUser: currentUser,
              aiUser: aiUser,
              onSendMessage: (message) {
                messageSent = true;
              },
            ),
          ),
        ));

        await tester.pumpAndSettle();

        // Verify welcome message is initially visible
        expect(controller.showWelcomeMessage, isTrue);
        expect(find.text('Welcome to the chat'), findsOneWidget);

        // Act - send a message
        await tester.enterText(find.byType(TextField), 'Hello AI');
        await tester.pumpAndSettle();

        // Find send button by looking for IconButton
        final sendButtonFinder = find.byType(IconButton);
        expect(sendButtonFinder, findsOneWidget,
            reason: 'Send button should be visible');
        await tester.tap(sendButtonFinder);

        await tester.pumpAndSettle();

        // Assert - message was sent and welcome message is hidden
        expect(messageSent, isTrue);
        expect(controller.showWelcomeMessage, isFalse);
        expect(find.text('Welcome to the chat'), findsNothing);
      });
    });

    testWidgets(
        'Welcome message should hide when user presses Enter with sendOnEnter=true',
        (tester) async {
      await mockNetworkImagesFor(() async {
        // Arrange - setup welcome message with sendOnEnter enabled
        bool messageSent = false;

        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: AiChatWidget(
              aiName: 'Test AI',
              welcomeMessageConfig: const WelcomeMessageConfig(
                title: 'Welcome to the chat',
              ),
              inputOptions: const InputOptions(
                unfocusOnTapOutside: false,
                sendOnEnter: true,
              ),
              controller: controller,
              currentUser: currentUser,
              aiUser: aiUser,
              onSendMessage: (message) {
                messageSent = true;
              },
            ),
          ),
        ));

        await tester.pumpAndSettle();

        // Verify welcome message is initially visible
        expect(controller.showWelcomeMessage, isTrue);

        // Act - send a message using Enter key
        await tester.enterText(find.byType(TextField), 'Hello AI');
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pumpAndSettle();

        // Assert - message was sent and welcome message is hidden
        expect(messageSent, isTrue);
        expect(controller.showWelcomeMessage, isFalse);
      });
    });

    testWidgets('Example questions should be displayed in welcome message',
        (tester) async {
      await mockNetworkImagesFor(() async {
        // Arrange - setup welcome message with example questions
        final exampleQuestions = [
          const ExampleQuestion(question: 'What is Flutter?'),
          const ExampleQuestion(question: 'How do I install Flutter?'),
          const ExampleQuestion(question: 'Tell me a joke'),
        ];

        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: AiChatWidget(
              aiName: 'Test AI',
              welcomeMessageConfig: const WelcomeMessageConfig(
                title: 'Welcome to the chat',
                questionsSectionTitle: 'Try these questions:',
              ),
              exampleQuestions: exampleQuestions,
              controller: controller,
              currentUser: currentUser,
              aiUser: aiUser,
              onSendMessage: (message) {},
            ),
          ),
        ));

        await tester.pumpAndSettle();

        // Assert - welcome message and questions are displayed
        expect(controller.showWelcomeMessage, isTrue);
        expect(find.text('Welcome to the chat'), findsOneWidget);
        expect(find.text('Try these questions:'), findsOneWidget);

        // Check that all example questions are displayed
        expect(find.text('What is Flutter?'), findsOneWidget);
        expect(find.text('How do I install Flutter?'), findsOneWidget);
        expect(find.text('Tell me a joke'), findsOneWidget);
      });
    });
  });
}
