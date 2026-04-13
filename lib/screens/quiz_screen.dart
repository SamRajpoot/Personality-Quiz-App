import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/quiz_model.dart';
import '../providers/settings_providers.dart';
import '../services/storage_service.dart';
import '../utils/feedback_utils.dart';
import '../widgets/glass_card.dart';
import '../widgets/persona_backdrop.dart';
import '../widgets/quiz_progress_bar.dart';
import 'result_screen.dart';

class QuizScreen extends ConsumerStatefulWidget {
  const QuizScreen({super.key, required this.quiz, this.forceFresh = false});

  final QuizModel quiz;
  final bool forceFresh;

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  late int _currentIndex;
  late List<int> _answers;
  var _resumeHandled = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
    _answers = [];
    WidgetsBinding.instance.addPostFrameCallback((_) => _handleResume());
  }

  Future<void> _handleResume() async {
    if (_resumeHandled) return;
    _resumeHandled = true;
    final storage = ref.read(storageServiceProvider);
    if (widget.forceFresh) {
      await storage.clearQuizProgress(widget.quiz.id);
      return;
    }
    final snap = await storage.getQuizProgress(widget.quiz.id);
    if (!mounted || snap == null) return;
    if (snap.questionIndex == 0 && snap.answers.isEmpty) {
      await storage.clearQuizProgress(widget.quiz.id);
      return;
    }
    if (snap.questionIndex < 0 || snap.questionIndex > widget.quiz.questions.length) {
      await storage.clearQuizProgress(widget.quiz.id);
      return;
    }
    if (snap.questionIndex == widget.quiz.questions.length && snap.answers.length == widget.quiz.questions.length) {
      await storage.clearQuizProgress(widget.quiz.id);
      return;
    }
    if (snap.answers.length != snap.questionIndex) {
      await storage.clearQuizProgress(widget.quiz.id);
      return;
    }
    final go = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Resume quiz?'),
          content: Text('Continue "${widget.quiz.title}" from question ${snap.questionIndex + 1}?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Start over')),
            FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Resume')),
          ],
        );
      },
    );
    if (!mounted) return;
    if (go == true) {
      setState(() {
        _currentIndex = snap.questionIndex;
        _answers = List<int>.from(snap.answers);
      });
    } else {
      await storage.clearQuizProgress(widget.quiz.id);
      setState(() {
        _currentIndex = 0;
        _answers = [];
      });
    }
  }

  Future<void> _persist() async {
    final storage = ref.read(storageServiceProvider);
    await storage.saveQuizProgress(
      widget.quiz.id,
      QuizProgressSnapshot(questionIndex: _currentIndex, answers: List<int>.from(_answers)),
    );
  }

  Future<void> _selectOption(int optionIndex) async {
    final settings = ref.read(settingsProvider).value;
    if (settings != null) {
      await playTapFeedback(soundEnabled: settings.soundEnabled, hapticsEnabled: settings.hapticsEnabled);
    }

    final i = _currentIndex;
    final isLast = i >= widget.quiz.questions.length - 1;

    final nextAnswers = List<int>.from(_answers);
    if (nextAnswers.length == i) {
      nextAnswers.add(optionIndex);
    } else {
      nextAnswers[i] = optionIndex;
    }

    final storage = ref.read(storageServiceProvider);
    if (isLast) {
      await storage.clearQuizProgress(widget.quiz.id);
      if (!mounted) return;
      final completedAnswers = nextAnswers;
      await Navigator.of(context).push<void>(
        PageRouteBuilder<void>(
          transitionDuration: const Duration(milliseconds: 520),
          pageBuilder: (context, animation, secondaryAnimation) =>
              ResultScreen(quiz: widget.quiz, answers: completedAnswers),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              child: child,
            );
          },
        ),
      );
      return;
    }

    setState(() {
      _answers = nextAnswers;
      _currentIndex = i + 1;
    });
    await _persist();
  }

  @override
  Widget build(BuildContext context) {
    final q = widget.quiz;
    if (q.questions.isEmpty) {
      return const Scaffold(body: Center(child: Text('This quiz has no questions.')));
    }
    final safeIndex = _currentIndex.clamp(0, q.questions.length - 1);
    final question = q.questions[safeIndex];
    final scheme = Theme.of(context).colorScheme;

    return PopScope(
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop && _answers.isNotEmpty && _answers.length == _currentIndex) {
          await _persist();
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text(q.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
        body: PersonaBackdrop(
          hue: q.accentHue,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  QuizProgressBar(current: safeIndex + 1, total: q.questions.length),
                  const SizedBox(height: 14),
                  Text(
                    'Question ${safeIndex + 1} of ${q.questions.length}',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: scheme.onSurface.withValues(alpha: 0.65),
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          GlassCard(
                            padding: const EdgeInsets.all(20),
                            child: Text(
                              question.text,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    height: 1.25,
                                  ),
                            ),
                          ).animate(key: ValueKey(question.id)).fadeIn(duration: 320.ms).slideX(begin: 0.04, curve: Curves.easeOutCubic),
                          const SizedBox(height: 14),
                          ...List.generate(question.options.length, (i) {
                            final opt = question.options[i];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: GlassCard(
                                onTap: () => _selectOption(i),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 28,
                                      height: 28,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: scheme.outline.withValues(alpha: 0.35)),
                                        color: scheme.surfaceContainerHighest.withValues(alpha: 0.35),
                                      ),
                                      child: Text(
                                        String.fromCharCode(65 + i),
                                        style: const TextStyle(fontWeight: FontWeight.w800),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        opt.label,
                                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.3),
                                      ),
                                    ),
                                    Icon(Icons.chevron_right_rounded, color: scheme.onSurface.withValues(alpha: 0.35)),
                                  ],
                                ),
                              ),
                            )
                                .animate(delay: (60 * i).ms)
                                .fadeIn(duration: 320.ms)
                                .slideY(begin: 0.05, curve: Curves.easeOutCubic);
                          }),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
