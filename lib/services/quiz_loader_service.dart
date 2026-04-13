import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/quiz_model.dart';

class QuizLoaderService {
  QuizLoaderService({
    this.catalogPath = 'assets/data/catalog.json',
  });

  final String catalogPath;

  Future<List<QuizModel>> loadQuizzes() async {
    final catalogRaw = await rootBundle.loadString(catalogPath);
    final catalog = jsonDecode(catalogRaw) as Map<String, dynamic>;
    final files = (catalog['files'] as List<dynamic>? ?? []).map((e) => '$e').toList();
    final quizzes = <QuizModel>[];
    for (final path in files) {
      final raw = await rootBundle.loadString(path);
      final map = jsonDecode(raw) as Map<String, dynamic>;
      quizzes.add(QuizModel.fromJson(map));
    }
    return quizzes;
  }
}
