import 'dart:async';
import 'package:flutter/material.dart';
import '../../../services/storage_service.dart';

class PomodoroPage extends StatefulWidget {
  const PomodoroPage({super.key});

  @override
  State<PomodoroPage> createState() => _PomodoroPageState();
}

class _PomodoroPageState extends State<PomodoroPage> {
  bool _isRunning = false;
  bool _isBreak = false;
  int _secondsRemaining = 25 * 60;
  int _pomodorosCompleted = 0;
  Timer? _timer;

  final int _workMinutes = 25;
  final int _breakMinutes = 5;
  final int _longBreak = 15;

  String get _timeFormatted {
    final min = _secondsRemaining ~/ 60;
    final sec = _secondsRemaining % 60;
    return '${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }

  void _start() {
    setState(() => _isRunning = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _timer?.cancel();
          if (!_isBreak) {
            _pomodorosCompleted++;
            _isBreak = true;
            _secondsRemaining =
                _pomodorosCompleted % 4 == 0 ? _longBreak * 60 : _breakMinutes * 60;
            _start(); // auto start break
          } else {
            _isBreak = false;
            _secondsRemaining = _workMinutes * 60;
            _isRunning = false;
          }
        }
      });
    });
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

  void _skipBreak() {
    if (_isBreaking) {
      _timer?.cancel();
      _isBreak = false;
      _secondsRemaining = _workMinutes * 60;
      setState(() => _isRunning = false);
    }
  }

  bool get _isBreaking => _isBreak;

  @override
  void dispose() {
    _timer?.cancel();
    if (_pomodorosCompleted > 0) {
      final minutes = _pomodorosCompleted * _workMinutes;
      StorageService.addStudyMinutes(minutes);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isBreak ? const Color(0xFFECFDF5) : const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Phase indicator
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: _isBreak ? const Color(0xFF7C3AED) : const Color(0xFF6366F1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _isBreak ? '☕ Intervalo' : '📖 Estudo',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Timer circle
                  SizedBox(
                    width: 220, height: 220,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 220,
                          height: 220,
                          child: CircularProgressIndicator(
                            value: _secondsRemaining /
                                (_isBreak ? _breakMinutes * 60 : _workMinutes * 60),
                            strokeWidth: 8,
                            backgroundColor: Colors.grey.shade200,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              _isBreak ? Colors.green : const Color(0xFF6366F1),
                            ),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _timeFormatted,
                              style: const TextStyle(
                                fontSize: 56,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'monospace',
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _isBreak ? 'Pausa' : 'Foco no estudo',
                              style: const TextStyle(color: Colors.grey, fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: _reset,
                        icon: const Icon(Icons.replay, size: 32, color: Colors.grey),
                      ),
                      const SizedBox(width: 30),
                      ElevatedButton(
                        onPressed: _isRunning ? _pause : _start,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isBreak ? const Color(0xFF7C3AED) : const Color(0xFF6366F1),
                          minimumSize: const Size(100, 60),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(_isRunning ? Icons.pause : Icons.play_arrow,
                                color: Colors.white, size: 30),
                          ],
                        ),
                      ),
                      const SizedBox(width: 30),
                      IconButton(
                        onPressed: _isBreak ? _skipBreak : null,
                        icon: const Icon(Icons.skip_next, size: 32, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
            // Stats at bottom
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _statPomo(_pomodorosCompleted, 'Pomodoros'),
                  _statPomo(_pomodorosCompleted * _workMinutes ~/ 60, 'Horas de estudo'),
                  _statPomo(_pomodorosCompleted * _workMinutes, 'Min. estudados'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statPomo(int value, String label) {
    return Column(
      children: [
        Text(
          '$value',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF6366F1)),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }
}
