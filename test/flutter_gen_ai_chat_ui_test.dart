import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';
import 'package:dash_chat_2/dash_chat_2.dart';

void main() {
  group('AiChatWidget Tests', () {
    late ChatUser currentUser;
    late ChatUser aiUser;
    late ChatMessagesController controller;

    setUp(() {
      currentUser = ChatUser(id: '1', firstName: 'User');
      aiUser = ChatUser(id: '2', firstName: 'AI');
      controller = ChatMessagesController();
    });

    testWidgets('renders correctly with minimal configuration',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: AiChatWidget(
            config: const AiChatConfig(),
            currentUser: currentUser,
            aiUser: aiUser,
            controller: controller,
            onSendMessage: (_) {},
          ),
        ),
      ));

      expect(find.byType(AiChatWidget), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byType(IconButton), findsOneWidget);
    });

    testWidgets('handles send message correctly', (WidgetTester tester) async {
      bool messageReceived = false;
      final message = 'Test message';

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: AiChatWidget(
            config: const AiChatConfig(),
            currentUser: currentUser,
            aiUser: aiUser,
            controller: controller,
            onSendMessage: (msg) {
              expect(msg.text, message);
              messageReceived = true;
            },
          ),
        ),
      ));

      await tester.enterText(find.byType(TextField), message);
      await tester.tap(find.byType(IconButton));
      await tester.pump();

      expect(messageReceived, true);
    });

    testWidgets('shows loading indicator when loading',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: AiChatWidget(
            config: const AiChatConfig(),
            currentUser: currentUser,
            aiUser: aiUser,
            controller: controller,
            onSendMessage: (_) {},
            isLoading: true,
            loadingIndicator: const LoadingWidget(),
          ),
        ),
      ));

      expect(find.byType(LoadingWidget), findsOneWidget);
    });

    testWidgets('shows example questions when provided',
        (WidgetTester tester) async {
      final examples = [
        ChatExample(
          question: 'Example 1',
          onTap: (_) {},
        ),
        ChatExample(
          question: 'Example 2',
          onTap: (_) {},
        ),
      ];

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: AiChatWidget(
            config: AiChatConfig(exampleQuestions: examples),
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

    testWidgets('handles example question tap correctly',
        (WidgetTester tester) async {
      bool exampleTapped = false;
      final examples = [
        ChatExample(
          question: 'Example 1',
          onTap: (_) {
            exampleTapped = true;
          },
        ),
      ];

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: AiChatWidget(
            config: AiChatConfig(exampleQuestions: examples),
            currentUser: currentUser,
            aiUser: aiUser,
            controller: controller,
            onSendMessage: (_) {},
          ),
        ),
      ));

      await tester.tap(find.text('Example 1'));
      await tester.pump();

      expect(exampleTapped, true);
    });
  });

  group('LoadingWidget Tests', () {
    testWidgets('renders correctly with default values',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: LoadingWidget(),
        ),
      ));

      expect(find.byType(LoadingWidget), findsOneWidget);
      expect(find.text('Loading...'), findsOneWidget);
    });

    testWidgets('cycles through texts with correct interval',
        (WidgetTester tester) async {
      const texts = ['Loading...', 'Please wait...', 'Almost there...'];
      const interval = Duration(milliseconds: 100);

      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: LoadingWidget(
            texts: texts,
            interval: interval,
          ),
        ),
      ));

      expect(find.text(texts[0]), findsOneWidget);

      await tester.pump(interval);
      expect(find.text(texts[1]), findsOneWidget);

      await tester.pump(interval);
      expect(find.text(texts[2]), findsOneWidget);

      await tester.pump(interval);
      expect(find.text(texts[0]), findsOneWidget);
    });

    testWidgets('applies custom text style correctly',
        (WidgetTester tester) async {
      const customStyle = TextStyle(
        fontSize: 20,
        color: Colors.red,
        fontWeight: FontWeight.bold,
      );

      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: LoadingWidget(
            textStyle: customStyle,
          ),
        ),
      ));

      final textWidget = tester.widget<Text>(find.text('Loading...'));
      expect(textWidget.style, equals(customStyle));
    });
  });

  group('ChatMessagesController Tests', () {
    late ChatMessagesController controller;
    late ChatUser user;

    setUp(() {
      controller = ChatMessagesController();
      user = ChatUser(id: '1');
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
      final currentUser = ChatUser(id: '1');
      final aiUser = ChatUser(id: '2');
      const question = 'Test question';

      controller.handleExampleQuestion(question, currentUser, aiUser);

      expect(controller.messages.length, 2);
      expect(controller.messages[1].text, question);
      expect(controller.messages[1].user.id, currentUser.id);
      expect(controller.messages[0].user.id, aiUser.id);
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

  group('ThemeProvider Tests', () {
    test('initializes with light theme', () {
      final provider = ThemeProvider();
      expect(provider.isDark, false);
      expect(provider.theme.brightness, Brightness.light);
    });

    test('toggles theme correctly', () {
      final provider = ThemeProvider();
      provider.toggleTheme();
      expect(provider.isDark, true);
      expect(provider.theme.brightness, Brightness.dark);

      provider.toggleTheme();
      expect(provider.isDark, false);
      expect(provider.theme.brightness, Brightness.light);
    });

    test('provides correct theme extension', () {
      final provider = ThemeProvider();

      // Light theme
      var extension = provider.theme.extension<CustomThemeExtension>();
      expect(extension, isNotNull);
      expect(extension?.chatBackground, equals(Colors.white));

      // Dark theme
      provider.toggleTheme();
      extension = provider.theme.extension<CustomThemeExtension>();
      expect(extension, isNotNull);
      expect(extension?.chatBackground, equals(const Color(0xFF1F1F28)));
    });

    test('copyWith works correctly', () {
      final provider = ThemeProvider();
      final extension = provider.theme.extension<CustomThemeExtension>();
      final newColor = Colors.blue;

      final copied = extension?.copyWith(chatBackground: newColor);
      expect(copied?.chatBackground, equals(newColor));
      expect(copied?.messageBubbleColor, equals(extension?.messageBubbleColor));
    });
  });

  group('AiChatConfig Tests', () {
    test('creates with default values', () {
      const config = AiChatConfig();
      expect(config.userName, equals('User'));
      expect(config.aiName, equals('AI'));
      expect(config.hintText, equals('Type a message...'));
      expect(config.enableAnimation, isTrue);
      expect(config.showTimestamp, isTrue);
      expect(config.exampleQuestions, isEmpty);
    });

    test('creates with custom values', () {
      final config = AiChatConfig(
        userName: 'Custom User',
        aiName: 'Custom AI',
        hintText: 'Custom hint',
        enableAnimation: false,
        showTimestamp: false,
        exampleQuestions: [
          ChatExample(question: 'Example', onTap: (_) {}),
        ],
      );

      expect(config.userName, equals('Custom User'));
      expect(config.aiName, equals('Custom AI'));
      expect(config.hintText, equals('Custom hint'));
      expect(config.enableAnimation, isFalse);
      expect(config.showTimestamp, isFalse);
      expect(config.exampleQuestions.length, equals(1));
    });
  });
}
