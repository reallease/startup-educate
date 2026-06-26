import 'package:flutter/material.dart';

import '../../../../core/design.dart';
import '../../../../core/gamification.dart';
import '../../../../core/models.dart';
import '../../../../services/storage_service.dart';

class AchievementsPage extends StatelessWidget {
  const AchievementsPage({super.key});

  IconData _icon(String name) {
    switch (name) {
      case 'check_circle':
        return Icons.check_circle_rounded;
      case 'local_fire_department':
        return Icons.local_fire_department_rounded;
      case 'star':
        return Icons.star_rounded;
      case 'emoji_events':
        return Icons.emoji_events_rounded;
      case 'workspace_premium':
        return Icons.workspace_premium_rounded;
      case 'task_alt':
        return Icons.task_alt_rounded;
      default:
        return Icons.military_tech_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final results = StorageService.getQuizResults();
    final totalCorrect = results.fold<int>(0, (p, r) => p + r.correctAnswers);
    final totalQuestions = results.fold<int>(0, (p, r) => p + r.totalQuestions);
    final bestAccuracy = results.isEmpty ? 0.0 : results.map((r) => r.accuracy).reduce((a, b) => a > b ? a : b);
    final streak = StorageService.getStreak();

    final achievements = Gamification.getAchievements(
      totalCorrect: totalCorrect,
      totalQuestions: totalQuestions,
      streak: streak,
      bestAccuracy: bestAccuracy,
    );
    final unlocked = achievements.where((a) => a.unlocked).length;

    return Scaffold(
      backgroundColor: AppColor.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Conquistas'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppColor.primaryGradient,
              borderRadius: BorderRadius.circular(AppRadius.card),
              boxShadow: AppShadow.tinted(AppColor.primary),
            ),
            child: Row(
              children: [
                const Icon(Icons.emoji_events_rounded, color: Colors.white, size: 40),
                AppGap.lg,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('$unlocked de ${achievements.length} conquistas',
                          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                      AppGap.xs,
                      Text(unlocked == achievements.length ? 'Você desbloqueou tudo! 🏆' : 'Continue estudando para desbloquear mais',
                          style: const TextStyle(color: Colors.white70, fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          AppGap.xl,
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.95,
            ),
            itemCount: achievements.length,
            itemBuilder: (_, i) => _tile(achievements[i]),
          ),
        ],
      ),
    );
  }

  Widget _tile(Achievement a) {
    final color = a.unlocked ? AppColor.primary : AppColor.inkFaint;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: a.unlocked ? AppShadow.soft : null,
        border: Border.all(color: a.unlocked ? AppColor.primary.withValues(alpha: 0.25) : AppColor.line),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: color.withValues(alpha: a.unlocked ? 0.12 : 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(a.unlocked ? _icon(a.icon) : Icons.lock_rounded, color: color, size: 28),
          ),
          AppGap.md,
          Text(a.title, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: a.unlocked ? AppColor.ink : AppColor.inkSoft)),
          AppGap.xs,
          Text(a.description, textAlign: TextAlign.center, style: AppText.caption, maxLines: 2, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}
