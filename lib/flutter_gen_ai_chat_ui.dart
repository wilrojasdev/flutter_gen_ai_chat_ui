/// A Flutter package that provides a customizable chat UI for AI applications,
/// featuring streaming responses, code highlighting, and markdown support.
library flutter_gen_ai_chat_ui;

export 'package:dash_chat_2/dash_chat_2.dart'
    show ChatUser, ChatMessage, MessageOptions, QuickReplyOptions;

export 'src/controllers/chat_messages_controller.dart';
export 'src/models/ai_chat_config.dart';
export 'src/models/example_question_config.dart';
export 'src/models/input_options.dart';
export 'src/models/welcome_message_config.dart';
export 'src/theme/custom_theme_extension.dart';
export 'src/widgets/ai_chat_widget.dart';
export 'src/widgets/animated_bubble.dart';
export 'src/widgets/animated_text_message.dart';
export 'src/widgets/loading_widget.dart';
