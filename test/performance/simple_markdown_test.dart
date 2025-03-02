import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

void main() {
  group('Simple Markdown Performance Tests', () {
    testWidgets('measures markdown rendering performance',
        (WidgetTester tester) async {
      // Complex markdown string with various elements
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

      // Start measuring performance
      final stopwatch = Stopwatch()..start();

      // Build the widget with the markdown
      await tester.pumpWidget(
        MaterialApp(
          home: SizedBox(
            width: 400,
            height: 600,
            child: Material(
              child: Markdown(
                data: complexMarkdown,
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
      print('Markdown rendering time: ${stopwatch.elapsedMilliseconds}ms');

      // Verify that the rendering time is acceptable
      expect(stopwatch.elapsedMilliseconds, lessThan(1500));
    });
  });
}
