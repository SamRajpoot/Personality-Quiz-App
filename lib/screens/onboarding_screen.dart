import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/app_constants.dart';
import '../providers/settings_providers.dart';
import '../widgets/glass_card.dart';
import '../widgets/neon_primary_button.dart';
import 'home_screen.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;

  static const _slides = [
    _Slide(
      title: 'Science-meets-style quizzes',
      body: 'Explore curated journeys that reveal how you think, lead, create, and connect—without noisy feeds or accounts.',
      icon: Icons.auto_awesome_rounded,
    ),
    _Slide(
      title: 'Results worth sharing',
      body: 'Get a polished breakdown with strengths, growth edges, and next steps—then share a beautiful card in one tap.',
      icon: Icons.ios_share_rounded,
    ),
    _Slide(
      title: 'Offline, private, yours',
      body: 'Everything runs on-device. Save progress, favorite quizzes, and pick light or dark glass themes anytime.',
      icon: Icons.lock_outline_rounded,
    ),
  ];

  Future<void> _finish() async {
    await ref.read(storageServiceProvider).setOnboardingComplete(true);
    ref.invalidate(onboardingCompleteProvider);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const HomeScreen()),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Theme.of(context).scaffoldBackgroundColor,
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _finish,
                  child: const Text('Skip'),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: _slides.length,
                  onPageChanged: (i) => setState(() => _page = i),
                  itemBuilder: (context, i) {
                    final s = _slides[i];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GlassCard(
                            padding: const EdgeInsets.all(26),
                            child: Column(
                              children: [
                                Icon(s.icon, size: 56, color: scheme.primary),
                                const SizedBox(height: 18),
                                Text(
                                  s.title,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  s.body,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                        color: scheme.onSurface.withValues(alpha: 0.72),
                                        height: 1.35,
                                      ),
                                ),
                              ],
                            ),
                          ).animate().fadeIn(duration: 450.ms).slideY(begin: 0.08, curve: Curves.easeOutCubic),
                          const SizedBox(height: 18),
                          Text(
                            AppConstants.philosophy,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                  color: scheme.onSurface.withValues(alpha: 0.55),
                                  fontStyle: FontStyle.italic,
                                ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _slides.length,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: i == _page ? 22 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: i == _page ? scheme.onSurface : scheme.outline.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 0, 22, 18),
                child: NeonPrimaryButton(
                  label: _page == _slides.length - 1 ? 'Enter PersonaSphere' : 'Next',
                  icon: _page == _slides.length - 1 ? Icons.arrow_forward_rounded : null,
                  onPressed: () async {
                    if (_page < _slides.length - 1) {
                      await _controller.nextPage(duration: const Duration(milliseconds: 420), curve: Curves.easeOutCubic);
                    } else {
                      await _finish();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Slide {
  const _Slide({required this.title, required this.body, required this.icon});
  final String title;
  final String body;
  final IconData icon;
}
