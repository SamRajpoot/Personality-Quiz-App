import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/app_constants.dart';
import '../models/quiz_model.dart';
import '../providers/quiz_catalog_provider.dart';
import '../providers/settings_providers.dart';
import '../utils/icon_utils.dart';
import '../widgets/glass_card.dart';
import '../widgets/persona_backdrop.dart';
import 'quiz_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _favoritesOnly = false;

  @override
  Widget build(BuildContext context) {
    final quizzesAsync = ref.watch(quizzesProvider);
    final favAsync = ref.watch(favoritesProvider);
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Column(
          children: [
            Text(AppConstants.appName, style: const TextStyle(fontWeight: FontWeight.w800)),
            Text(
              AppConstants.appTagline,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: scheme.onSurface.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Favorites filter',
            onPressed: () => setState(() => _favoritesOnly = !_favoritesOnly),
            icon: Icon(_favoritesOnly ? Icons.bookmark_rounded : Icons.bookmark_outline_rounded),
          ),
          IconButton(
            tooltip: 'Settings',
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const SettingsScreen()));
            },
            icon: const Icon(Icons.tune_rounded),
          ),
        ],
      ),
      body: PersonaBackdrop(
        hue: 268,
        child: SafeArea(
          child: quizzesAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Could not load quizzes.\n$e', textAlign: TextAlign.center)),
            data: (quizzes) {
              final favs = favAsync.value ?? <String>{};
              final list = _favoritesOnly ? quizzes.where((q) => favs.contains(q.id)).toList() : quizzes;
              if (list.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      _favoritesOnly ? 'No favorites yet. Star a quiz to save it here.' : 'No quizzes available.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                );
              }
              return LayoutBuilder(
                builder: (context, c) {
                  final cross = c.maxWidth >= 720 ? 3 : 2;
                  return CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                        sliver: SliverGrid(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: cross,
                            mainAxisSpacing: 14,
                            crossAxisSpacing: 14,
                            childAspectRatio: 0.82,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final quiz = list[index];
                              final isFav = favs.contains(quiz.id);
                              return _QuizCategoryTile(
                                quiz: quiz,
                                isFavorite: isFav,
                                onFavorite: () => ref.read(favoritesProvider.notifier).toggle(quiz.id),
                                onOpen: () {
                                  Navigator.of(context).push(
                                    PageRouteBuilder<void>(
                                      pageBuilder: (context, animation, secondaryAnimation) => QuizScreen(quiz: quiz),
                                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                        return FadeTransition(
                                          opacity: CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
                                          child: ScaleTransition(
                                            scale: Tween<double>(begin: 0.98, end: 1).animate(
                                              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
                                            ),
                                            child: child,
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                              )
                                  .animate(delay: (40 * index).ms)
                                  .fadeIn(duration: 380.ms)
                                  .slideY(begin: 0.06, curve: Curves.easeOutCubic);
                            },
                            childCount: list.length,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class _QuizCategoryTile extends StatelessWidget {
  const _QuizCategoryTile({
    required this.quiz,
    required this.isFavorite,
    required this.onFavorite,
    required this.onOpen,
  });

  final QuizModel quiz;
  final bool isFavorite;
  final VoidCallback onFavorite;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final accent = HSVColor.fromAHSV(1, quiz.accentHue, 0.55, scheme.brightness == Brightness.dark ? 0.85 : 0.45).toColor();
    return GlassCard(
      onTap: onOpen,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(colors: [accent.withValues(alpha: 0.35), scheme.secondary.withValues(alpha: 0.22)]),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
                ),
                child: Icon(iconFromName(quiz.iconName), color: scheme.onSurface),
              ),
              const Spacer(),
              IconButton.filledTonal(
                onPressed: onFavorite,
                icon: Icon(isFavorite ? Icons.star_rounded : Icons.star_outline_rounded),
                tooltip: isFavorite ? 'Remove favorite' : 'Favorite',
              ),
            ],
          ),
          const Spacer(),
          Text(
            quiz.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800, height: 1.15),
          ),
          const SizedBox(height: 6),
          Text(
            quiz.subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: scheme.onSurface.withValues(alpha: 0.68),
                  height: 1.25,
                ),
          ),
          const SizedBox(height: 10),
          Text(
            '${quiz.questions.length} questions',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: scheme.primary,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}
