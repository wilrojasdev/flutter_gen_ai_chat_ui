import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_gen_ai_chat_ui/src/models/chat_message.dart';
import 'package:flutter_gen_ai_chat_ui/src/models/chat_user.dart';
import 'package:flutter_gen_ai_chat_ui/src/controllers/chat_messages_controller.dart';

void main() {
  group('Performance Benchmarks', () {
    late ChatMessagesController controller;
    late ChatUser currentUser;
    late ChatUser aiUser;

    setUp(() {
      controller = ChatMessagesController();
      currentUser = const ChatUser(id: '1', name: 'User');
      aiUser = const ChatUser(id: '2', name: 'AI');
    });

    Future<void> pumpTestWidget(WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AiChatWidget(
              config: AiChatConfig(
                aiName: 'AI',
              ),
              controller: controller,
              currentUser: currentUser,
              aiUser: aiUser,
              onSendMessage: (message) {},
            ),
          ),
        ),
      );
    }

    testWidgets('measures initial render time', (tester) async {
      final stopwatch = Stopwatch()..start();
      await pumpTestWidget(tester);
      stopwatch.stop();
      debugPrint('Initial render time: ${stopwatch.elapsedMilliseconds}ms');
      expect(stopwatch.elapsedMilliseconds, lessThan(2000));
    });

    testWidgets('measures message addition performance', (tester) async {
      await pumpTestWidget(tester);
      final stopwatch = Stopwatch()..start();

      // Add 100 messages
      for (var i = 0; i < 100; i++) {
        controller.addMessage(ChatMessage(
          text: 'Test message $i',
          user: i.isEven ? currentUser : aiUser,
          createdAt: DateTime.now(),
        ));
        await tester.pump();
      }

      stopwatch.stop();
      debugPrint(
          '100 messages addition time: ${stopwatch.elapsedMilliseconds}ms');
      expect(stopwatch.elapsedMilliseconds, lessThan(3000));
    });

    testWidgets('measures scroll performance', (WidgetTester tester) async {
      final stopwatch = Stopwatch()..start();

      await tester.pumpWidget(
        MaterialApp(
          home: AiChatWidget(
            config: AiChatConfig(aiName: 'Test AI'),
            controller: controller,
            currentUser: currentUser,
            aiUser: aiUser,
            onSendMessage: (message) async {},
          ),
        ),
      );

      // Add some messages for scrolling
      for (int i = 0; i < 20; i++) {
        controller.addMessage(ChatMessage(
          text: 'Test message $i',
          user: i % 2 == 0 ? currentUser : aiUser,
          createdAt: DateTime.now(),
        ));
      }
      await tester.pump();

      // Perform scroll gesture with shorter duration
      await tester.fling(
        find.byType(ListView),
        const Offset(0, -300),
        1000, // Increased velocity
      );

      // Wait for a fixed duration instead of pumpAndSettle
      await tester.pump(const Duration(milliseconds: 300));

      stopwatch.stop();
      print('Scroll performance time: ${stopwatch.elapsedMilliseconds}ms');
      expect(stopwatch.elapsedMilliseconds, lessThan(1000));
    });

    testWidgets('measures streaming text performance', (tester) async {
      await pumpTestWidget(tester);

      final stopwatch = Stopwatch()..start();

      const longText =
          'This is a very long streaming text message that should be animated character by character to test the performance of our streaming implementation...';

      // Add streaming message
      controller.addMessage(ChatMessage(
        text: longText,
        user: aiUser,
        createdAt: DateTime.now(),
        isMarkdown: true,
      ));

      // Wait for streaming animation
      await tester.pumpAndSettle();

      stopwatch.stop();
      debugPrint(
          'Streaming text animation time: ${stopwatch.elapsedMilliseconds}ms');

      // Streaming animation should complete in reasonable time
      expect(stopwatch.elapsedMilliseconds, lessThan(2000));
    });

    testWidgets('measures markdown rendering performance in chat context',
        (WidgetTester tester) async {
      // Create chat users
      final user = ChatUser(id: 'user-id', name: 'User');
      final bot = ChatUser(id: 'bot-id', name: 'AI Assistant');

      // Create a controller
      final controller = ChatMessagesController();

      // Complex markdown message
      final String complexMarkdown = '''
# Heading 1
## Heading 2
### Heading 3

This is a paragraph with **bold text**, *italic text*, and `inline code`.

- List item 1
- List item 2
  - Nested list item
  - Another nested item
- List item 3

1. Ordered list item 1
2. Ordered list item 2
3. Ordered list item 3

> This is a blockquote with some text.
> It can span multiple lines.

```dart
void main() {
  print('Hello, world!');
}
```

[Link to Flutter](https://flutter.dev)

---

| Column 1 | Column 2 | Column 3 |
|----------|----------|----------|
| Cell 1   | Cell 2   | Cell 3   |
| Cell 4   | Cell 5   | Cell 6   |
''';

      // Create a message with the complex markdown
      final message = ChatMessage(
        text: complexMarkdown,
        user: bot,
        createdAt: DateTime.now(),
        isMarkdown: true,
      );

      // Add the message to the controller
      controller.addMessage(message);

      // Start measuring performance
      final stopwatch = Stopwatch()..start();

      // Build a simple widget to display the message
      await tester.pumpWidget(
        MaterialApp(
          home: SizedBox(
            width: 400,
            height: 600,
            child: Material(
              child: Markdown(
                data: message.text,
              ),
            ),
          ),
        ),
      );

      // Pump a few frames to ensure rendering is complete
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      // Stop measuring
      stopwatch.stop();

      // Print the rendering time
      print('Chat markdown rendering time: ${stopwatch.elapsedMilliseconds}ms');

      // Verify that the rendering time is acceptable
      expect(stopwatch.elapsedMilliseconds, lessThan(1500));
    });
  });
}
