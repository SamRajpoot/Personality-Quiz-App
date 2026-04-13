import '../models/quiz_model.dart';
import '../models/quiz_result_model.dart';

/// Pure scoring logic (unit-tested).
class QuizEngine {
  const QuizEngine._();

  static Map<String, double> aggregateScores(
    QuizModel quiz,
    List<int> selectedOptionIndices,
  ) {
    final scores = <String, double>{};
    final n = quiz.questions.length;
    for (var i = 0; i < n; i++) {
      if (i >= selectedOptionIndices.length) break;
      final idx = selectedOptionIndices[i];
      if (idx < 0) continue;
      final q = quiz.questions[i];
      if (idx >= q.options.length) continue;
      final opt = q.options[idx];
      opt.scores.forEach((k, v) {
        if (v == 0) return;
        scores[k] = (scores[k] ?? 0) + v;
      });
    }
    return scores;
  }

  static double metricTotal(QuizModel quiz, Map<String, double> scores) {
    final key = quiz.scoreMetricKey;
    if (key != null && key.isNotEmpty) {
      return scores[key] ?? 0;
    }
    var t = 0.0;
    for (final v in scores.values) {
      t += v;
    }
    return t;
  }

  static QuizResultModel resolveResult(QuizModel quiz, Map<String, double> scores) {
    if (quiz.results.isEmpty) {
      throw StateError('Quiz ${quiz.id} has no results');
    }
    switch (quiz.scoringMode) {
      case ScoringMode.scoreBand:
        return _resolveScoreBand(quiz, scores);
      case ScoringMode.dominantTrait:
        return _resolveDominant(quiz, scores);
    }
  }

  static QuizResultModel _resolveScoreBand(QuizModel quiz, Map<String, double> scores) {
    final total = metricTotal(quiz, scores);
    QuizResultModel? match;
    for (final r in quiz.results) {
      final minS = r.minScore ?? double.negativeInfinity;
      final maxS = r.maxScore ?? double.infinity;
      if (total >= minS && total <= maxS) {
        match = r;
        break;
      }
    }
    return match ?? quiz.results.first;
  }

  static QuizResultModel _resolveDominant(QuizModel quiz, Map<String, double> scores) {
    if (scores.isEmpty) {
      return quiz.results.first;
    }
    var best = double.negativeInfinity;
    final winners = <String>[];
    scores.forEach((trait, v) {
      if (v > best) {
        best = v;
        winners
          ..clear()
          ..add(trait);
      } else if (v == best) {
        winners.add(trait);
      }
    });
    if (winners.length == 1) {
      final trait = winners.single;
      final byTrait = quiz.results.where((r) => r.dominantTrait == trait).toList();
      if (byTrait.isNotEmpty) return byTrait.first;
    } else {
      for (final t in quiz.tieBreakerOrder) {
        if (winners.contains(t)) {
          final byTrait = quiz.results.where((r) => r.dominantTrait == t).toList();
          if (byTrait.isNotEmpty) return byTrait.first;
        }
      }
    }
    for (final r in quiz.results) {
      if (r.dominantTrait != null && winners.contains(r.dominantTrait)) {
        return r;
      }
    }
    return quiz.results.first;
  }
}
