import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/storage_service.dart';

final storageServiceProvider = Provider<StorageService>((ref) => StorageService());

class SettingsSnapshot {
  const SettingsSnapshot({
    required this.themeMode,
    required this.soundEnabled,
    required this.hapticsEnabled,
  });

  final ThemeMode themeMode;
  final bool soundEnabled;
  final bool hapticsEnabled;
}

class SettingsNotifier extends AsyncNotifier<SettingsSnapshot> {
  @override
  Future<SettingsSnapshot> build() async {
    final storage = ref.read(storageServiceProvider);
    final themeStr = await storage.getThemeMode();
    final mode = switch (themeStr) {
      'dark' => ThemeMode.dark,
      'light' => ThemeMode.light,
      _ => ThemeMode.system,
    };
    return SettingsSnapshot(
      themeMode: mode,
      soundEnabled: await storage.isSoundEnabled(),
      hapticsEnabled: await storage.isHapticsEnabled(),
    );
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final storage = ref.read(storageServiceProvider);
    final s = switch (mode) {
      ThemeMode.dark => 'dark',
      ThemeMode.light => 'light',
      _ => 'system',
    };
    await storage.setThemeMode(s);
    final cur = state.value ?? await future;
    state = AsyncData(
      SettingsSnapshot(
        themeMode: mode,
        soundEnabled: cur.soundEnabled,
        hapticsEnabled: cur.hapticsEnabled,
      ),
    );
  }

  Future<void> setSoundEnabled(bool v) async {
    await ref.read(storageServiceProvider).setSoundEnabled(v);
    final cur = state.value ?? await future;
    state = AsyncData(SettingsSnapshot(themeMode: cur.themeMode, soundEnabled: v, hapticsEnabled: cur.hapticsEnabled));
  }

  Future<void> setHapticsEnabled(bool v) async {
    await ref.read(storageServiceProvider).setHapticsEnabled(v);
    final cur = state.value ?? await future;
    state = AsyncData(SettingsSnapshot(themeMode: cur.themeMode, soundEnabled: cur.soundEnabled, hapticsEnabled: v));
  }
}

final settingsProvider = AsyncNotifierProvider<SettingsNotifier, SettingsSnapshot>(SettingsNotifier.new);

final onboardingCompleteProvider = FutureProvider<bool>((ref) async {
  return ref.read(storageServiceProvider).isOnboardingComplete();
});

final favoritesProvider = AsyncNotifierProvider<FavoritesNotifier, Set<String>>(FavoritesNotifier.new);

class FavoritesNotifier extends AsyncNotifier<Set<String>> {
  @override
  Future<Set<String>> build() async {
    return ref.read(storageServiceProvider).getFavoriteQuizIds();
  }

  Future<void> toggle(String quizId) async {
    final storage = ref.read(storageServiceProvider);
    final cur = Set<String>.from(await future);
    if (cur.contains(quizId)) {
      cur.remove(quizId);
    } else {
      cur.add(quizId);
    }
    await storage.setFavoriteQuizIds(cur);
    state = AsyncData(cur);
  }
}
