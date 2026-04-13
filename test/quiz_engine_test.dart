import 'package:flutter_test/flutter_test.dart';
import 'package:personality_quiz_app/models/answer_option_model.dart';
import 'package:personality_quiz_app/models/question_model.dart';
import 'package:personality_quiz_app/models/quiz_model.dart';
import 'package:personality_quiz_app/models/quiz_result_model.dart';
import 'package:personality_quiz_app/services/quiz_engine.dart';

void main() {
  group('QuizEngine', () {
    test('aggregateScores skips unanswered and sums traits', () {
      final quiz = QuizModel(
        id: 't',
        title: 't',
        subtitle: 't',
        iconName: 'quiz',
        accentHue: 0,
        scoringMode: ScoringMode.dominantTrait,
        tieBreakerOrder: const ['a', 'b'],
        questions: [
          QuestionModel(
            id: 'q1',
            text: 'Q1',
            options: [
              const AnswerOptionModel(label: 'x', scores: {'a': 2, 'b': 0}),
              const AnswerOptionModel(label: 'y', scores: {'a': 0, 'b': 3}),
            ],
          ),
          QuestionModel(
            id: 'q2',
            text: 'Q2',
            options: [
              const AnswerOptionModel(label: 'x', scores: {'a': 1, 'b': 1}),
            ],
          ),
        ],
        results: const [],
      );

      final scores = QuizEngine.aggregateScores(quiz, [0, -1]);
      expect(scores['a'], 2.0);
      expect(scores['b'], isNull);
    });

    test('resolveResult picks dominant trait', () {
      final quiz = QuizModel(
        id: 't',
        title: 't',
        subtitle: 't',
        iconName: 'quiz',
        accentHue: 0,
        scoringMode: ScoringMode.dominantTrait,
        tieBreakerOrder: const ['a', 'b'],
        questions: const [],
        results: [
          const QuizResultModel(
            id: 'ra',
            title: 'A',
            subtitle: 'sa',
            description: 'd',
            strengths: [],
            weaknesses: [],
            suggestions: [],
            dominantTrait: 'a',
          ),
          const QuizResultModel(
            id: 'rb',
            title: 'B',
            subtitle: 'sb',
            description: 'd',
            strengths: [],
            weaknesses: [],
            suggestions: [],
            dominantTrait: 'b',
          ),
        ],
      );

      final r = QuizEngine.resolveResult(quiz, {'a': 5, 'b': 2});
      expect(r.id, 'ra');
    });

    test('resolveResult uses score bands', () {
      final quiz = QuizModel(
        id: 't',
        title: 't',
        subtitle: 't',
        iconName: 'quiz',
        accentHue: 0,
        scoringMode: ScoringMode.scoreBand,
        tieBreakerOrder: const [],
        scoreMetricKey: 'eq',
        questions: const [],
        results: [
          const QuizResultModel(
            id: 'low',
            title: 'Low',
            subtitle: 's',
            description: 'd',
            strengths: [],
            weaknesses: [],
            suggestions: [],
            minScore: 0,
            maxScore: 5,
          ),
          const QuizResultModel(
            id: 'high',
            title: 'High',
            subtitle: 's',
            description: 'd',
            strengths: [],
            weaknesses: [],
            suggestions: [],
            minScore: 6,
            maxScore: 100,
          ),
        ],
      );

      final low = QuizEngine.resolveResult(quiz, {'eq': 3});
      expect(low.id, 'low');
      final high = QuizEngine.resolveResult(quiz, {'eq': 9});
      expect(high.id, 'high');
    });
  });
}
