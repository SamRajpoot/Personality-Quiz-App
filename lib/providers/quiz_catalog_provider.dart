import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/quiz_model.dart';
import '../services/quiz_loader_service.dart';

final quizLoaderProvider = Provider<QuizLoaderService>((ref) => QuizLoaderService());

final quizzesProvider = FutureProvider<List<QuizModel>>((ref) async {
  final loader = ref.read(quizLoaderProvider);
  return loader.loadQuizzes();
});
