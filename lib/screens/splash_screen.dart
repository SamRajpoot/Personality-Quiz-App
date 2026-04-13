import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/app_constants.dart';
import '../providers/settings_providers.dart';
import 'home_screen.dart';
import 'onboarding_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _goNext();
  }

  Future<void> _goNext() async {
    await Future<void>.delayed(const Duration(milliseconds: 1800));
    if (!mounted) return;
    final storage = ref.read(storageServiceProvider);
    final onboardingDone = await storage.isOnboardingComplete();
    if (!mounted) return;
    final next = onboardingDone ? const HomeScreen() : const OnboardingScreen();
    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 650),
        pageBuilder: (context, animation, secondaryAnimation) => next,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: CurvedAnimation(parent: animation, curve: Curves.easeOutCubic), child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).scaffoldBackgroundColor,
              scheme.primary.withValues(alpha: 0.35),
              scheme.secondary.withValues(alpha: 0.28),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(36),
                child: Image.asset(
                  'assets/branding/app_icon.png',
                  width: 112,
                  height: 112,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.auto_awesome, size: 96, color: scheme.primary),
                ),
              )
                  .animate()
                  .scale(
                    begin: const Offset(0.75, 0.75),
                    end: const Offset(1, 1),
                    duration: 900.ms,
                    curve: Curves.easeOutBack,
                  )
                  .shimmer(duration: 1200.ms, color: Colors.white.withValues(alpha: 0.25)),
              const SizedBox(height: 28),
              Text(
                AppConstants.appName,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.4,
                    ),
              ).animate().fadeIn(duration: 500.ms, delay: 120.ms),
              const SizedBox(height: 10),
              Text(
                AppConstants.appTagline,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.72),
                      fontWeight: FontWeight.w500,
                    ),
              ).animate().fadeIn(duration: 500.ms, delay: 220.ms),
              const SizedBox(height: 36),
              const SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(strokeWidth: 3),
              ).animate().fadeIn(duration: 400.ms, delay: 400.ms),
            ],
          ),
        ),
      ),
    );
  }
}
