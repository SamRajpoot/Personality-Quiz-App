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
  bool _isSharingImage = false;

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
    try {
      final settings = ref.read(settingsProvider).value;
      if (settings != null) {
        await playTapFeedback(soundEnabled: settings.soundEnabled, hapticsEnabled: settings.hapticsEnabled);
      }
      final text = _shareCaption();
      await ShareService().shareText(text);
    } catch (e) {
      _showSnack('Could not share text right now.');
    }
  }

  Future<void> _shareImage() async {
    if (_isSharingImage) return;
    setState(() => _isSharingImage = true);
    try {
      final settings = ref.read(settingsProvider).value;
      if (settings != null) {
        await playTapFeedback(soundEnabled: settings.soundEnabled, hapticsEnabled: settings.hapticsEnabled);
      }
      await ShareService().sharePngFromBoundary(
        boundaryKey: _shareBoundaryKey,
        text: _shareCaption(),
      );
    } catch (e) {
      _showSnack('Could not share image. Please try again.');
    } finally {
      if (mounted) {
        setState(() => _isSharingImage = false);
      }
    }
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

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final answered = widget.answers.length;
    final totalQuestions = widget.quiz.questions.length;
    final topEntry = _scores.entries.isEmpty
        ? null
        : _scores.entries.reduce((a, b) => a.value >= b.value ? a : b);
    final totalPoints = _scores.values.fold<double>(0, (sum, v) => sum + v);
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
                                  color: scheme.onSurface,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            _result.description,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.35),
                          ),
                          const SizedBox(height: 16),
                          _statsRow(
                            context,
                            answered: answered,
                            totalQuestions: totalQuestions,
                            topTrait: topEntry?.key ?? 'N/A',
                            topScore: topEntry?.value ?? 0,
                            totalPoints: totalPoints,
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
                      onPressed: _isSharingImage ? null : _shareImage,
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
              colors: [Colors.white, Colors.black, scheme.surfaceContainerHighest],
            ),
          ),
          Positioned(
            right: 8,
            bottom: 8,
            child: IgnorePointer(
              child: ExcludeSemantics(
                child: Transform.scale(
                  scale: 0.01,
                  alignment: Alignment.bottomRight,
                  child: RepaintBoundary(
                    key: _shareBoundaryKey,
                    child: ResultShareCard(
                      quizTitle: widget.quiz.title,
                      resultTitle: _result.title,
                      subtitle: _result.subtitle,
                    ),
                  ),
                ),
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
              Container(
                width: 34,
                height: 34,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: scheme.secondaryContainer,
                ),
                child: Icon(icon, size: 18, color: scheme.onSecondaryContainer),
              ),
              const SizedBox(width: 8),
              Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
            ],
          ),
          const SizedBox(height: 10),
          Divider(color: scheme.outline.withValues(alpha: 0.35), height: 1),
          const SizedBox(height: 10),
          ...bullets.map(
            (b) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('• ', style: TextStyle(color: scheme.onSurface.withValues(alpha: 0.75), fontWeight: FontWeight.w900)),
                  Expanded(child: Text(b, style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.35))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statsRow(
    BuildContext context, {
    required int answered,
    required int totalQuestions,
    required String topTrait,
    required double topScore,
    required double totalPoints,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _statChip(context, label: 'Answered', value: '$answered/$totalQuestions'),
        _statChip(context, label: 'Top trait', value: _prettyLabel(topTrait)),
        _statChip(context, label: 'Score', value: '${topScore.toStringAsFixed(0)} / ${totalPoints.toStringAsFixed(0)}'),
      ],
    );
  }

  Widget _statChip(BuildContext context, {required String label, required String value}) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: scheme.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: scheme.outline.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: scheme.onSecondaryContainer.withValues(alpha: 0.75),
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: scheme.onSecondaryContainer,
                  fontWeight: FontWeight.w800,
                ),
          ),
        ],
      ),
    );
  }

  String _prettyLabel(String raw) {
    if (raw.isEmpty) return 'N/A';
    return raw
        .replaceAll('_', ' ')
        .split(' ')
        .where((p) => p.isNotEmpty)
        .map((p) => p[0].toUpperCase() + p.substring(1).toLowerCase())
        .join(' ');
  }
}
