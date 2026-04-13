import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const _onboardingKey = 'ps_onboarding_done';
  static const _themeKey = 'ps_theme_mode';
  static const _soundKey = 'ps_sound_enabled';
  static const _hapticsKey = 'ps_haptics_enabled';
  static const _favoritesKey = 'ps_favorite_quiz_ids';
  static const _progressPrefix = 'ps_quiz_progress_';

  Future<SharedPreferences> get _p async => SharedPreferences.getInstance();

  Future<bool> isOnboardingComplete() async {
    final p = await _p;
    return p.getBool(_onboardingKey) ?? false;
  }

  Future<void> setOnboardingComplete(bool v) async {
    final p = await _p;
    await p.setBool(_onboardingKey, v);
  }

  Future<String?> getThemeMode() async {
    final p = await _p;
    return p.getString(_themeKey);
  }

  Future<void> setThemeMode(String mode) async {
    final p = await _p;
    await p.setString(_themeKey, mode);
  }

  Future<bool> isSoundEnabled() async {
    final p = await _p;
    return p.getBool(_soundKey) ?? true;
  }

  Future<void> setSoundEnabled(bool v) async {
    final p = await _p;
    await p.setBool(_soundKey, v);
  }

  Future<bool> isHapticsEnabled() async {
    final p = await _p;
    return p.getBool(_hapticsKey) ?? true;
  }

  Future<void> setHapticsEnabled(bool v) async {
    final p = await _p;
    await p.setBool(_hapticsKey, v);
  }

  Future<Set<String>> getFavoriteQuizIds() async {
    final p = await _p;
    final list = p.getStringList(_favoritesKey) ?? [];
    return list.toSet();
  }

  Future<void> setFavoriteQuizIds(Set<String> ids) async {
    final p = await _p;
    await p.setStringList(_favoritesKey, ids.toList());
  }

  Future<QuizProgressSnapshot?> getQuizProgress(String quizId) async {
    final p = await _p;
    final raw = p.getString('$_progressPrefix$quizId');
    if (raw == null || raw.isEmpty) return null;
    try {
      final m = jsonDecode(raw) as Map<String, dynamic>;
      return QuizProgressSnapshot.fromJson(m);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveQuizProgress(String quizId, QuizProgressSnapshot snap) async {
    final p = await _p;
    await p.setString('$_progressPrefix$quizId', jsonEncode(snap.toJson()));
  }

  Future<void> clearQuizProgress(String quizId) async {
    final p = await _p;
    await p.remove('$_progressPrefix$quizId');
  }

  Future<void> clearAllQuizProgress() async {
    final p = await _p;
    final keys = p.getKeys().where((k) => k.startsWith(_progressPrefix));
    for (final k in keys) {
      await p.remove(k);
    }
  }

  Future<void> resetAllData() async {
    final p = await _p;
    await p.remove(_favoritesKey);
    await clearAllQuizProgress();
    await p.remove(_onboardingKey);
  }
}

class QuizProgressSnapshot {
  QuizProgressSnapshot({
    required this.questionIndex,
    required this.answers,
  });

  factory QuizProgressSnapshot.fromJson(Map<String, dynamic> json) {
    final ans = (json['answers'] as List<dynamic>? ?? []).map((e) => e as int).toList();
    return QuizProgressSnapshot(
      questionIndex: json['questionIndex'] as int? ?? 0,
      answers: ans,
    );
  }

  final int questionIndex;
  final List<int> answers;

  Map<String, dynamic> toJson() => {
        'questionIndex': questionIndex,
        'answers': answers,
      };
}
