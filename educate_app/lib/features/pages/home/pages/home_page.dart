import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../../../core/design.dart';
import '../../../../core/gamification.dart';
import '../../../../services/auth_service.dart';
import '../../../../services/storage_service.dart';
import '../../../auth/view/pages/login_page.dart';
import '../../../pages/schedule/schedule_page.dart';
import '../../../pages/timer_page.dart';
import '../../quiz/quiz_page.dart';
import '../../flashcards/flashcards_page.dart';
import '../../profile/achievements_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _userName = '';
  int _streak = 0;
  int _totalQuestions = 0;
  double _accuracy = 0;
  int _xp = 0;

  int _todayQuestions = 0;
  int _todayMinutes = 0;
  int _goalQuestions = 20;
  int _goalMinutes = 60;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final name = StorageService.getUserName() ?? 'Estudante';
    final streak = StorageService.getStreak();
    final totalQ = StorageService.totalQuestions;
    final results = StorageService.getQuizResults();

    double accuracy = 0;
    final totalCorrect = results.fold<int>(0, (p, r) => p + r.correctAnswers);
    final totalAttempted = results.fold<int>(0, (p, r) => p + r.totalQuestions);
    if (totalAttempted > 0) accuracy = totalCorrect / totalAttempted * 100;

    final xp = Gamification.calculateXP(correctAnswers: totalCorrect, streakDays: streak);

    if (mounted) {
      setState(() {
        _userName = name;
        _streak = streak;
        _totalQuestions = totalQ;
        _accuracy = accuracy;
        _xp = xp;
        _todayQuestions = StorageService.getTodayQuestions();
        _todayMinutes = StorageService.getTodayMinutes();
        _goalQuestions = StorageService.getGoalQuestions();
        _goalMinutes = StorageService.getGoalMinutes();
      });
    }
  }

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Bom dia';
    if (h < 18) return 'Boa tarde';
    return 'Boa noite';
  }

  Future<void> _logout() async {
    await AuthService.signOut();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  void _open(Widget page) {
    Navigator.push(context, fadeRoute(page)).then((_) => _loadData());
  }

  @override
  Widget build(BuildContext context) {
    final firstName = _userName.split(' ').first;
    return Scaffold(
      backgroundColor: AppColor.bg,
      body: RefreshIndicator(
        color: AppColor.primary,
        onRefresh: _loadData,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          children: [
            SafeArea(bottom: false, child: _header(firstName)),
            AppGap.xl,
            _dailyGoalsCard(),
            AppGap.lg,
            _streakAndAccuracy(),
            AppGap.xl,
            const Text('Atalhos', style: AppText.section),
            AppGap.md,
            _quickActions(),
            AppGap.xl,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Atividade recente', style: AppText.section),
                TextButton(
                  onPressed: () => _open(const AchievementsPage()),
                  child: const Text('Conquistas', style: TextStyle(color: AppColor.primary, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            AppGap.sm,
            _recentActivity(),
          ],
        ),
      ),
    );
  }

  Widget _header(String firstName) {
    return Row(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            gradient: AppColor.primaryGradient,
            shape: BoxShape.circle,
            boxShadow: AppShadow.tinted(AppColor.primary),
          ),
          alignment: Alignment.center,
          child: Text(
            firstName.isNotEmpty ? firstName[0].toUpperCase() : 'E',
            style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700),
          ),
        ),
        AppGap.md,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${_greeting()},', style: AppText.label),
              Text(firstName, style: AppText.title, overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: AppColor.surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: AppShadow.soft,
          ),
          child: Row(
            children: [
              Text(LevelSystem.iconOf(_xp), style: const TextStyle(fontSize: 14)),
              AppGap.w(6),
              Text('$_xp XP', style: const TextStyle(fontWeight: FontWeight.w700, color: AppColor.primary, fontSize: 13)),
            ],
          ),
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: AppColor.inkSoft),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          onSelected: (v) {
            if (v == 'logout') _logout();
          },
          itemBuilder: (_) => const [
            PopupMenuItem(value: 'logout', child: Row(children: [Icon(Icons.logout, color: AppColor.danger, size: 20), SizedBox(width: 10), Text('Sair')])),
          ],
        ),
      ],
    );
  }

  Widget _dailyGoalsCard() {
    final qProgress = _goalQuestions > 0 ? (_todayQuestions / _goalQuestions).clamp(0.0, 1.0) : 0.0;
    final mProgress = _goalMinutes > 0 ? (_todayMinutes / _goalMinutes).clamp(0.0, 1.0) : 0.0;
    final overall = ((qProgress + mProgress) / 2);
    final done = qProgress >= 1 && mProgress >= 1;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColor.primaryGradient,
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: AppShadow.tinted(AppColor.primary),
      ),
      child: Row(
        children: [
          _GoalRing(progress: overall),
          AppGap.w(20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  done ? 'Meta de hoje batida! 🎉' : 'Meta de hoje',
                  style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700),
                ),
                AppGap.sm,
                _goalLine(Icons.quiz_rounded, '$_todayQuestions de $_goalQuestions questões', qProgress),
                AppGap.sm,
                _goalLine(Icons.schedule_rounded, '$_todayMinutes de $_goalMinutes min de estudo', mProgress),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _goalLine(IconData icon, String label, double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.white, size: 15),
            AppGap.w(6),
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.w500)),
          ],
        ),
        AppGap.xs,
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 5,
            backgroundColor: Colors.white24,
            valueColor: const AlwaysStoppedAnimation(Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _streakAndAccuracy() {
    return Row(
      children: [
        Expanded(
          child: AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  const Icon(Icons.local_fire_department_rounded, color: AppColor.streak, size: 22),
                  AppGap.w(6),
                  Text('$_streak', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
                ]),
                AppGap.xs,
                const Text('dias de sequência', style: AppText.label),
              ],
            ),
          ),
        ),
        AppGap.md,
        Expanded(
          child: AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  const Icon(Icons.track_changes_rounded, color: AppColor.primary, size: 22),
                  AppGap.w(6),
                  Text('${_accuracy.toStringAsFixed(0)}%', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
                ]),
                AppGap.xs,
                Text('acerto • $_totalQuestions questões', style: AppText.label, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _quickActions() {
    final items = [
      (icon: Icons.bolt_rounded, label: 'Simulado', color: AppColor.primary, onTap: () => _open(const QuizPage(title: 'Simulado Rápido', questionCount: 10))),
      (icon: Icons.timer_rounded, label: 'Cronômetro', color: AppColor.indigo, onTap: () => _open(const PomodoroPage())),
      (icon: Icons.style_rounded, label: 'Flashcards', color: AppColor.accent, onTap: () => _open(const FlashcardsPage())),
      (icon: Icons.calendar_month_rounded, label: 'Agenda', color: AppColor.streak, onTap: () => _open(const SchedulePage())),
    ];
    return Row(
      children: items.map((it) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: AppCard(
              padding: const EdgeInsets.symmetric(vertical: 16),
              onTap: it.onTap,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: it.color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(14)),
                    child: Icon(it.icon, color: it.color, size: 24),
                  ),
                  AppGap.sm,
                  Text(it.label, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _recentActivity() {
    final results = StorageService.getQuizResults().reversed.take(3).toList();
    if (results.isEmpty) {
      return AppCard(
        padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: AppColor.primary.withValues(alpha: 0.08), shape: BoxShape.circle),
              child: const Icon(Icons.rocket_launch_rounded, color: AppColor.primary, size: 28),
            ),
            AppGap.md,
            const Text('Comece seu primeiro simulado', style: AppText.body),
            AppGap.xs,
            const Text('Seu progresso aparece aqui', style: AppText.caption),
          ],
        ),
      );
    }
    return Column(
      children: results.map((r) {
        final pct = (r.accuracy * 100).round();
        final good = r.accuracy >= 0.7;
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: AppCard(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: (good ? AppColor.success : AppColor.warning).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(good ? Icons.check_circle_rounded : Icons.replay_rounded, color: good ? AppColor.success : AppColor.warning),
                ),
                AppGap.md,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(r.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                      Text('${r.correctAnswers}/${r.totalQuestions} acertos', style: AppText.caption),
                    ],
                  ),
                ),
                Text('$pct%', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: good ? AppColor.success : AppColor.warning)),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// Anel de progresso da meta diária (CustomPaint).
class _GoalRing extends StatelessWidget {
  final double progress;
  const _GoalRing({required this.progress});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 76,
      height: 76,
      child: CustomPaint(
        painter: _RingPainter(progress),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${(progress * 100).round()}%', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18)),
              const Text('hoje', style: TextStyle(color: Colors.white70, fontSize: 10)),
            ],
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  _RingPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 5;
    final bg = Paint()
      ..color = Colors.white24
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round;
    final fg = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, bg);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress.clamp(0.0, 1.0),
      false,
      fg,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.progress != progress;
}
