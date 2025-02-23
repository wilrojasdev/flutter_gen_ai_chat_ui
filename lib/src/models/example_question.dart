import 'example_question_config.dart';

class ExampleQuestion {
  final String question;
  final ExampleQuestionConfig? config;

  const ExampleQuestion({
    required this.question,
    this.config,
  });
}
