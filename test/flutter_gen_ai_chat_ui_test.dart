import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_streaming_text_markdown/flutter_streaming_text_markdown.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:flutter_gen_ai_chat_ui/src/theme/custom_theme_extension.dart';

void main() {
  // Core Features Tests
  group('Core Features', () {
    late ChatMessagesController controller;
    late ChatUser currentUser;
    late ChatUser aiUser;

    setUp(() {
      controller = ChatMessagesController();
      currentUser = const ChatUser(id: '1', name: 'User');
      aiUser = const ChatUser(id: '2', name: 'AI');
    });

    tearDown(() {
      controller.dispose();
    });

    test('Message State Management', () {
      final message = ChatMessage(
        text: 'Hello',
        user: currentUser,
        createdAt: DateTime.now(),
      );

      controller.addMessage(message);
      expect(controller.messages.length, 1);
      expect(controller.messages.first.text, 'Hello');

      // Test duplicate message prevention
      controller.addMessage(message);
      expect(controller.messages.length, 1);

      // Test message updating
      final updatedMessage = message.copyWith(text: 'Updated Hello');
      controller.updateMessage(updatedMessage);
      expect(controller.messages.first.text, 'Updated Hello');
    });

    test('Message Streaming State', () {
      final streamingMessage = ChatMessage(
        text: 'Streaming...',
        user: aiUser,
        createdAt: DateTime.now(),
        customProperties: {'isStreaming': true},
      );

      controller.addMessage(streamingMessage);
      expect(controller.messages.first.customProperties?['isStreaming'], true);

      final completedMessage = streamingMessage.copyWith(
        text: 'Completed',
        customProperties: {'isStreaming': false},
      );
      controller.updateMessage(completedMessage);
      expect(controller.messages.first.customProperties?['isStreaming'], false);
    });

    test('Pagination State', () {
      controller = ChatMessagesController(
        onLoadMoreMessages: (lastMessage) async {
          return [
            ChatMessage(
              text: 'Old message',
              user: aiUser,
              createdAt: DateTime.now().subtract(const Duration(days: 1)),
            ),
          ];
        },
      );

      expect(controller.isLoadingMore, false);
      expect(controller.hasMoreMessages, true);
    });
  });

  // UI Components Tests
  group('UI Components', () {
    late ChatMessagesController controller;
    late ChatUser currentUser;
    late ChatUser aiUser;

    setUp(() {
      controller = ChatMessagesController();
      currentUser = const ChatUser(id: '1', name: 'User');
      aiUser = const ChatUser(id: '2', name: 'AI');
    });

    testWidgets('Message Bubble Rendering', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AiChatWidget(
              config: AiChatConfig(aiName: 'AI'),
              controller: controller,
              currentUser: currentUser,
              aiUser: aiUser,
              onSendMessage: (message) async {},
            ),
          ),
        ),
      );

      controller.addMessage(ChatMessage(
        text: 'Test message',
        user: currentUser,
        createdAt: DateTime.now(),
      ));

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('Test message'), findsOneWidget);
    });

    testWidgets('Input Field Functionality', (tester) async {
      final controller = ChatMessagesController();
      final currentUser = const ChatUser(id: '1', name: 'User');
      final aiUser = const ChatUser(id: '2', name: 'AI');
      bool messageSent = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AiChatWidget(
              config: AiChatConfig(
                aiName: 'AI',
                inputOptions: const InputOptions(
                  sendOnEnter: true,
                  alwaysShowSend: true,
                ),
              ),
              controller: controller,
              currentUser: currentUser,
              aiUser: aiUser,
              onSendMessage: (message) {
                messageSent = true;
              },
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'Test input');
      await tester.tap(find.byIcon(Icons.send));
      await tester.pump();

      expect(messageSent, true);
    });

    testWidgets('Markdown Rendering', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AiChatWidget(
              config: AiChatConfig(
                aiName: 'AI',
                messageOptions: const MessageOptions(),
              ),
              controller: controller,
              currentUser: currentUser,
              aiUser: aiUser,
              onSendMessage: (message) async {},
            ),
          ),
        ),
      );

      controller.addMessage(ChatMessage(
        text: '**Bold** and *italic*',
        user: aiUser,
        createdAt: DateTime.now(),
        isMarkdown: true,
      ));

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // First verify the message content is rendered
      expect(find.text('Bold and italic'), findsOneWidget);

      // Then verify markdown elements are present
      final markdownWidget = find.byType(MarkdownBody);
      expect(markdownWidget, findsOneWidget);
    });

    testWidgets('Loading State Display', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AiChatWidget(
              config: AiChatConfig(
                aiName: 'AI',
                loadingConfig: const LoadingConfig(
                  isLoading: true,
                  loadingIndicator: CircularProgressIndicator(),
                ),
              ),
              controller: controller,
              currentUser: currentUser,
              aiUser: aiUser,
              onSendMessage: (message) async {},
            ),
          ),
        ),
      );

      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Test loading state change
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AiChatWidget(
              config: AiChatConfig(
                aiName: 'AI',
                loadingConfig: const LoadingConfig(
                  isLoading: false,
                ),
              ),
              controller: controller,
              currentUser: currentUser,
              aiUser: aiUser,
              onSendMessage: (message) async {},
            ),
          ),
        ),
      );

      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('renders correctly with minimal configuration',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: AiChatWidget(
            config: AiChatConfig(
              aiName: 'AI',
              inputOptions: const InputOptions(
                alwaysShowSend: true,
              ),
            ),
            controller: controller,
            currentUser: currentUser,
            aiUser: aiUser,
            onSendMessage: (_) async {},
          ),
        ),
      ));

      expect(find.byType(AiChatWidget), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);

      // Enter text to ensure send button is visible
      await tester.enterText(find.byType(TextField), 'test message');
      await tester.pump();

      expect(find.byIcon(Icons.send), findsOneWidget);
    });

    testWidgets('handles send message correctly', (WidgetTester tester) async {
      bool messageReceived = false;
      final message = 'Test message';

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: AiChatWidget(
            config: AiChatConfig(
              aiName: 'AI',
              inputOptions: const InputOptions(
                alwaysShowSend: true,
              ),
            ),
            controller: controller,
            currentUser: currentUser,
            aiUser: aiUser,
            onSendMessage: (msg) async {
              messageReceived = true;
            },
          ),
        ),
      ));

      await tester.enterText(find.byType(TextField), message);
      await tester.pump();

      final sendButton = find.byIcon(Icons.send);
      expect(sendButton, findsOneWidget);

      await tester.tap(sendButton);
      await tester.pump();

      expect(messageReceived, true);
    });

    testWidgets('handles example question tap correctly',
        (WidgetTester tester) async {
      bool exampleTapped = false;
      final List<ExampleQuestion> examples = [
        ExampleQuestion(
          question: 'Example 1',
          config: ExampleQuestionConfig(
            onTap: (question) {
              exampleTapped = true;
            },
          ),
        ),
      ];

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: AiChatWidget(
            config: AiChatConfig(
              aiName: 'AI',
              exampleQuestions: examples,
            ),
            controller: controller,
            currentUser: currentUser,
            aiUser: aiUser,
            onSendMessage: (_) async {},
          ),
        ),
      ));

      await tester.pump();

      final exampleButton = find.text('Example 1');
      expect(exampleButton, findsOneWidget);

      await tester.tap(exampleButton);
      await tester.pump();

      expect(exampleTapped, true);
    });
  });

  // Theme Tests
  group('Theme Tests', () {
    testWidgets('applies custom theme extension', (tester) async {
      final controller = ChatMessagesController();
      final currentUser = const ChatUser(id: '1', name: 'User');
      final aiUser = const ChatUser(id: '2', name: 'AI');

      final customTheme = ThemeData.light().copyWith(
        extensions: [
          const CustomThemeExtension(
            chatBackground: Color(0xFFF5F5F5),
            messageBubbleColor: Colors.white,
            userBubbleColor: Color(0xFFE3F2FD),
            messageTextColor: Color(0xDE000000),
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: customTheme,
          home: AiChatWidget(
            config: AiChatConfig(aiName: 'AI'),
            controller: controller,
            currentUser: currentUser,
            aiUser: aiUser,
            onSendMessage: (message) {},
          ),
        ),
      );

      final context = tester.element(find.byType(AiChatWidget));
      final extension = Theme.of(context).extension<CustomThemeExtension>();
      expect(extension, isNotNull);
      expect(extension?.chatBackground, equals(const Color(0xFFF5F5F5)));
      expect(extension?.messageBubbleColor, equals(Colors.white));
      expect(extension?.userBubbleColor, equals(const Color(0xFFE3F2FD)));
      expect(extension?.messageTextColor, equals(const Color(0xDE000000)));
    });
  });

  // Configuration Tests
  group('Configuration', () {
    test('AiChatConfig Validation', () {
      const config = AiChatConfig(
        aiName: 'AI',
        userName: 'User',
        enableAnimation: true,
        showTimestamp: true,
        readOnly: false,
      );

      expect(config.aiName, 'AI');
      expect(config.userName, 'User');
      expect(config.enableAnimation, true);
      expect(config.showTimestamp, true);
      expect(config.readOnly, false);
    });

    test('InputOptions Validation', () {
      const options = InputOptions(
        sendOnEnter: true,
        alwaysShowSend: true,
        autocorrect: true,
        maxLines: 5,
        minLines: 1,
      );

      expect(options.sendOnEnter, true);
      expect(options.alwaysShowSend, true);
      expect(options.autocorrect, true);
      expect(options.maxLines, 5);
      expect(options.minLines, 1);
    });
  });

  // Error Handling Tests
  group('Error Handling', () {
    test('Message Error State', () {
      final message = ChatMessage(
        text: 'Error message',
        user: const ChatUser(id: '1', name: 'User'),
        createdAt: DateTime.now(),
        hasError: true,
        errorMessage: 'Failed to send',
      );

      expect(message.hasError, true);
      expect(message.errorMessage, 'Failed to send');
    });
  });

  group('AiChatWidget Tests', () {
    late ChatUser currentUser;
    late ChatUser aiUser;
    late ChatMessagesController controller;

    setUp(() {
      currentUser = const ChatUser(id: '1', name: 'User');
      aiUser = const ChatUser(id: '2', name: 'AI');
      controller = ChatMessagesController();
    });

    testWidgets('shows example questions when provided',
        (WidgetTester tester) async {
      final List<ExampleQuestion> examples = [
        const ExampleQuestion(question: 'Example 1'),
        const ExampleQuestion(question: 'Example 2'),
      ];

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: AiChatWidget(
            config: AiChatConfig(
              aiName: 'AI',
              exampleQuestions: examples,
            ),
            currentUser: currentUser,
            aiUser: aiUser,
            controller: controller,
            onSendMessage: (_) {},
          ),
        ),
      ));

      expect(find.text('Example 1'), findsOneWidget);
      expect(find.text('Example 2'), findsOneWidget);
    });

    testWidgets('shows loading indicator when loading',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: AiChatWidget(
            config: AiChatConfig(
              aiName: 'AI',
              loadingConfig: const LoadingConfig(
                isLoading: true,
                loadingIndicator: CircularProgressIndicator(),
              ),
            ),
            currentUser: currentUser,
            aiUser: aiUser,
            controller: controller,
            onSendMessage: (_) {},
          ),
        ),
      ));

      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Test loading state change
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: AiChatWidget(
            config: AiChatConfig(
              aiName: 'AI',
              loadingConfig: const LoadingConfig(
                isLoading: false,
              ),
            ),
            currentUser: currentUser,
            aiUser: aiUser,
            controller: controller,
            onSendMessage: (_) {},
          ),
        ),
      ));

      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  });

  group('ChatMessagesController Tests', () {
    late ChatMessagesController controller;
    late ChatUser user;

    setUp(() {
      controller = ChatMessagesController();
      user = const ChatUser(id: '1', name: 'User');
    });

    test('initializes with empty messages', () {
      expect(controller.messages, isEmpty);
      expect(controller.showWelcomeMessage, true);
    });

    test('adds message correctly', () {
      final message = ChatMessage(
        text: 'Test',
        user: user,
        createdAt: DateTime.now(),
      );

      controller.addMessage(message);
      expect(controller.messages.length, 1);
      expect(controller.messages.first.text, 'Test');
      expect(controller.showWelcomeMessage, false);
    });

    test('updates message correctly', () {
      final id = DateTime.now().toString();
      final message1 = ChatMessage(
        text: 'Test 1',
        user: user,
        createdAt: DateTime.now(),
        customProperties: {'id': id},
      );
      final message2 = ChatMessage(
        text: 'Test 2',
        user: user,
        createdAt: DateTime.now(),
        customProperties: {'id': id},
      );

      controller.addMessage(message1);
      controller.updateMessage(message2);

      expect(controller.messages.length, 1);
      expect(controller.messages.first.text, 'Test 2');
    });

    test('clears messages correctly', () {
      controller.addMessage(ChatMessage(
        text: 'Test',
        user: user,
        createdAt: DateTime.now(),
      ));

      controller.clearMessages();
      expect(controller.messages, isEmpty);
      expect(controller.showWelcomeMessage, true);
    });

    test('handles example questions correctly', () {
      final currentUser = const ChatUser(id: '1', name: 'User');
      final aiUser = const ChatUser(id: '2', name: 'AI');
      const question = 'Test question';

      controller.handleExampleQuestion(question, currentUser, aiUser);

      expect(controller.showWelcomeMessage, false);
      expect(controller.messages.length, 1);
      expect(controller.messages.first.text, question);
      expect(controller.messages.first.user.id, currentUser.id);
    });

    test('initializes with provided messages', () {
      final initialMessages = [
        ChatMessage(
          text: 'Initial message',
          user: user,
          createdAt: DateTime.now(),
        ),
      ];

      final controller =
          ChatMessagesController(initialMessages: initialMessages);
      expect(controller.messages.length, 1);
      expect(controller.messages.first.text, 'Initial message');
    });
  });

  group('Scroll Behavior Tests', () {
    testWidgets('maintains scroll position with PageStorageKey',
        (WidgetTester tester) async {
      final controller = ChatMessagesController();
      final messages = List.generate(
        20,
        (i) => ChatMessage(
          text: 'Message $i',
          user: const ChatUser(id: '1', name: 'User'),
          createdAt: DateTime.now(),
        ),
      );

      controller.setMessages(messages);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: CustomChatWidget(
            currentUser: const ChatUser(id: '1', name: 'User'),
            messages: messages,
            onSend: (_) {},
            messageOptions: const MessageOptions(),
            inputOptions: const InputOptions(),
            typingUsers: null,
            messageListOptions: MessageListOptions(
              scrollPhysics: const ClampingScrollPhysics(),
            ),
            readOnly: false,
            quickReplyOptions: const QuickReplyOptions(),
            scrollToBottomOptions: const ScrollToBottomOptions(),
          ),
        ),
      ));

      // Initial frame
      await tester.pump();

      // Perform scroll
      final gesture =
          await tester.startGesture(tester.getCenter(find.byType(ListView)));
      await gesture.moveBy(const Offset(0, -300));
      await gesture.up();
      await tester.pump(); // Frame after gesture up
      await tester
          .pump(const Duration(milliseconds: 300)); // Wait for scroll animation

      final firstPosition = tester.getTopLeft(find.byType(ListView));

      // Trigger a rebuild
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: CustomChatWidget(
            currentUser: const ChatUser(id: '1', name: 'User'),
            messages: messages,
            onSend: (_) {},
            messageOptions: const MessageOptions(),
            inputOptions: const InputOptions(),
            typingUsers: null,
            messageListOptions: MessageListOptions(
              scrollPhysics: const ClampingScrollPhysics(),
            ),
            readOnly: false,
            quickReplyOptions: const QuickReplyOptions(),
            scrollToBottomOptions: const ScrollToBottomOptions(),
          ),
        ),
      ));

      await tester.pump(); // Frame after rebuild
      await tester
          .pump(const Duration(milliseconds: 300)); // Wait for any animations

      final secondPosition = tester.getTopLeft(find.byType(ListView));
      expect(firstPosition, secondPosition);
    });
  });

  group('Streaming Functionality Tests', () {
    testWidgets('handles streaming messages correctly',
        (WidgetTester tester) async {
      final controller = ChatMessagesController();
      final currentUser = const ChatUser(id: '1', name: 'User');
      final aiUser = const ChatUser(id: '2', name: 'AI');
      final initialText = 'Hello';
      final streamedText = 'Hello World';

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: AiChatWidget(
            config: AiChatConfig(
              aiName: 'AI',
              messageOptions: const MessageOptions(),
            ),
            controller: controller,
            currentUser: currentUser,
            aiUser: aiUser,
            onSendMessage: (_) async {},
          ),
        ),
      ));

      // Add initial streaming message
      controller.addMessage(ChatMessage(
        text: initialText,
        user: aiUser,
        createdAt: DateTime.now(),
        isMarkdown: true,
        customProperties: {'isStreaming': true},
      ));

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text(initialText), findsOneWidget);

      // Update with streamed content
      controller.updateMessage(ChatMessage(
        text: streamedText,
        user: aiUser,
        createdAt: DateTime.now(),
        isMarkdown: true,
        customProperties: {'isStreaming': true},
      ));

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text(streamedText), findsOneWidget);
    });

    test('message streaming state management', () {
      final controller = ChatMessagesController();
      final messageId = 'test_stream_2';
      final user = const ChatUser(id: '2', name: 'AI');

      // Initial streaming message
      controller.addMessage(ChatMessage(
        text: 'Initial',
        user: user,
        createdAt: DateTime.now(),
        customProperties: {'id': messageId, 'isStreaming': true},
      ));

      expect(controller.messages.length, 1);
      expect(controller.messages.first.text, 'Initial');
      expect(controller.messages.first.customProperties?['isStreaming'], true);

      // Update streaming message
      controller.updateMessage(ChatMessage(
        text: 'Updated',
        user: user,
        createdAt: DateTime.now(),
        customProperties: {'id': messageId, 'isStreaming': true},
      ));

      expect(controller.messages.length, 1);
      expect(controller.messages.first.text, 'Updated');
      expect(controller.messages.first.customProperties?['isStreaming'], true);

      // Complete streaming
      controller.updateMessage(ChatMessage(
        text: 'Final',
        user: user,
        createdAt: DateTime.now(),
        customProperties: {'id': messageId, 'isStreaming': false},
      ));

      expect(controller.messages.length, 1);
      expect(controller.messages.first.text, 'Final');
      expect(controller.messages.first.customProperties?['isStreaming'], false);
    });
  });
}
