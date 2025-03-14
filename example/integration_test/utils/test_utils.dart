import 'package:flutter/material.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';
import 'package:flutter_test/flutter_test.dart';

/// Test utilities for integration tests of the Flutter Gen AI Chat UI package
class TestUtils {
  /// Creates a test app with the AiChatWidget
  static Widget createTestApp({
    required ChatMessagesController controller,
    AiChatConfig? config,
    ChatUser? currentUser,
    ChatUser? aiUser,
    void Function(ChatMessage)? onSendMessage,
    bool darkMode = false,
  }) {
    return MaterialApp(
      theme: darkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        body: AiChatWidget(
          controller: controller,
          currentUser:
              currentUser ?? const ChatUser(id: 'user-1', name: 'Test User'),
          aiUser: aiUser ?? const ChatUser(id: 'ai-1', name: 'Test AI'),
          onSendMessage: onSendMessage ?? (message) {},
          // Use individual config properties instead of top-level config parameter
          inputOptions: config?.inputOptions,
          messageOptions: config?.messageOptions,
          messageListOptions: config?.messageListOptions,
          welcomeMessageConfig: config?.welcomeMessageConfig,
          exampleQuestions: config?.exampleQuestions ?? const [],
          persistentExampleQuestions:
              config?.persistentExampleQuestions ?? false,
          enableAnimation: config?.enableAnimation ?? true,
          maxWidth: config?.maxWidth,
          loadingConfig: config?.loadingConfig ?? const LoadingConfig(),
          paginationConfig:
              config?.paginationConfig ?? const PaginationConfig(),
          padding: config?.padding,
          enableMarkdownStreaming: config?.enableMarkdownStreaming ?? true,
          streamingDuration:
              config?.streamingDuration ?? const Duration(milliseconds: 30),
          markdownStyleSheet: config?.markdownStyleSheet,
          readOnly: config?.readOnly ?? false,
          typingUsers: config?.typingUsers,
        ),
      ),
    );
  }

  /// Creates a chat messages controller with optional initial messages
  static ChatMessagesController createController({
    List<ChatMessage>? initialMessages,
  }) {
    return ChatMessagesController(
      initialMessages: initialMessages ?? [],
    );
  }

  /// Generates a user message
  static ChatMessage generateUserMessage({
    required String text,
    String userId = 'user-1',
    String userName = 'Test User',
  }) {
    return ChatMessage(
      text: text,
      user: ChatUser(id: userId, name: userName),
      createdAt: DateTime.now(),
    );
  }

  /// Generates an AI message
  static ChatMessage generateAiMessage({
    required String text,
    String aiId = 'ai-1',
    String aiName = 'Test AI',
    bool isStreaming = false,
  }) {
    return ChatMessage(
      text: text,
      user: ChatUser(id: aiId, name: aiName),
      createdAt: DateTime.now(),
      customProperties: isStreaming ? {'isStreaming': true} : null,
    );
  }

  /// Finds the chat input field
  static Finder findChatInputField() {
    return find.byType(TextField);
  }

  /// Finds the send button using its default icon
  static Finder findSendButton() {
    return find.byIcon(Icons.send);
  }

  /// Finds a message with the given text
  static Finder findMessageWithText(String text) {
    return find.text(text, findRichText: true);
  }

  /// Types a message in the input field and sends it
  static Future<void> sendMessage(WidgetTester tester, String text) async {
    await tester.tap(findChatInputField());
    await tester.pump();

    await tester.enterText(findChatInputField(), text);
    await tester.pump();

    await tester.tap(findSendButton());
    await tester.pump();

    // Wait for animations to complete
    await tester.pumpAndSettle();
  }

  /// Finds example questions
  static Finder findExampleQuestion(String questionText) {
    return find.widgetWithText(Chip, questionText);
  }

  /// Finds all message bubbles
  static Finder findMessageBubbles() {
    // Just look for containers that could be message bubbles
    // A simpler implementation that should work for testing
    return find.byWidgetPredicate((widget) {
      if (widget is Container && widget.decoration is BoxDecoration) {
        final decoration = widget.decoration as BoxDecoration;
        return decoration.color != null;
      }
      return false;
    });
  }

  /// Finds the loading indicator in the chat
  static Finder findLoadingIndicator() {
    return find.byType(CircularProgressIndicator);
  }

  /// Creates an example welcome message configuration
  static WelcomeMessageConfig createWelcomeMessageConfig() {
    return const WelcomeMessageConfig(
      title: 'Welcome to the chat',
    );
  }
}
