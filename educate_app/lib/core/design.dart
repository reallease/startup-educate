import 'package:flutter/material.dart';

/// Sistema de design do Educate — tokens e helpers reutilizáveis.
/// Centraliza cores, espaçamento, sombras, tipografia e transições para
/// dar um visual consistente e fluido em todas as telas.

class AppColor {
  static const primary = Color(0xFF7C3AED);
  static const primaryDark = Color(0xFF6D28D9);
  static const accent = Color(0xFF8B5CF6);
  static const indigo = Color(0xFF6366F1);

  static const bg = Color(0xFFF7F7FB);
  static const surface = Color(0xFFFFFFFF);

  static const ink = Color(0xFF111827);
  static const inkSoft = Color(0xFF6B7280);
  static const inkFaint = Color(0xFF9CA3AF);

  static const line = Color(0xFFEFEFF4);

  static const success = Color(0xFF16A34A);
  static const warning = Color(0xFFF59E0B);
  static const danger = Color(0xFFEF4444);
  static const streak = Color(0xFFFF7A00);

  static const primaryGradient = LinearGradient(
    colors: [Color(0xFF7C3AED), Color(0xFF9333EA)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppGap {
  static const xs = SizedBox(height: 4, width: 4);
  static const sm = SizedBox(height: 8, width: 8);
  static const md = SizedBox(height: 12, width: 12);
  static const lg = SizedBox(height: 16, width: 16);
  static const xl = SizedBox(height: 24, width: 24);
  static const xxl = SizedBox(height: 32, width: 32);

  static SizedBox h(double v) => SizedBox(height: v);
  static SizedBox w(double v) => SizedBox(width: v);
}

class AppRadius {
  static const card = 20.0;
  static const chip = 14.0;
  static const pill = 999.0;
}

class AppShadow {
  /// Sombra suave para cards (estilo iOS / apps de banco).
  static List<BoxShadow> get soft => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 16,
          offset: const Offset(0, 6),
        ),
      ];

  /// Sombra com tom da cor primária, para elementos em destaque.
  static List<BoxShadow> tinted(Color color) => [
        BoxShadow(
          color: color.withValues(alpha: 0.28),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ];
}

class AppText {
  static const display = TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: AppColor.ink, letterSpacing: -0.5, height: 1.1);
  static const title = TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColor.ink, letterSpacing: -0.3);
  static const section = TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColor.ink);
  static const body = TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: AppColor.ink);
  static const label = TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColor.inkSoft);
  static const caption = TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: AppColor.inkFaint);
}

/// Card branco padrão com sombra suave e cantos arredondados.
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? color;
  final double radius;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
    this.color,
    this.radius = AppRadius.card,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? AppColor.surface,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: AppShadow.soft,
      ),
      child: child,
    );
    if (onTap == null) return card;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius),
        child: card,
      ),
    );
  }
}

/// Níveis de gamificação — fonte única (antes duplicado em 3 telas).
class LevelSystem {
  static const tiers = [
    (name: 'Iniciante', min: 0, icon: '🌱'),
    (name: 'Estudante', min: 100, icon: '📘'),
    (name: 'Dedicado', min: 300, icon: '🔥'),
    (name: 'Mestre', min: 600, icon: '⭐'),
    (name: 'Gênio', min: 1000, icon: '🏆'),
  ];

  static String levelOf(int xp) {
    var name = tiers.first.name;
    for (final t in tiers) {
      if (xp >= t.min) name = t.name;
    }
    return name;
  }

  static String iconOf(int xp) {
    var icon = tiers.first.icon;
    for (final t in tiers) {
      if (xp >= t.min) icon = t.icon;
    }
    return icon;
  }

  static int nextThreshold(int xp) {
    for (final t in tiers) {
      if (xp < t.min) return t.min;
    }
    return 1500;
  }

  static int currentThreshold(int xp) {
    var min = 0;
    for (final t in tiers) {
      if (xp >= t.min) min = t.min;
    }
    return min;
  }

  /// Progresso (0..1) dentro do nível atual.
  static double progressInLevel(int xp) {
    final lo = currentThreshold(xp);
    final hi = nextThreshold(xp);
    if (hi <= lo) return 1;
    return ((xp - lo) / (hi - lo)).clamp(0.0, 1.0);
  }
}

/// Transição de página suave (fade + leve slide), estilo apps modernos.
Route<T> fadeRoute<T>(Widget page) {
  return PageRouteBuilder<T>(
    transitionDuration: const Duration(milliseconds: 320),
    reverseTransitionDuration: const Duration(milliseconds: 240),
    pageBuilder: (_, __, ___) => page,
    transitionsBuilder: (_, animation, __, child) {
      final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(begin: const Offset(0, 0.03), end: Offset.zero).animate(curved),
          child: child,
        ),
      );
    },
  );
}
