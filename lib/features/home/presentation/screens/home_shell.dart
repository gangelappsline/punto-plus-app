import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/network_banner.dart';

/// Contenedor de las cinco secciones del cliente con navegación inferior.
final class HomeShell extends StatelessWidget {
  const HomeShell({required this.shell, super.key});

  final StatefulNavigationShell shell;

  static const List<_ShellDestination> _destinations = <_ShellDestination>[
    _ShellDestination(
      icon: Icons.home_outlined,
      selectedIcon: Icons.home_rounded,
    ),
    _ShellDestination(
      icon: Icons.map_outlined,
      selectedIcon: Icons.map_rounded,
    ),
    _ShellDestination(
      icon: Icons.card_giftcard_outlined,
      selectedIcon: Icons.card_giftcard_rounded,
    ),
    _ShellDestination(
      icon: Icons.local_offer_outlined,
      selectedIcon: Icons.local_offer_rounded,
    ),
    _ShellDestination(
      icon: Icons.person_outline_rounded,
      selectedIcon: Icons.person_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;
    final List<String> labels = <String>[
      context.l10n.commonTabHome,
      context.l10n.commonTabMap,
      context.l10n.commonTabRewards,
      context.l10n.commonTabPromotions,
      context.l10n.commonTabProfile,
    ];
    return Scaffold(
      backgroundColor: palette.background,
      body: Column(
        children: <Widget>[
          SafeArea(bottom: false, child: const ConnectivityBanner()),
          Expanded(child: shell),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: palette.surface,
          border: Border(top: BorderSide(color: palette.divider)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: NavigationBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            height: 62,
            selectedIndex: shell.currentIndex,
            onDestinationSelected: _onSelect,
            destinations: <Widget>[
              for (int index = 0; index < labels.length; index++)
                NavigationDestination(
                  icon: Icon(
                    _destinations[index].icon,
                    color: palette.textMuted,
                  ),
                  selectedIcon: Icon(
                    _destinations[index].selectedIcon,
                    color: palette.brand,
                  ),
                  label: labels[index],
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _onSelect(int index) {
    shell.goBranch(
      index,
      initialLocation: index == shell.currentIndex,
    );
  }
}

final class _ShellDestination {
  const _ShellDestination({required this.icon, required this.selectedIcon});

  final IconData icon;
  final IconData selectedIcon;
}

/// Acceso rápido circular usado en la portada del cliente.
final class QuickAction extends StatelessWidget {
  const QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
    this.tone,
    super.key,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? tone;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;
    final Color color = tone ?? palette.brand;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Column(
          children: <Widget>[
            Container(
              height: 46,
              width: 46,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: palette.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Acción para ir al buscador de negocios.
class SearchAction extends StatelessWidget {
  const SearchAction({super.key});

  @override
  Widget build(BuildContext context) => IconActionButton(
        icon: Icons.search_rounded,
        tooltip: context.l10n.mapSearchHint,
        onPressed: () => context.push(AppRoutes.search),
      );
}

/// Logo compacto con la marca de Punto+.
class BrandMark extends StatelessWidget {
  const BrandMark({this.size = 34, super.key});

  final double size;

  @override
  Widget build(BuildContext context) => Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          gradient: AppColors.brandGradient,
          borderRadius: BorderRadius.circular(size * 0.3),
        ),
        child: Icon(
          Icons.local_activity_rounded,
          color: Colors.white,
          size: size * 0.6,
        ),
      );
}
