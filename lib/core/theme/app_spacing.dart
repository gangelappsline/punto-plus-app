import 'package:flutter/material.dart';

/// Escala de espaciado, radios, duraciones y sombras del sistema de diseño.
abstract final class AppSpacing {
  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;

  /// Padding horizontal estándar de las pantallas.
  static const EdgeInsets screen = EdgeInsets.symmetric(horizontal: xl);

  /// Padding completo de una pantalla con scroll.
  static const EdgeInsets scroll = EdgeInsets.fromLTRB(xl, lg, xl, xxl);

  /// Separación entre secciones.
  static const SizedBox gapSection = SizedBox(height: xxl);

  /// Separación entre tarjetas de una lista.
  static const SizedBox gapCard = SizedBox(height: md);

  /// Separación pequeña vertical.
  static const SizedBox gapSmall = SizedBox(height: sm);
}

abstract final class AppRadius {
  static const double sm = 10;
  static const double md = 14;
  static const double lg = 18;
  static const double xl = 24;
  static const double pill = 999;

  static const BorderRadius allSm = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius allMd = BorderRadius.all(Radius.circular(md));
  static const BorderRadius allLg = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius allXl = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius allPill = BorderRadius.all(Radius.circular(pill));
}

abstract final class AppDurations {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 400);
  static const Duration skeleton = Duration(milliseconds: 1200);
}

abstract final class AppShadows {
  static const List<BoxShadow> card = <BoxShadow>[
    BoxShadow(
      color: Color(0x14003F60),
      blurRadius: 16,
      offset: Offset(0, 6),
    ),
  ];

  static const List<BoxShadow> raised = <BoxShadow>[
    BoxShadow(
      color: Color(0x1F003F60),
      blurRadius: 24,
      offset: Offset(0, 10),
    ),
  ];
}

/// Medidas de componentes compartidos.
abstract final class AppSizes {
  static const double buttonHeight = 48;
  static const double fieldHeight = 48;
  static const double appBarHeight = 56;
  static const double bottomNavHeight = 64;
  static const double avatarSm = 36;
  static const double avatarMd = 56;
  static const double avatarLg = 96;
  static const double maxContentWidth = 520;
  static const double stampSize = 56;
}
