import 'package:flutter_test/flutter_test.dart';
import 'package:personality_quiz_app/services/quiz_engine.dart';
import 'package:personality_quiz_app/services/quiz_loader_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('QuizLoaderService', () {
    test('loads all quizzes from bundled JSON', () async {
      final loader = QuizLoaderService();
      final quizzes = await loader.loadQuizzes();
      expect(quizzes.length, 5);
      final ids = quizzes.map((q) => q.id).toSet();
      expect(ids, containsAll(<String>[
        'introvert_extrovert',
        'career_personality',
        'emotional_intelligence',
        'leadership_style',
        'creative_analytical',
      ]));
      for (final q in quizzes) {
        expect(q.questions.length, greaterThanOrEqualTo(8));
        expect(q.results, isNotEmpty);
        for (final question in q.questions) {
          expect(question.options.length, 4);
        }
      }
    });

    test('each bundled quiz resolves a result for a full answer set', () async {
      final quizzes = await QuizLoaderService().loadQuizzes();
      for (final q in quizzes) {
        final answers = List<int>.filled(q.questions.length, 0);
        final scores = QuizEngine.aggregateScores(q, answers);
        final result = QuizEngine.resolveResult(q, scores);
        expect(result.title, isNotEmpty);
        expect(result.description, isNotEmpty);
      }
    });
  });
}
