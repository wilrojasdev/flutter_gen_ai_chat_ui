import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';
import 'package:network_image_mock/network_image_mock.dart';

void main() {
  group('Accessibility Features', () {
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

    testWidgets('supports text scaling', (tester) async {
      await mockNetworkImagesFor(() async {
        // Arrange
        final message = ChatMessage(
          text: 'Accessibility test message',
          user: aiUser,
          createdAt: DateTime.now(),
        );

        controller.addMessage(message);

        // Act - with increased text scaling factor
        await tester.pumpWidget(
          MaterialApp(
            home: MediaQuery(
              data: const MediaQueryData(textScaleFactor: 1.5),
              child: Scaffold(
                body: AiChatWidget(
                  config: AiChatConfig(aiName: 'Test AI'),
                  controller: controller,
                  currentUser: currentUser,
                  aiUser: aiUser,
                  onSendMessage: (_) {},
                ),
              ),
            ),
          ),
        );

        await tester.pump();

        // Assert - check that scaling is applied
        // (hard to verify exact scaling, but we check it renders without errors)
        expect(find.text('Accessibility test message'), findsOneWidget);

        // Check that MediaQuery is properly applied
        final context = tester.element(find.byType(AiChatWidget));
        expect(MediaQuery.of(context).textScaleFactor, 1.5);
      });
    });

    testWidgets('input field is focusable for keyboard navigation',
        (tester) async {
      await mockNetworkImagesFor(() async {
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

        await tester.pump();

        // Find the input field and check if it can receive focus
        final textField = find.byType(TextField);
        expect(textField, findsOneWidget);

        // Try to focus the text field
        await tester.tap(textField);
        await tester.pump();

        // We can't directly check focus state in widget tests,
        // but we can verify the field is responsive to input
        await tester.enterText(textField, 'Accessibility input');
        await tester.pump();

        expect(find.text('Accessibility input'), findsOneWidget);
      });
    });

    testWidgets('RTL text direction is supported', (tester) async {
      await mockNetworkImagesFor(() async {
        // Arrange
        final rtlMessage = ChatMessage(
          text: 'مرحبا هذا اختبار', // Arabic text "Hello this is a test"
          user: aiUser,
          createdAt: DateTime.now(),
        );

        controller.addMessage(rtlMessage);

        // Act - with RTL text direction
        await tester.pumpWidget(
          MaterialApp(
            home: Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                body: AiChatWidget(
                  config: AiChatConfig(aiName: 'Test AI'),
                  controller: controller,
                  currentUser: currentUser,
                  aiUser: aiUser,
                  onSendMessage: (_) {},
                ),
              ),
            ),
          ),
        );

        await tester.pump();

        // Assert - check that the RTL text renders
        expect(find.text('مرحبا هذا اختبار'), findsOneWidget);

        // Verify the text direction is set correctly
        final context = tester.element(find.byType(AiChatWidget));
        expect(Directionality.of(context), TextDirection.rtl);
      });
    });

    testWidgets('support for reduced animations setting', (tester) async {
      await mockNetworkImagesFor(() async {
        // Arrange
        final message = ChatMessage(
          text: 'Reduced motion test',
          user: aiUser,
          createdAt: DateTime.now(),
        );

        // Act - with animations disabled
        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: AiChatWidget(
              config: AiChatConfig(
                aiName: 'Test AI',
                enableAnimation: false, // Disable animations
              ),
              controller: controller,
              currentUser: currentUser,
              aiUser: aiUser,
              onSendMessage: (_) {},
            ),
          ),
        ));

        await tester.pump();

        // Add message after widget is built
        controller.addMessage(message);

        // First frame after message is added
        await tester.pump();

        // Assert message appears immediately (no animation delay)
        expect(find.text('Reduced motion test'), findsOneWidget);
      });
    });

    testWidgets('high contrast mode works with dark theme', (tester) async {
      await mockNetworkImagesFor(() async {
        // Arrange
        final message = ChatMessage(
          text: 'High contrast test',
          user: aiUser,
          createdAt: DateTime.now(),
        );

        controller.addMessage(message);

        // Create a high-contrast dark theme
        final highContrastDarkTheme = ThemeData.dark().copyWith(
          textTheme: ThemeData.dark().textTheme.copyWith(
                bodyMedium: const TextStyle(
                  color: Colors.white, // Higher contrast text
                  fontSize: 16,
                ),
              ),
        );

        // Act - with high contrast dark theme
        await tester.pumpWidget(MaterialApp(
          theme: highContrastDarkTheme,
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

        // Assert message renders (we can't verify colors in widget tests)
        expect(find.text('High contrast test'), findsOneWidget);
      });
    });
  });
}
