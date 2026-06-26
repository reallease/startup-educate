import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../../../core/design.dart';
import '../../../../core/models.dart';
import '../../../../services/storage_service.dart';

class FlashcardsPage extends StatefulWidget {
  const FlashcardsPage({super.key});

  @override
  State<FlashcardsPage> createState() => _FlashcardsPageState();
}

class _FlashcardsPageState extends State<FlashcardsPage> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  String? _selectedSubject;
  late final AnimationController _flipCtrl;
  Set<String> _mastered = {};

  final List<Flashcard> _allFlashcards = [
    // Matemática
    Flashcard(id: 'f1', subject: 'Matemática', front: 'Fórmula de Bhaskara', back: 'x = (-b ± √Δ) / 2a, onde Δ = b² - 4ac'),
    Flashcard(id: 'f2', subject: 'Matemática', front: 'Área do Círculo', back: 'A = π × r²'),
    Flashcard(id: 'f3', subject: 'Matemática', front: 'Teorema de Pitágoras', back: 'Em um triângulo retângulo: a² = b² + c²'),
    Flashcard(id: 'f4', subject: 'Matemática', front: 'Soma dos ângulos internos de um polígono', back: 'S = (n - 2) × 180°, onde n é o número de lados'),
    // Física
    Flashcard(id: 'f5', subject: 'Física', front: '2ª Lei de Newton', back: 'F = m × a (Força = massa × aceleração)'),
    Flashcard(id: 'f6', subject: 'Física', front: 'Velocidade média', back: 'Vm = ΔS / Δt'),
    Flashcard(id: 'f7', subject: 'Física', front: 'Energia Cinética', back: 'Ec = m × v² / 2'),
    // Química
    Flashcard(id: 'f8', subject: 'Química', front: 'Número de Avogadro', back: '6,022 × 10²³'),
    Flashcard(id: 'f9', subject: 'Química', front: 'pH neutro', back: 'pH = 7 (a 25°C)'),
    Flashcard(id: 'f10', subject: 'Química', front: 'Fórmula da água', back: 'H₂O'),
    // Português
    Flashcard(id: 'f11', subject: 'Português', front: 'O que é sujeito?', back: 'Termo da oração sobre o qual se faz uma declaração. Pode ser simples, composto, oculto ou inexistente.'),
    Flashcard(id: 'f12', subject: 'Português', front: 'O que é oração subordinada?', back: 'Oração que depende de outra (oração principal) para ter sentido completo.'),
    // Biologia
    Flashcard(id: 'f13', subject: 'Biologia', front: 'O que é mitocôndria?', back: 'Organela responsável pela respiração celular e produção de energia (ATP).'),
    Flashcard(id: 'f14', subject: 'Biologia', front: 'Fotossíntese', back: '6CO₂ + 6H₂O + luz → C₆H₁₂O₆ + 6O₂'),
    // História
    Flashcard(id: 'f15', subject: 'História', front: 'Revolução Francesa', back: '1789 - Conflito social que marcou o fim do Antigo Regime na França. Lema: Liberdade, Igualdade, Fraternidade.'),
    Flashcard(id: 'f16', subject: 'História', front: 'Proclamação da República', back: '15 de novembro de 1889, liderada pelo Marechal Deodoro da Fonseca.'),
  ];

  @override
  void initState() {
    super.initState();
    _flipCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 380));
    _mastered = StorageService.getMasteredCards().toSet();
  }

  @override
  void dispose() {
    _flipCtrl.dispose();
    super.dispose();
  }

  List<Flashcard> get _filteredCards {
    if (_selectedSubject == null) return _allFlashcards;
    return _allFlashcards.where((c) => c.subject == _selectedSubject).toList();
  }

  List<String> get _subjects => _allFlashcards.map((c) => c.subject).toSet().toList();

  void _flip() {
    if (_flipCtrl.isAnimating) return;
    if (_flipCtrl.value == 0) {
      _flipCtrl.forward();
    } else {
      _flipCtrl.reverse();
    }
  }

  void _go(int delta) {
    final cards = _filteredCards;
    final next = (_currentIndex + delta).clamp(0, cards.length - 1);
    if (next == _currentIndex) return;
    _flipCtrl.reset();
    setState(() => _currentIndex = next);
  }

  void _toggleMastered(Flashcard card) {
    final isMastered = _mastered.contains(card.id);
    setState(() {
      if (isMastered) {
        _mastered.remove(card.id);
      } else {
        _mastered.add(card.id);
      }
    });
    StorageService.setCardMastered(card.id, !isMastered);
    if (!isMastered) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Card marcado como dominado! 🎯'),
          backgroundColor: AppColor.success,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(milliseconds: 1100),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      if (_currentIndex < _filteredCards.length - 1) {
        Future.delayed(const Duration(milliseconds: 250), () {
          if (mounted) _go(1);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cards = _filteredCards;
    final safeIndex = cards.isEmpty ? 0 : _currentIndex.clamp(0, cards.length - 1);
    final card = cards.isEmpty ? null : cards[safeIndex];
    final masteredCount = _allFlashcards.where((c) => _mastered.contains(c.id)).length;

    return Scaffold(
      backgroundColor: AppColor.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Flashcards'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Progresso geral
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('$masteredCount de ${_allFlashcards.length} dominados', style: AppText.label),
                    Text('${(masteredCount / _allFlashcards.length * 100).round()}%',
                        style: AppText.label.copyWith(color: AppColor.primary, fontWeight: FontWeight.w700)),
                  ],
                ),
                AppGap.sm,
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: masteredCount / _allFlashcards.length,
                    minHeight: 7,
                    backgroundColor: AppColor.line,
                    valueColor: const AlwaysStoppedAnimation(AppColor.primary),
                  ),
                ),
              ],
            ),
          ),
          // Filtro de matérias
          SizedBox(
            height: 38,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _subjectChip(null, 'Todos'),
                ..._subjects.map((s) => _subjectChip(s, s)),
              ],
            ),
          ),
          // Card
          Expanded(
            child: card == null
                ? const Center(child: Text('Nenhum card nesta matéria.', style: AppText.label))
                : Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      child: GestureDetector(
                        onTap: _flip,
                        child: AnimatedBuilder(
                          animation: _flipCtrl,
                          builder: (context, _) {
                            final angle = _flipCtrl.value * math.pi;
                            final showBack = angle > math.pi / 2;
                            return Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.identity()
                                ..setEntry(3, 2, 0.0012)
                                ..rotateY(angle),
                              child: showBack
                                  ? Transform(
                                      alignment: Alignment.center,
                                      transform: Matrix4.identity()..rotateY(math.pi),
                                      child: _cardBack(card),
                                    )
                                  : _cardFront(card, _mastered.contains(card.id)),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
          ),
          // Posição + navegação
          if (card != null) ...[
            Text('${safeIndex + 1} / ${cards.length}', style: AppText.caption),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
              child: Row(
                children: [
                  _circleBtn(Icons.arrow_back_rounded, safeIndex > 0 ? () => _go(-1) : null),
                  AppGap.md,
                  Expanded(
                    child: SizedBox(
                      height: 54,
                      child: ElevatedButton.icon(
                        onPressed: () => _toggleMastered(card),
                        icon: Icon(_mastered.contains(card.id) ? Icons.check_circle : Icons.check_circle_outline),
                        label: Text(_mastered.contains(card.id) ? 'Dominado' : 'Dominei'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _mastered.contains(card.id) ? AppColor.success : AppColor.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                      ),
                    ),
                  ),
                  AppGap.md,
                  _circleBtn(Icons.arrow_forward_rounded, safeIndex < cards.length - 1 ? () => _go(1) : null),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Text('Toque no card para virar', style: AppText.caption),
            ),
          ],
        ],
      ),
    );
  }

  Widget _circleBtn(IconData icon, VoidCallback? onTap) {
    final enabled = onTap != null;
    return Material(
      color: enabled ? AppColor.surface : AppColor.line,
      shape: const CircleBorder(),
      elevation: enabled ? 1 : 0,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Icon(icon, color: enabled ? AppColor.primary : AppColor.inkFaint),
        ),
      ),
    );
  }

  Widget _cardFront(Flashcard card, bool mastered) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 320),
      decoration: BoxDecoration(
        color: AppColor.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppShadow.soft,
        border: Border.all(color: AppColor.line),
      ),
      padding: const EdgeInsets.all(28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColor.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(card.subject, style: const TextStyle(color: AppColor.primary, fontWeight: FontWeight.w700, fontSize: 12)),
              ),
              if (mastered) const Icon(Icons.verified_rounded, color: AppColor.success, size: 22),
            ],
          ),
          const Spacer(),
          Text(card.front, textAlign: TextAlign.center, style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w700, height: 1.3)),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.touch_app_outlined, color: AppColor.inkFaint, size: 18),
              AppGap.w(6),
              const Text('Ver resposta', style: AppText.caption),
            ],
          ),
        ],
      ),
    );
  }

  Widget _cardBack(Flashcard card) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 320),
      decoration: BoxDecoration(
        gradient: AppColor.primaryGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppShadow.tinted(AppColor.primary),
      ),
      padding: const EdgeInsets.all(28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('RESPOSTA', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1.5)),
          const Spacer(),
          Text(card.back, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w600, height: 1.4)),
          const Spacer(),
          const Text('Toque para voltar', style: TextStyle(color: Colors.white60, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _subjectChip(String? subject, String label) {
    final selected = _selectedSubject == subject;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Material(
        color: selected ? AppColor.primary : AppColor.surface,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            _flipCtrl.reset();
            setState(() {
              _selectedSubject = subject;
              _currentIndex = 0;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: selected ? AppColor.primary : AppColor.line),
            ),
            child: Text(label,
                style: TextStyle(color: selected ? Colors.white : AppColor.inkSoft, fontWeight: FontWeight.w600, fontSize: 13)),
          ),
        ),
      ),
    );
  }
}
