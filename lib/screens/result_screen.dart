import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/quiz_model.dart';
import '../models/quiz_result_model.dart';
import '../providers/settings_providers.dart';
import '../services/quiz_engine.dart';
import '../services/share_service.dart';
import '../utils/feedback_utils.dart';
import '../widgets/glass_card.dart';
import '../widgets/neon_primary_button.dart';
import '../widgets/persona_backdrop.dart';
import '../widgets/result_share_card.dart';
import 'quiz_screen.dart';

class ResultScreen extends ConsumerStatefulWidget {
  const ResultScreen({super.key, required this.quiz, required this.answers});

  final QuizModel quiz;
  final List<int> answers;

  @override
  ConsumerState<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends ConsumerState<ResultScreen> {
  late final ConfettiController _confetti;
  final _shareBoundaryKey = GlobalKey();

  late final Map<String, double> _scores;
  late final QuizResultModel _result;

  @override
  void initState() {
    super.initState();
    _scores = QuizEngine.aggregateScores(widget.quiz, widget.answers);
    _result = QuizEngine.resolveResult(widget.quiz, _scores);
    _confetti = ConfettiController(duration: const Duration(seconds: 3));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _confetti.play();
    });
  }

  @override
  void dispose() {
    _confetti.dispose();
    super.dispose();
  }

  Future<void> _shareText() async {
    final settings = ref.read(settingsProvider).value;
    if (settings != null) {
      await playTapFeedback(soundEnabled: settings.soundEnabled, hapticsEnabled: settings.hapticsEnabled);
    }
    final text = _shareCaption();
    await ShareService().shareText(text);
  }

  Future<void> _shareImage() async {
    final settings = ref.read(settingsProvider).value;
    if (settings != null) {
      await playTapFeedback(soundEnabled: settings.soundEnabled, hapticsEnabled: settings.hapticsEnabled);
    }
    await ShareService().sharePngFromBoundary(
      boundaryKey: _shareBoundaryKey,
      text: _shareCaption(),
    );
  }

  String _shareCaption() {
    return 'I got "${_result.title}" on ${widget.quiz.title} in PersonaSphere — Discover Your True Self. Understand yourself, unlock your potential.';
  }

  void _retake() {
    Navigator.of(context).pushAndRemoveUntil<void>(
      MaterialPageRoute<void>(
        builder: (_) => QuizScreen(quiz: widget.quiz, forceFresh: true),
      ),
      (route) => route.isFirst,
    );
  }

  void _home() {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Your result'),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: _home,
        ),
      ),
      body: Stack(
        children: [
          PersonaBackdrop(
            hue: widget.quiz.accentHue,
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    GlassCard(
                      padding: const EdgeInsets.all(22),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _result.title,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900, height: 1.05),
                          )
                              .animate()
                              .fadeIn(duration: 420.ms)
                              .scale(begin: const Offset(0.96, 0.96), curve: Curves.easeOutBack),
                          const SizedBox(height: 8),
                          Text(
                            _result.subtitle,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: scheme.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            _result.description,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.35),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    _section(context, 'Strengths', _result.strengths, Icons.bolt_rounded),
                    const SizedBox(height: 10),
                    _section(context, 'Growth edges', _result.weaknesses, Icons.insights_rounded),
                    const SizedBox(height: 10),
                    _section(context, 'Next steps', _result.suggestions, Icons.route_rounded),
                    const SizedBox(height: 16),
                    NeonPrimaryButton(
                      label: 'Share as text',
                      icon: Icons.chat_bubble_outline_rounded,
                      onPressed: _shareText,
                    ),
                    const SizedBox(height: 10),
                    NeonPrimaryButton(
                      label: 'Share card image',
                      icon: Icons.image_outlined,
                      onPressed: _shareImage,
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      ),
                      onPressed: _retake,
                      icon: const Icon(Icons.replay_rounded),
                      label: const Text('Retake quiz'),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: _home,
                      child: const Text('Back to home'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confetti,
              blastDirectionality: BlastDirectionality.explosive,
              emissionFrequency: 0.06,
              numberOfParticles: 18,
              maxBlastForce: 28,
              minBlastForce: 8,
              gravity: 0.22,
              shouldLoop: false,
              colors: [scheme.primary, scheme.secondary, Colors.white],
            ),
          ),
          Positioned(
            left: -4000,
            top: 0,
            child: RepaintBoundary(
              key: _shareBoundaryKey,
              child: ResultShareCard(
                quizTitle: widget.quiz.title,
                resultTitle: _result.title,
                subtitle: _result.subtitle,
                accentHue: widget.quiz.accentHue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _section(BuildContext context, String title, List<String> bullets, IconData icon) {
    final scheme = Theme.of(context).colorScheme;
    return GlassCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 22, color: scheme.primary),
              const SizedBox(width: 8),
              Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
            ],
          ),
          const SizedBox(height: 10),
          ...bullets.map(
            (b) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('• ', style: TextStyle(color: scheme.secondary, fontWeight: FontWeight.w900)),
                  Expanded(child: Text(b, style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.35))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
