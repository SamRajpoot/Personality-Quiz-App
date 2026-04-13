import 'question_model.dart';
import 'quiz_result_model.dart';

enum ScoringMode { dominantTrait, scoreBand }

class QuizModel {
  const QuizModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.iconName,
    required this.accentHue,
    required this.scoringMode,
    required this.questions,
    required this.results,
    required this.tieBreakerOrder,
    this.scoreMetricKey,
  });

  final String id;
  final String title;
  final String subtitle;
  final String iconName;
  final double accentHue;
  final ScoringMode scoringMode;
  final List<QuestionModel> questions;
  final List<QuizResultModel> results;
  final List<String> tieBreakerOrder;
  final String? scoreMetricKey;

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    final mode = (json['scoringMode'] as String? ?? 'dominant_trait') == 'score_band'
        ? ScoringMode.scoreBand
        : ScoringMode.dominantTrait;
    final qs = (json['questions'] as List<dynamic>? ?? [])
        .map((e) => QuestionModel.fromJson(e as Map<String, dynamic>))
        .toList();
    final rs = (json['results'] as List<dynamic>? ?? [])
        .map((e) => QuizResultModel.fromJson(e as Map<String, dynamic>))
        .toList();
    final tie = (json['tieBreakerOrder'] as List<dynamic>? ?? [])
        .map((e) => '$e')
        .toList();
    return QuizModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      iconName: json['iconName'] as String? ?? 'quiz',
      accentHue: (json['accentHue'] as num?)?.toDouble() ?? 260,
      scoringMode: mode,
      questions: qs,
      results: rs,
      tieBreakerOrder: tie,
      scoreMetricKey: json['scoreMetricKey'] as String?,
    );
  }
}
