import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

// A static loading indicator for tests to avoid animation issues
class TestLoadingIndicator extends StatelessWidget {
  const TestLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
          width: 2,
        ),
      ),
    );
  }
}

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

  Future<void> pumpChatWidget(WidgetTester tester, Widget widget) async {
    await mockNetworkImagesFor(() async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: widget,
          ),
        ),
      );

      // Wait for initial frame
      await tester.pump();

      // Wait for a reasonable time for animations to progress
      await tester.pump(const Duration(milliseconds: 500));
    });
  }

  group('Visual Regression Tests - Light Theme', () {
    testGoldens('empty chat state matches golden', (tester) async {
      await pumpChatWidget(
        tester,
        RepaintBoundary(
          child: AiChatWidget(
            config: AiChatConfig(aiName: 'Test AI'),
            controller: controller,
            currentUser: currentUser,
            aiUser: aiUser,
            onSendMessage: (_) {},
          ),
        ),
      );

      await screenMatchesGolden(tester, 'light_theme_empty_chat');
    });

    testGoldens('chat with messages matches golden', (tester) async {
      controller.addMessage(ChatMessage(
        text: 'Hello!',
        user: currentUser,
        createdAt: DateTime(2024),
      ));

      controller.addMessage(ChatMessage(
        text: 'Hi there! How can I help you today?',
        user: aiUser,
        createdAt: DateTime(2024),
      ));

      await pumpChatWidget(
        tester,
        RepaintBoundary(
          child: AiChatWidget(
            config: AiChatConfig(aiName: 'Test AI'),
            controller: controller,
            currentUser: currentUser,
            aiUser: aiUser,
            onSendMessage: (_) {},
          ),
        ),
      );

      await screenMatchesGolden(tester, 'light_theme_with_messages');
    });

    testGoldens('loading state matches golden', (tester) async {
      await pumpChatWidget(
        tester,
        RepaintBoundary(
          child: AiChatWidget(
            config: AiChatConfig(
              aiName: 'Test AI',
              loadingConfig: const LoadingConfig(
                isLoading: true,
                loadingIndicator: TestLoadingIndicator(),
              ),
            ),
            controller: controller,
            currentUser: currentUser,
            aiUser: aiUser,
            onSendMessage: (_) {},
          ),
        ),
      );

      await screenMatchesGolden(tester, 'light_theme_loading_state');
    });
  });

  group('Visual Regression Tests - Dark Theme', () {
    testGoldens('empty chat state matches golden', (tester) async {
      await pumpChatWidget(
        tester,
        Theme(
          data: ThemeData.dark(),
          child: RepaintBoundary(
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

      await screenMatchesGolden(tester, 'dark_theme_empty_chat');
    });

    testGoldens('chat with messages matches golden', (tester) async {
      controller.addMessage(ChatMessage(
        text: 'Hello!',
        user: currentUser,
        createdAt: DateTime(2024),
      ));

      controller.addMessage(ChatMessage(
        text: 'Hi there! How can I help you today?',
        user: aiUser,
        createdAt: DateTime(2024),
      ));

      await pumpChatWidget(
        tester,
        Theme(
          data: ThemeData.dark(),
          child: RepaintBoundary(
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

      await screenMatchesGolden(tester, 'dark_theme_with_messages');
    });

    testGoldens('loading state matches golden', (tester) async {
      await pumpChatWidget(
        tester,
        Theme(
          data: ThemeData.dark(),
          child: RepaintBoundary(
            child: AiChatWidget(
              config: AiChatConfig(
                aiName: 'Test AI',
                loadingConfig: const LoadingConfig(
                  isLoading: true,
                  loadingIndicator: TestLoadingIndicator(),
                ),
              ),
              controller: controller,
              currentUser: currentUser,
              aiUser: aiUser,
              onSendMessage: (_) {},
            ),
          ),
        ),
      );

      await screenMatchesGolden(tester, 'dark_theme_loading_state');
    });
  });

  group('Visual Regression Tests - RTL', () {
    testGoldens('RTL layout matches golden', (tester) async {
      await pumpChatWidget(
        tester,
        Theme(
          data: ThemeData.light(),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: RepaintBoundary(
              child: AiChatWidget(
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

      await screenMatchesGolden(tester, 'rtl_layout');
    });
  });
}
