import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/app_constants.dart';
import '../providers/settings_providers.dart';
import '../widgets/glass_card.dart';
import '../widgets/persona_backdrop.dart';
import 'splash_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsProvider);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: const Text('Settings')),
      body: PersonaBackdrop(
        hue: 250,
        child: SafeArea(
          child: settingsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Settings unavailable\n$e')),
            data: (s) {
              return ListView(
                padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
                physics: const BouncingScrollPhysics(),
                children: [
                  Text(
                    AppConstants.philosophy,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                  ),
                  const SizedBox(height: 16),
                  GlassCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Appearance', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                        const SizedBox(height: 10),
                        SegmentedButton<ThemeMode>(
                          segments: const [
                            ButtonSegment(value: ThemeMode.light, label: Text('Light'), icon: Icon(Icons.light_mode_outlined)),
                            ButtonSegment(value: ThemeMode.dark, label: Text('Dark'), icon: Icon(Icons.dark_mode_outlined)),
                            ButtonSegment(value: ThemeMode.system, label: Text('Auto'), icon: Icon(Icons.brightness_auto_rounded)),
                          ],
                          selected: {s.themeMode},
                          onSelectionChanged: (set) {
                            ref.read(settingsProvider.notifier).setThemeMode(set.first);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  GlassCard(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        SwitchListTile(
                          title: const Text('Sound feedback'),
                          subtitle: const Text('Subtle system clicks for interactions'),
                          value: s.soundEnabled,
                          onChanged: (v) => ref.read(settingsProvider.notifier).setSoundEnabled(v),
                        ),
                        SwitchListTile(
                          title: const Text('Haptics'),
                          subtitle: const Text('Light vibration on supported devices'),
                          value: s.hapticsEnabled,
                          onChanged: (v) => ref.read(settingsProvider.notifier).setHapticsEnabled(v),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  GlassCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Data', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                        const SizedBox(height: 8),
                        Text(
                          'Clears favorites, saved quiz progress, and onboarding (you will see onboarding again).',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.35),
                        ),
                        const SizedBox(height: 12),
                        FilledButton.tonal(
                          onPressed: () async {
                            final ok = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Reset all data?'),
                                content: const Text('This cannot be undone.'),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                                  FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Reset')),
                                ],
                              ),
                            );
                            if (ok == true) {
                              await ref.read(storageServiceProvider).resetAllData();
                              ref.invalidate(favoritesProvider);
                              ref.invalidate(onboardingCompleteProvider);
                              ref.invalidate(settingsProvider);
                              if (context.mounted) {
                                Navigator.of(context).pushAndRemoveUntil<void>(
                                  MaterialPageRoute<void>(builder: (_) => const SplashScreen()),
                                  (_) => false,
                                );
                              }
                            }
                          },
                          child: const Text('Reset local data'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Version ${AppConstants.version} (${AppConstants.buildNumber})',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.55),
                        ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
