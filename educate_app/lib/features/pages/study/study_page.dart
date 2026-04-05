import 'package:flutter/material.dart';
import '../flashcards/flashcards_page.dart';
import 'vestibulares/vestibulares.dart';
import 'concursos_publicos/concursos.dart';
import '../../../../services/auth_service.dart';
import '../../../../services/storage_service.dart';

class StudyPage extends StatefulWidget {
  const StudyPage({super.key});

  @override
  State<StudyPage> createState() => _StudyPageState();
}

class _StudyPageState extends State<StudyPage> {
  bool _loading = true;
  Map<String, dynamic> _profile = {};
  List<Map<String, dynamic>> _categories = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      _profile = await AuthService.getUserProfile() ?? {};
    } catch (_) {
      _profile = {
        'objective': 'ENEM',
        'total_questions': 0,
        'study_minutes': 0,
      };
    }

    final objective = _profile['objective'] ?? 'ENEM';
    if (objective == 'ENEM') {
      _categories = [
        {'title': 'ENEM & Vestibulares', 'subtitle': 'Todas as matérias', 'icon': Icons.school, 'color': 0xFF6366F1, 'route': 'vestibular'},
        {'title': 'Matemática', 'subtitle': 'Álgebra, Geometria, Estatística', 'icon': Icons.calculate, 'color': 0xFF3B82F6},
        {'title': 'Linguagens', 'subtitle': 'Português, Literatura', 'icon': Icons.menu_book, 'color': 0xFF8B5CF6},
        {'title': 'Ciências Humanas', 'subtitle': 'História, Geografia', 'icon': Icons.public, 'color': 0xFFF97316},
        {'title': 'Ciências da Natureza', 'subtitle': 'Física, Química, Biologia', 'icon': Icons.science, 'color': 0xFF14B8A6},
        {'title': 'Redação', 'subtitle': 'Técnicas e práticas', 'icon': Icons.edit_note, 'color': 0xFFEC4899},
      ];
    } else if (objective == 'Concurso Público') {
      _categories = [
        {'title': 'Concursos Públicos', 'subtitle': 'Simulados gerais', 'icon': Icons.menu_book, 'color': 0xFF22C55E, 'route': 'concursos'},
        {'title': 'Português', 'subtitle': 'Gramática, Interpretação', 'icon': Icons.menu_book, 'color': 0xFF8B5CF6},
        {'title': 'Raciocínio Lógico', 'subtitle': 'Matemática, Lógica', 'icon': Icons.psychology, 'color': 0xFFF59E0B},
        {'title': 'Informática', 'subtitle': 'Windows, Office', 'icon': Icons.computer, 'color': 0xFF3B82F6},
        {'title': 'Dir. Constitucional', 'subtitle': 'Constituição Federal', 'icon': Icons.gavel, 'color': 0xFF6366F1},
        {'title': 'Dir. Administrativo', 'subtitle': 'Licitações, Servidores', 'icon': Icons.account_balance, 'color': 0xFF14B8A6},
      ];
    } else {
      _categories = [
        {'title': 'Militares', 'subtitle': 'EsPCEx, AFA, EFOMM', 'icon': Icons.flight_takeoff, 'color': 0xFF8B5CF6, 'route': 'concursos'},
        {'title': 'Matemática', 'subtitle': 'Álgebra, Trigonometria', 'icon': Icons.calculate, 'color': 0xFF3B82F6},
        {'title': 'Física', 'subtitle': 'Mecânica, Óptica', 'icon': Icons.bolt, 'color': 0xFFF59E0B},
        {'title': 'Química', 'subtitle': 'Geral, Orgânica', 'icon': Icons.bubble_chart, 'color': 0xFFEC4899},
        {'title': 'Português', 'subtitle': 'Gramática', 'icon': Icons.menu_book, 'color': 0xFF8B5CF6},
        {'title': 'Inglês', 'subtitle': 'Gramática, Leitura', 'icon': Icons.translate, 'color': 0xFF3B82F6},
      ];
    }

    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator(color: Color(0xFF7C3AED))));
    }

    final objective = _profile['objective'] ?? 'ENEM';
    final tq = (_profile['total_questions'] ?? 0) as int;
    final tm = (_profile['study_minutes'] ?? 0) as int;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async { setState(() => _loading = true); await _loadData(); },
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Estude', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('Objetivo: $objective', style: const TextStyle(color: Color(0xFF7C3AED), fontWeight: FontWeight.w600)),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _statPill(Icons.quiz_outlined, '$tq', 'questões'),
                          const SizedBox(width: 10),
                          _statPill(Icons.timer_outlined, '$tm', 'min'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      _quickAction(Icons.flash_on, 'Flashcards', 0xFF8B5CF6, () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const FlashcardsPage()));
                      }),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Text('Categorias', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),

              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final cat = _categories[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: _categoryCard(
                        color: Color(cat['color'] as int),
                        icon: cat['icon'] as IconData,
                        title: cat['title'] as String,
                        subtitle: cat['subtitle'] as String,
                        onTap: () {
                          final route = cat['route'] as String?;
                          if (route == 'vestibular') {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const VestibularScreen()));
                          } else if (route == 'concursos') {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const ConcursosScreen()));
                          }
                        },
                      ),
                    );
                  },
                  childCount: _categories.length,
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 30)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statPill(IconData icon, String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFF7C3AED).withValues(alpha: 0.15))),
      child: Row(children: [Icon(icon, color: const Color(0xFF7C3AED), size: 16), const SizedBox(width: 6), Text('$value $label', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13))]),
    );
  }

  Widget _quickAction(IconData icon, String label, int color, VoidCallback onTap) {
    return Expanded(
      child: Material(color: Colors.white, borderRadius: BorderRadius.circular(14),
        child: InkWell(onTap: onTap, borderRadius: BorderRadius.circular(14),
          child: Container(padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, color: Color(color), size: 20), const SizedBox(width: 8), Text(label, style: const TextStyle(fontWeight: FontWeight.w600))]),
          ),
        ),
      ),
    );
  }

  Widget _categoryCard({required Color color, required IconData icon, required String title, required String subtitle, required VoidCallback onTap}) {
    return Material(color: Colors.transparent, borderRadius: BorderRadius.circular(14),
      child: InkWell(onTap: onTap, borderRadius: BorderRadius.circular(14),
        child: Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.grey.shade100)),
          child: Row(
            children: [
              Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: color, size: 22)),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)), const SizedBox(height: 2), Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12))])),
              const Icon(Icons.forward_outlined, size: 20, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
