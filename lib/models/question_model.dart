import 'answer_option_model.dart';

class QuestionModel {
  const QuestionModel({
    required this.id,
    required this.text,
    required this.options,
  });

  final String id;
  final String text;
  final List<AnswerOptionModel> options;

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    final opts = (json['options'] as List<dynamic>? ?? [])
        .map((e) => AnswerOptionModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return QuestionModel(
      id: json['id'] as String? ?? '',
      text: json['text'] as String? ?? '',
      options: opts,
    );
  }
}
