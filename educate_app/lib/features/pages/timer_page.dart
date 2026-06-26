import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../../core/design.dart';
import '../../../services/storage_service.dart';

class PomodoroPage extends StatefulWidget {
  const PomodoroPage({super.key});

  @override
  State<PomodoroPage> createState() => _PomodoroPageState();
}

class _PomodoroPageState extends State<PomodoroPage> {
  static const _workMinutes = 25;
  static const _breakMinutes = 5;
  static const _longBreak = 15;

  bool _isRunning = false;
  bool _isBreak = false;
  int _secondsRemaining = _workMinutes * 60;
  int _pomodorosCompleted = 0;
  Timer? _timer;

  int get _phaseTotal => (_isBreak
          ? (_pomodorosCompleted % 4 == 0 && _pomodorosCompleted > 0 ? _longBreak : _breakMinutes)
          : _workMinutes) *
      60;

  String get _timeFormatted {
    final m = _secondsRemaining ~/ 60;
    final s = _secondsRemaining % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  void _start() {
    setState(() => _isRunning = true);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        _onPhaseComplete();
      }
    });
  }

  void _onPhaseComplete() {
    _timer?.cancel();
    if (!_isBreak) {
      _pomodorosCompleted++;
      StorageService.addStudyMinutes(_workMinutes);
      setState(() {
        _isBreak = true;
        _secondsRemaining = (_pomodorosCompleted % 4 == 0 ? _longBreak : _breakMinutes) * 60;
      });
      _start();
    } else {
      setState(() {
        _isBreak = false;
        _secondsRemaining = _workMinutes * 60;
        _isRunning = false;
      });
    }
  }

  void _pause() {
    _timer?.cancel();
    setState(() => _isRunning = false);
  }

  void _reset() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _isBreak = false;
      _secondsRemaining = _workMinutes * 60;
    });
  }

  void _skip() {
    _timer?.cancel();
    setState(() {
      _isBreak = false;
      _secondsRemaining = _workMinutes * 60;
      _isRunning = false;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accent = _isBreak ? AppColor.success : AppColor.primary;
    final progress = _phaseTotal > 0 ? _secondsRemaining / _phaseTotal : 0.0;

    return Scaffold(
      backgroundColor: AppColor.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Cronômetro Pomodoro'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 1),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              child: Text(
                _isBreak ? '☕ Hora do intervalo' : '📖 Foco no estudo',
                style: TextStyle(color: accent, fontWeight: FontWeight.w700),
              ),
            ),
            const Spacer(flex: 1),
            SizedBox(
              width: 260,
              height: 260,
              child: CustomPaint(
                painter: _TimerRingPainter(progress: progress, color: accent),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_timeFormatted, style: const TextStyle(fontSize: 58, fontWeight: FontWeight.w800, color: AppColor.ink, letterSpacing: -1)),
                      Text(_isBreak ? 'Relaxe um pouco' : 'Mantenha o foco', style: AppText.label),
                    ],
                  ),
                ),
              ),
            ),
            const Spacer(flex: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _secondaryBtn(Icons.refresh_rounded, 'Reiniciar', _reset),
                AppGap.w(24),
                GestureDetector(
                  onTap: _isRunning ? _pause : _start,
                  child: Container(
                    width: 84,
                    height: 84,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: _isBreak ? [AppColor.success, const Color(0xFF22C55E)] : [AppColor.primary, AppColor.accent],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: AppShadow.tinted(accent),
                    ),
                    child: Icon(_isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded, color: Colors.white, size: 44),
                  ),
                ),
                AppGap.w(24),
                _secondaryBtn(Icons.skip_next_rounded, 'Pular', _isBreak ? _skip : null),
              ],
            ),
            const Spacer(flex: 2),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: AppColor.surface,
                borderRadius: BorderRadius.circular(AppRadius.card),
                boxShadow: AppShadow.soft,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _stat('$_pomodorosCompleted', 'Pomodoros'),
                  _divider(),
                  _stat('${_pomodorosCompleted * _workMinutes}', 'Minutos'),
                  _divider(),
                  _stat('${(_pomodorosCompleted / 4 * 100).round().clamp(0, 100)}%', 'Ciclo'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider() => Container(width: 1, height: 34, color: AppColor.line);

  Widget _stat(String value, String label) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColor.primary)),
        AppGap.xs,
        Text(label, style: AppText.caption),
      ],
    );
  }

  Widget _secondaryBtn(IconData icon, String label, VoidCallback? onTap) {
    final enabled = onTap != null;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: AppColor.surface,
          shape: const CircleBorder(),
          elevation: enabled ? 1 : 0,
          child: InkWell(
            onTap: onTap,
            customBorder: const CircleBorder(),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Icon(icon, color: enabled ? AppColor.inkSoft : AppColor.inkFaint, size: 26),
            ),
          ),
        ),
        AppGap.xs,
        Text(label, style: AppText.caption),
      ],
    );
  }
}

class _TimerRingPainter extends CustomPainter {
  final double progress;
  final Color color;
  _TimerRingPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 12;
    final bg = Paint()
      ..color = AppColor.line
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;
    final fg = Paint()
      ..shader = SweepGradient(
        colors: [color, color.withValues(alpha: 0.6)],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
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
  bool shouldRepaint(_TimerRingPainter old) => old.progress != progress || old.color != color;
}
