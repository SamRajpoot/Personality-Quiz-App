import 'package:flutter/services.dart';

/// Lightweight feedback (system click + haptics). Callers pass flags from settings.
Future<void> playTapFeedback({required bool soundEnabled, required bool hapticsEnabled}) async {
  if (hapticsEnabled) {
    await HapticFeedback.selectionClick();
  }
  if (soundEnabled) {
    SystemSound.play(SystemSoundType.click);
  }
}
