import 'package:flutter/material.dart';

import '../../../../core/models.dart';

class FlashcardsPage extends StatefulWidget {
  const FlashcardsPage({super.key});

  @override
  State<FlashcardsPage> createState() => _FlashcardsPageState();
}

class _FlashcardsPageState extends State<FlashcardsPage> {
  int _currentIndex = 0;
  bool _isFlipped = false;
  String? _selectedSubject;

  List<Flashcard> _masterCards = [];
  List<Flashcard>? _unmastered;

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

  List<Flashcard> get _filteredCards {
    if (_selectedSubject == null) return _allFlashcards;
    return _allFlashcards.where((c) => c.subject == _selectedSubject).toList();
  }

  List<String> get _subjects => _allFlashcards.map((c) => c.subject).toSet().toList();

  void _flip() => setState(() => _isFlipped = !_isFlipped);

  void _initCards() {
    _unmastered = List.from(_allFlashcards);
  }

  void _nextCard() {
    if (_currentIndex < _filteredCards.length - 1) {
      setState(() {
        _currentIndex++;
        _isFlipped = false;
      });
    }
  }

  void _prevCard() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _isFlipped = false;
      });
    }
  }

  void _markMastered() {
    if (_currentIndex < _filteredCards.length) {
      setState(() {
        _masterCards.add(_filteredCards[_currentIndex]);
        _filteredCards.removeAt(_currentIndex);
        if (_currentIndex >= _filteredCards.length && _currentIndex > 0) {
          _currentIndex--;
        }
        _isFlipped = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _initCards();
  }

  @override
  Widget build(BuildContext context) {
    final cards = _filteredCards;
    final card = cards.isNotEmpty ? cards[_currentIndex.clamp(0, cards.length - 1)] : null;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Flashcards'),
        centerTitle: true,
        actions: [
          if (_masterCards.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Icon(Icons.check_circle, color: Colors.green),
            ),
        ],
      ),
      body: Column(
        children: [
          // Subject filter
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _subjectChip(null, 'Todos'),
                ..._subjects.map((s) => _subjectChip(s, s)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_masterCards.length}/$_allFlashcards dominados',
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
                if (card != null)
                  Text(
                    '${_currentIndex + 1}/${cards.length}',
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // Flashcard
          Expanded(
            child: cards.isEmpty
                ? const Center(
                    child: Text(
                      'Parabéns! Você dominou todos os flashcards!',
                      style: TextStyle(fontSize: 18, color: Colors.green),
                    ),
                  )
                : GestureDetector(
                    onTap: _flip,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: _isFlipped ? _buildCardBack(card!) : _buildCardFront(card!),
                      ),
                    ),
                  ),
          ),
          if (cards.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _prevCard,
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Anterior'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _markMastered,
                      icon: const Icon(Icons.check),
                      label: const Text('Dominei'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7C3AED),
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _nextCard,
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text('Próximo'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6366F1),
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                'Toque no card para ver a resposta',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCardFront(Flashcard card) {
    return Container(
      key: const ValueKey('front'),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 4)),
        ],
        border: Border.all(color: const Color(0xFF7C3AED).withOpacity(0.3), width: 2),
      ),
      padding: const EdgeInsets.all(30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF7C3AED).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  card.subject,
                  style: const TextStyle(color: Color(0xFF7C3AED), fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Icon(Icons.touch_app, color: Colors.grey, size: 32),
          const SizedBox(height: 12),
          Text(
            card.front,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildCardBack(Flashcard card) {
    return Container(
      key: const ValueKey('back'),
      decoration: BoxDecoration(
        color: const Color(0xFF7C3AED),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      padding: const EdgeInsets.all(30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Resposta',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 16),
          Text(
            card.back,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _subjectChip(String? subject, String label) {
    final selected = _selectedSubject == subject;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedSubject = subject;
            _currentIndex = 0;
            _isFlipped = false;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF7C3AED) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: selected ? const Color(0xFF7C3AED) : Colors.grey.shade300),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : Colors.grey,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}
