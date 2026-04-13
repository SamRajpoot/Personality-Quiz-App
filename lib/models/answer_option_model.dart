class AnswerOptionModel {
  const AnswerOptionModel({
    required this.label,
    required this.scores,
  });

  final String label;
  final Map<String, double> scores;

  factory AnswerOptionModel.fromJson(Map<String, dynamic> json) {
    final raw = json['scores'];
    final map = <String, double>{};
    if (raw is Map) {
      raw.forEach((k, v) {
        map[k.toString()] = (v is num) ? v.toDouble() : double.tryParse('$v') ?? 0;
      });
    }
    return AnswerOptionModel(
      label: json['label'] as String? ?? '',
      scores: map,
    );
  }
}
