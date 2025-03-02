import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';
import 'package:network_image_mock/network_image_mock.dart';

// Test constants
final String longMessage = 'A' * 1000; // 1000 characters

void main() {
  late ChatMessagesController controller;
  late ChatUser currentUser;
  late ChatUser aiUser;

  setUp(() {
    controller = ChatMessagesController();
    currentUser = const ChatUser(id: 'user', name: 'Test User');
    aiUser = const ChatUser(id: 'ai', name: 'AI Assistant');
  });

  tearDown(() {
    controller.dispose();
  });

  group('AiChatWidget UI Tests', () {
    testWidgets('renders in light theme correctly', (tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(MaterialApp(
          theme: ThemeData.light(),
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

        expect(find.byType(AiChatWidget), findsOneWidget);
        expect(find.byType(TextField), findsOneWidget);
        expect(find.byType(IconButton), findsWidgets);
      });
    });

    testWidgets('renders in dark theme correctly', (tester) async {
      await mockNetworkImagesFor(() async {
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

        expect(find.byType(AiChatWidget), findsOneWidget);
        expect(find.byType(TextField), findsOneWidget);
      });
    });

    testWidgets('handles RTL layout correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: AiChatWidget(
              config: AiChatConfig(aiName: 'Test AI'),
              controller: controller,
              currentUser: currentUser,
              aiUser: aiUser,
              onSendMessage: (_) {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify text direction
      final context = tester.element(find.byType(AiChatWidget));
      expect(Directionality.of(context), TextDirection.rtl);
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('handles empty messages correctly', (tester) async {
      await mockNetworkImagesFor(() async {
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

        await tester.enterText(find.byType(TextField), '');
        await tester.tap(find.byIcon(Icons.send));
        await tester.pump();

        // Verify no message is sent
        expect(controller.messages, isEmpty);
      });
    });

    testWidgets('handles long messages correctly', (tester) async {
      await mockNetworkImagesFor(() async {
        bool messageSent = false;
        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: AiChatWidget(
              config: AiChatConfig(aiName: 'Test AI'),
              controller: controller,
              currentUser: currentUser,
              aiUser: aiUser,
              onSendMessage: (_) => messageSent = true,
            ),
          ),
        ));

        await tester.enterText(find.byType(TextField), longMessage);
        await tester.tap(find.byIcon(Icons.send));
        await tester.pump();

        expect(messageSent, isTrue);
      });
    });

    testWidgets('handles rapid message sending', (tester) async {
      await mockNetworkImagesFor(() async {
        int messagesSent = 0;
        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: AiChatWidget(
              config: AiChatConfig(aiName: 'Test AI'),
              controller: controller,
              currentUser: currentUser,
              aiUser: aiUser,
              onSendMessage: (_) => messagesSent++,
            ),
          ),
        ));

        // Send multiple messages rapidly
        for (int i = 0; i < 5; i++) {
          await tester.enterText(find.byType(TextField), 'Message $i');
          await tester.tap(find.byIcon(Icons.send));
          await tester.pump(const Duration(milliseconds: 100));
        }

        expect(messagesSent, 5);
      });
    });

    testWidgets('handles loading state correctly', (WidgetTester tester) async {
      Widget buildTestWidget(bool isLoading) {
        return MaterialApp(
          home: AiChatWidget(
            config: AiChatConfig(
              aiName: 'Test AI',
              loadingConfig: LoadingConfig(
                isLoading: isLoading,
                loadingIndicator:
                    isLoading ? const CircularProgressIndicator() : null,
              ),
            ),
            controller: controller,
            currentUser: currentUser,
            aiUser: aiUser,
            onSendMessage: (message) async {},
          ),
        );
      }

      // Start with no loading
      await tester.pumpWidget(buildTestWidget(false));
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsNothing);

      // Show loading
      await tester.pumpWidget(buildTestWidget(true));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Hide loading
      await tester.pumpWidget(buildTestWidget(false));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  });

  group('AiChatWidget Accessibility Tests', () {
    testWidgets('has correct semantic labels', (tester) async {
      await mockNetworkImagesFor(() async {
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

        expect(
          find.byWidgetPredicate(
            (widget) => widget is TextField,
            description: 'text field',
          ),
          findsOneWidget,
        );
      });
    });

    testWidgets('supports text scaling', (WidgetTester tester) async {
      const textScaleFactor = 1.5;
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(textScaleFactor: textScaleFactor),
            child: AiChatWidget(
              config: AiChatConfig(aiName: 'Test AI'),
              controller: controller,
              currentUser: currentUser,
              aiUser: aiUser,
              onSendMessage: (message) async {},
            ),
          ),
        ),
      );

      // Verify text field scales
      final textField = find.byType(TextField);
      expect(textField, findsOneWidget);

      final context = tester.element(textField);
      expect(MediaQuery.of(context).textScaleFactor, textScaleFactor);
    });
  });
}
