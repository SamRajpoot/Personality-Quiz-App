class QuizResultModel {
  const QuizResultModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.strengths,
    required this.weaknesses,
    required this.suggestions,
    this.dominantTrait,
    this.minScore,
    this.maxScore,
  });

  final String id;
  final String title;
  final String subtitle;
  final String description;
  final List<String> strengths;
  final List<String> weaknesses;
  final List<String> suggestions;
  final String? dominantTrait;
  final double? minScore;
  final double? maxScore;

  factory QuizResultModel.fromJson(Map<String, dynamic> json) {
    List<String> listOfString(String key) {
      final v = json[key];
      if (v is List) {
        return v.map((e) => '$e').toList();
      }
      return const [];
    }

    return QuizResultModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      description: json['description'] as String? ?? '',
      strengths: listOfString('strengths'),
      weaknesses: listOfString('weaknesses'),
      suggestions: listOfString('suggestions'),
      dominantTrait: json['dominantTrait'] as String?,
      minScore: (json['minScore'] as num?)?.toDouble(),
      maxScore: (json['maxScore'] as num?)?.toDouble(),
    );
  }
}
