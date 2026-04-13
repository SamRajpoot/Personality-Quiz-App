import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personality_quiz_app/models/answer_option_model.dart';
import 'package:personality_quiz_app/models/question_model.dart';
import 'package:personality_quiz_app/models/quiz_model.dart';
import 'package:personality_quiz_app/models/quiz_result_model.dart';
import 'package:personality_quiz_app/screens/quiz_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Quiz screen shows question and options', (tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});

    final quiz = QuizModel(
      id: 'widget_quiz',
      title: 'Sample Quiz',
      subtitle: 'Sub',
      iconName: 'quiz',
      accentHue: 260,
      scoringMode: ScoringMode.dominantTrait,
      tieBreakerOrder: const ['x', 'y'],
      questions: [
        QuestionModel(
          id: 'q1',
          text: 'What resonates most?',
          options: const [
            AnswerOptionModel(label: 'Option Alpha', scores: {'x': 1}),
            AnswerOptionModel(label: 'Option Beta', scores: {'y': 1}),
            AnswerOptionModel(label: 'Option Gamma', scores: {'x': 1, 'y': 1}),
            AnswerOptionModel(label: 'Option Delta', scores: {'y': 1}),
          ],
        ),
      ],
      results: const [
        QuizResultModel(
          id: 'rx',
          title: 'X',
          subtitle: 'sx',
          description: 'd',
          strengths: [],
          weaknesses: [],
          suggestions: [],
          dominantTrait: 'x',
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: ThemeData.light(),
          home: QuizScreen(quiz: quiz, forceFresh: true),
        ),
      ),
    );
    await tester.pump();
    await tester.pumpAndSettle(const Duration(seconds: 2));

    expect(find.text('Sample Quiz'), findsOneWidget);
    expect(find.text('What resonates most?'), findsOneWidget);
    expect(find.text('Option Alpha'), findsOneWidget);
  });
}
