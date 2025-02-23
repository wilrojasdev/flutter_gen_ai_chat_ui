import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';
import 'package:network_image_mock/network_image_mock.dart';

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

    testWidgets('measures markdown rendering performance', (tester) async {
      await pumpTestWidget(tester);

      final stopwatch = Stopwatch()..start();

      const markdownText = '''
# Heading 1
## Heading 2
### Heading 3

This is a paragraph with **bold** and *italic* text.

- List item 1
- List item 2
  - Nested item
  - Another nested item
- List item 3

1. Ordered item 1
2. Ordered item 2

```dart
void main() {
  print('Hello, World!');
}
```

> This is a blockquote
> With multiple lines

| Column 1 | Column 2 |
|----------|----------|
| Cell 1   | Cell 2   |
''';

      // Add markdown message
      controller.addMessage(ChatMessage(
        text: markdownText,
        user: aiUser,
        createdAt: DateTime.now(),
        isMarkdown: true,
      ));

      await tester.pumpAndSettle();

      stopwatch.stop();
      debugPrint('Markdown rendering time: ${stopwatch.elapsedMilliseconds}ms');

      // Markdown should render quickly
      expect(stopwatch.elapsedMilliseconds, lessThan(1000));
    });
  });
}
