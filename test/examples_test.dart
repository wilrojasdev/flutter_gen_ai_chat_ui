import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:flutter_streaming_text_markdown/flutter_streaming_text_markdown.dart';
import '../example/lib/custom_styling_example.dart';
import '../example/lib/detailed_example.dart';
import '../example/lib/markdown_example.dart';
import '../example/lib/pagination_example.dart';
import '../example/lib/simple_chat_screen.dart';
import '../example/lib/streaming_example.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  group('Simple Chat Screen Tests', () {
    testWidgets('renders basic UI elements', (tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(const MaterialApp(home: SimpleChatScreen()));
        await tester.pump(const Duration(seconds: 1));

        expect(find.byType(AiChatWidget), findsOneWidget);
        expect(find.byType(TextField), findsOneWidget);
      });
    });

    testWidgets('handles message sending', (tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(const MaterialApp(home: SimpleChatScreen()));
        await tester.pump();

        // Enter and send a message
        await tester.enterText(find.byType(TextField), 'Test message');
        await tester.tap(find.byIcon(Icons.send));
        await tester.pump();

        // Wait for the simulated AI response delay
        await tester.pump(const Duration(seconds: 2));

        // Verify the message appears in the chat
        expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is SelectableText && widget.data == 'Test message',
            description: 'User message text',
          ),
          findsOneWidget,
        );

        // Verify the message is in a message bubble
        expect(
          find.ancestor(
            of: find.text('Test message'),
            matching: find.byWidgetPredicate(
              (widget) => widget is Container && widget.decoration != null,
              description: 'Message bubble',
            ),
          ),
          findsOneWidget,
        );
      });
    });

    testWidgets('shows example questions', (tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(const MaterialApp(home: SimpleChatScreen()));
        await tester.pump(const Duration(seconds: 1));

        expect(find.byType(AiChatWidget), findsOneWidget);

        // Verify example questions are displayed
        expect(
          find.byWidgetPredicate(
            (widget) => widget is Material && widget.child is InkWell,
            description: 'Example question button',
          ),
          findsWidgets,
        );
      });
    });
  });

  group('Streaming Example Tests', () {
    testWidgets('renders streaming UI', (tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(const MaterialApp(home: StreamingExample()));
        await tester.pump(const Duration(seconds: 1));

        expect(find.byType(AiChatWidget), findsOneWidget);
        expect(find.byType(TextField), findsOneWidget);
      });
    });

    testWidgets('handles streaming messages', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: StreamingExample(),
        ),
      );
      await tester.pumpAndSettle();

      // Find and tap the example question
      final questionFinder =
          find.text('Can you demonstrate streaming responses?');
      expect(questionFinder, findsOneWidget);
      await tester.tap(questionFinder);
      await tester.pump();

      // Wait for message to be added
      await tester.pump(const Duration(milliseconds: 100));

      // Verify user message
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Text &&
              widget.data == 'Can you demonstrate streaming responses?',
          description: 'User message',
        ),
        findsOneWidget,
      );

      // Wait for streaming to start and complete
      await tester.pump(const Duration(seconds: 2));

      // Verify the final message contains the complete text
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is StreamingTextMarkdown &&
              widget.text.contains('Hello! I\'m responding'),
          description: 'AI response',
        ),
        findsOneWidget,
      );
    });
  });

  group('Pagination Example Tests', () {
    testWidgets('renders pagination UI', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: PaginationExample(),
        ),
      );

      await tester.pumpAndSettle();

      // Verify initial UI elements
      expect(find.byType(AiChatWidget), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byIcon(Icons.refresh), findsOneWidget);
    });

    testWidgets('loads more messages on scroll', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: PaginationExample(),
        ),
      );
      await tester.pumpAndSettle();

      // Get initial message count
      final initialMessageCount = tester
          .widgetList(find.byWidgetPredicate(
            (widget) =>
                widget is Text && widget.data!.contains('project updates'),
            description: 'Message text',
          ))
          .length;

      // Scroll to load more messages
      await tester.drag(find.byType(ListView), const Offset(0, -300));
      await tester.pump();

      // Wait for loading state
      await tester.pump(const Duration(milliseconds: 500));

      // Wait for loading to complete and messages to be added
      await tester.pumpAndSettle();

      // Verify more messages are loaded
      final newMessageCount = tester
          .widgetList(find.byWidgetPredicate(
            (widget) =>
                widget is Text && widget.data!.contains('project updates'),
            description: 'Message text',
          ))
          .length;
      expect(newMessageCount, greaterThan(initialMessageCount));
    });

    testWidgets('handles pagination errors', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: PaginationExample(),
        ),
      );
      await tester.pumpAndSettle();

      // Scroll multiple times to reach the end
      for (var i = 0; i < 20; i++) {
        await tester.drag(find.byType(ListView), const Offset(0, -300));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pumpAndSettle();
      }

      // Wait for end of messages state
      await tester.pump(const Duration(seconds: 1));

      // Verify end of messages text
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Text &&
              widget.data!.contains('Reached beginning of messages'),
          description: 'End of messages text',
        ),
        findsOneWidget,
      );
    });
  });

  group('Markdown Example Tests', () {
    testWidgets('renders markdown content', (tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(const MaterialApp(home: MarkdownExample()));
        await tester.pump(const Duration(seconds: 1));

        // Verify welcome message with markdown
        expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is MarkdownBody &&
                widget.data.contains('Welcome to Markdown Chat!'),
            description: 'Welcome message markdown',
          ),
          findsOneWidget,
        );

        // Verify markdown formatting examples are present
        expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is MarkdownBody &&
                widget.data.contains('Text Formatting'),
            description: 'Markdown examples',
          ),
          findsOneWidget,
        );
      });
    });

    testWidgets('handles markdown messages', (tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(const MaterialApp(home: MarkdownExample()));
        await tester.pump(const Duration(seconds: 1));

        // Send a message with markdown
        const markdownText = '**Bold** and *italic* text';
        await tester.enterText(find.byType(TextField), markdownText);
        await tester.tap(find.byIcon(Icons.send));
        await tester.pump();

        // Wait for message to be added
        await tester.pump(const Duration(milliseconds: 500));

        // Verify user message is added
        expect(
          find.byWidgetPredicate(
            (widget) => widget is SelectableText && widget.data == markdownText,
            description: 'User message',
          ),
          findsOneWidget,
        );

        // Wait for AI response
        await tester.pump(const Duration(seconds: 1));

        // Verify AI response with markdown
        expect(
          find.byWidgetPredicate(
            (widget) => widget is MarkdownBody && widget.data.contains('**'),
            description: 'AI markdown response',
          ),
          findsWidgets,
        );
      });
    });

    testWidgets('handles code blocks in markdown', (tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(const MaterialApp(home: MarkdownExample()));
        await tester.pump(const Duration(seconds: 1));

        // Find code block in welcome message
        expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is MarkdownBody && widget.data.contains('```dart'),
            description: 'Code block',
          ),
          findsOneWidget,
        );

        // Verify code block is properly formatted
        expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is MarkdownBody && widget.data.contains('void main()'),
            description: 'Code content',
          ),
          findsOneWidget,
        );
      });
    });
  });

  group('Custom Styling Example Tests', () {
    testWidgets('renders with custom theme', (tester) async {
      await mockNetworkImagesFor(() async {
        await tester
            .pumpWidget(const MaterialApp(home: CustomStylingExample()));
        await tester.pump(const Duration(seconds: 1));

        expect(find.byType(AiChatWidget), findsOneWidget);
        expect(find.byType(TextField), findsOneWidget);
      });
    });

    testWidgets('applies custom message styles', (tester) async {
      await mockNetworkImagesFor(() async {
        await tester
            .pumpWidget(const MaterialApp(home: CustomStylingExample()));
        await tester.pump();

        await tester.enterText(find.byType(TextField), 'Custom styled message');
        await tester.tap(find.byIcon(Icons.send));
        await tester.pump();
        await tester.pump(const Duration(seconds: 2));

        // Verify custom styling is applied
        expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is Container &&
                widget.decoration != null &&
                widget.child is SelectableText,
            description: 'Custom styled message bubble',
          ),
          findsOneWidget,
        );
      });
    });
  });

  group('Detailed Example Tests', () {
    testWidgets('renders initial UI', (tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(const MaterialApp(home: DetailedExample()));
        await tester.pump(const Duration(seconds: 1));

        expect(find.byType(AiChatWidget), findsOneWidget);
        expect(find.byType(TextField), findsOneWidget);

        // Verify welcome message
        expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is SelectableText &&
                widget.data!.contains("Hello! I'm your AI assistant"),
            description: 'Welcome message',
          ),
          findsOneWidget,
        );
      });
    });

    testWidgets('handles message history', (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          const MaterialApp(
            home: DetailedExample(),
          ),
        );

        await tester.pumpAndSettle();

        // Verify initial message
        expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is SelectableText &&
                widget.data!.contains("Hello! I'm your AI assistant"),
            description: 'Initial message',
          ),
          findsOneWidget,
        );

        // Send a message to trigger history loading
        await tester.enterText(find.byType(TextField), 'Load history');
        await tester.tap(find.byIcon(Icons.send));
        await tester.pump();

        // Wait for message processing and history loading
        await tester.pump(const Duration(seconds: 2));
        await tester.pumpAndSettle();

        // Verify historical messages are loaded
        final messageCount = find
            .byWidgetPredicate(
              (widget) => widget is SelectableText,
              description: 'Message text',
            )
            .evaluate()
            .length;
        expect(messageCount,
            greaterThan(2)); // Initial + user message + AI response + history
      });
    });

    testWidgets('handles message sending', (tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(const MaterialApp(home: DetailedExample()));
        await tester.pump(const Duration(seconds: 1));

        // Send a message
        await tester.enterText(find.byType(TextField), 'Test message');
        await tester.tap(find.byIcon(Icons.send));
        await tester.pump();

        // Verify user message appears
        expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is SelectableText && widget.data == 'Test message',
            description: 'User message',
          ),
          findsOneWidget,
        );

        // Wait for AI response
        await tester.pump(const Duration(seconds: 2));

        // Verify AI response appears
        expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is SelectableText &&
                widget.data!.contains('Thank you for your message'),
            description: 'AI response',
          ),
          findsOneWidget,
        );
      });
    });
  });

  group('Integration Tests', () {
    testWidgets('theme persistence across examples', (tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            home: const CustomStylingExample(),
          ),
        );
        await tester.pump(const Duration(seconds: 1));

        final initialTheme =
            Theme.of(tester.element(find.byType(CustomStylingExample)));

        // Navigate to another example
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            home: const DetailedExample(),
          ),
        );
        await tester.pump(const Duration(seconds: 1));

        final newTheme = Theme.of(tester.element(find.byType(DetailedExample)));
        expect(newTheme.brightness, equals(initialTheme.brightness));
      });
    });

    testWidgets('message persistence across examples',
        (WidgetTester tester) async {
      // Create a controller to share between examples
      final controller = ChatMessagesController();
      final currentUser = const ChatUser(id: 'user', name: 'Test User');
      final aiUser = const ChatUser(id: 'ai', name: 'AI Assistant');

      // Start with SimpleChatScreen
      await tester.pumpWidget(
        MaterialApp(
          home: AiChatWidget(
            config: AiChatConfig(
              aiName: 'Test AI',
              exampleQuestions: [
                const ExampleQuestion(question: 'Test Question'),
              ],
            ),
            controller: controller,
            currentUser: currentUser,
            aiUser: aiUser,
            onSendMessage: (message) async {
              controller.addMessage(message);
              // Simulate AI response
              await Future.delayed(const Duration(seconds: 1));
              controller.addMessage(
                ChatMessage(
                  text: 'This is a simulated AI response',
                  user: aiUser,
                  createdAt: DateTime.now(),
                ),
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Send a test message
      await tester.enterText(find.byType(TextField), 'Test message');
      await tester.tap(find.byIcon(Icons.send));
      await tester.pumpAndSettle();

      // Wait for AI response
      await tester.pump(const Duration(seconds: 2));

      // Switch to StreamingExample
      await tester.pumpWidget(
        MaterialApp(
          home: AiChatWidget(
            config: AiChatConfig(
              aiName: 'Test AI',
              exampleQuestions: [
                const ExampleQuestion(question: 'Test Question'),
              ],
            ),
            controller: controller,
            currentUser: currentUser,
            aiUser: aiUser,
            onSendMessage: (message) async {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Switch back to SimpleChatScreen
      await tester.pumpWidget(
        MaterialApp(
          home: AiChatWidget(
            config: AiChatConfig(
              aiName: 'Test AI',
              exampleQuestions: [
                const ExampleQuestion(question: 'Test Question'),
              ],
            ),
            controller: controller,
            currentUser: currentUser,
            aiUser: aiUser,
            onSendMessage: (message) async {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify messages are still present
      expect(
        find.byWidgetPredicate(
          (widget) => widget is SelectableText && widget.data == 'Test message',
          description: 'User message after navigation',
        ),
        findsOneWidget,
      );

      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is SelectableText &&
              widget.data!.contains('This is a simulated AI response'),
          description: 'AI response after navigation',
        ),
        findsOneWidget,
      );
    });
  });
}
