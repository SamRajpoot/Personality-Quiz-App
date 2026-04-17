import 'package:flutter/material.dart';

import '../core/app_constants.dart';

/// Visual card captured for image sharing (RepaintBoundary wraps this).
class ResultShareCard extends StatelessWidget {
  const ResultShareCard({
    super.key,
    required this.quizTitle,
    required this.resultTitle,
    required this.subtitle,
  });

  final String quizTitle;
  final String resultTitle;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgTop = isDark ? const Color(0xFF0F0F10) : const Color(0xFFFFFFFF);
    final bgBottom = isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF2F2F2);
    return Container(
      width: 1080 / 3,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [bgTop, bgBottom],
        ),
        border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.12) : Colors.black.withValues(alpha: 0.08)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: isDark ? 0.28 : 0.08), blurRadius: 24, offset: const Offset(0, 14))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.asset(
                  'assets/branding/app_icon.png',
                  width: 44,
                  height: 44,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.auto_awesome, color: isDark ? Colors.white : Colors.black),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppConstants.appName,
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        letterSpacing: 0.3,
                      ),
                    ),
                    Text(
                      AppConstants.appTagline,
                      style: TextStyle(
                        color: isDark ? Colors.white.withValues(alpha: 0.72) : Colors.black.withValues(alpha: 0.62),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            quizTitle.toUpperCase(),
            style: TextStyle(
              color: isDark ? Colors.white.withValues(alpha: 0.58) : Colors.black.withValues(alpha: 0.52),
              fontSize: 10,
              letterSpacing: 1.6,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            resultTitle,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.w800,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: TextStyle(
              color: isDark ? Colors.white.withValues(alpha: 0.82) : Colors.black.withValues(alpha: 0.72),
              fontSize: 13,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.12) : Colors.black.withValues(alpha: 0.08)),
            ),
            child: Text(
              AppConstants.philosophy,
              style: TextStyle(
                color: isDark ? Colors.white.withValues(alpha: 0.72) : Colors.black.withValues(alpha: 0.66),
                fontSize: 11,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
