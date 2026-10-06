import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/app_routes.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/image_thumb.dart';
import '../../../../core/widgets/progress.dart';
import '../../data/models/business.dart';
import '../providers/businesses_providers.dart';

/// Fila de negocio usada en listas, búsqueda y favoritos.
final class BusinessTile extends ConsumerWidget {
  const BusinessTile({required this.business, super.key});

  final BusinessModel business;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppPalette palette = context.palette;
    final bool isFavorite = ref.watch(favoritesControllerProvider).valueOrNull
            ?.contains(business.id) ??
        business.isFavorite;
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      onTap: () => context.push(AppRoutes.businessDetailPath(business.id)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          RemoteImage(
            url: business.logoUrl,
            fallbackInitials: business.name,
            width: 62,
            height: 62,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        business.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 14.5,
                        ),
                      ),
                    ),
                    if (business.rating != null) ...<Widget>[
                      const Icon(Icons.star_rounded,
                          size: 15, color: Color(0xFFFFC542)),
                      const SizedBox(width: 3),
                      Text(
                        business.rating!.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  business.category ?? business.description ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 6),
                Row(
                  children: <Widget>[
                    if (business.distanceKm != null) ...<Widget>[
                      Icon(Icons.near_me_outlined,
                          size: 13, color: palette.textFaint),
                      const SizedBox(width: 4),
                      Text(
                        AppFormatters.distance(business.distanceKm),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                    ],
                    if (business.isOpenNow != null)
                      StatusBadge(
                        label: business.isOpenNow!
                            ? context.l10n.businessOpenNow
                            : context.l10n.businessClosedNow,
                        color: business.isOpenNow!
                            ? palette.success
                            : palette.textMuted,
                      ),
                  ],
                ),
              ],
            ),
          ),
          IconActionButton(
            icon: isFavorite
                ? Icons.favorite_rounded
                : Icons.favorite_border_rounded,
            color: isFavorite ? palette.error : palette.textMuted,
            tooltip: isFavorite
                ? context.l10n.businessFavoriteRemove
                : context.l10n.businessFavoriteAdd,
            onPressed: () => ref
                .read(favoritesControllerProvider.notifier)
                .toggle(business.id),
          ),
        ],
      ),
    );
  }
}

/// Tarjeta compacta para carruseles horizontales.
final class CompactBusinessCard extends ConsumerWidget {
  const CompactBusinessCard({required this.business, super.key});

  final BusinessModel business;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppPalette palette = context.palette;
    return AppCard(
      padding: EdgeInsets.zero,
      onTap: () => context.push(AppRoutes.businessDetailPath(business.id)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          RemoteImage(
            url: business.coverUrl ?? business.logoUrl,
            fallbackInitials: business.name,
            height: 78,
            radius: 0,
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  business.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: <Widget>[
                    Icon(Icons.near_me_outlined,
                        size: 12, color: palette.textFaint),
                    const SizedBox(width: 4),
                    Text(
                      AppFormatters.distance(business.distanceKm),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const Spacer(),
                    if (business.isOpenNow ?? false)
                      Container(
                        height: 8,
                        width: 8,
                        decoration: BoxDecoration(
                          color: palette.success,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Encabezado del detalle del negocio con portada y acciones.
final class BusinessHero extends ConsumerWidget {
  const BusinessHero({required this.business, super.key});

  final BusinessModel business;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppPalette palette = context.palette;
    final Set<String> favorites =
        ref.watch(favoritesControllerProvider).valueOrNull ?? <String>{};
    final bool isFavorite = favorites.contains(business.id) ||
        business.isFavorite;
    return Stack(
      children: <Widget>[
        RemoteImage(
          url: business.coverUrl ?? business.logoUrl,
          fallbackInitials: business.name,
          height: 210,
          radius: 0,
        ),
        Positioned(
          left: AppSpacing.md,
          top: AppSpacing.md,
          child: IconActionButton(
            icon: Icons.arrow_back_rounded,
            background: Colors.white.withValues(alpha: 0.85),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
        ),
        Positioned(
          right: AppSpacing.md,
          top: AppSpacing.md,
          child: IconActionButton(
            icon: isFavorite
                ? Icons.favorite_rounded
                : Icons.favorite_border_rounded,
            color: isFavorite ? palette.error : palette.text,
            background: Colors.white.withValues(alpha: 0.85),
            onPressed: () =>
                ref.read(favoritesControllerProvider.notifier).toggle(business.id),
          ),
        ),
        Positioned(
          left: AppSpacing.lg,
          right: AppSpacing.lg,
          bottom: AppSpacing.lg,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                business.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  shadows: <Shadow>[
                    Shadow(blurRadius: 12, color: Colors.black54),
                  ],
                ),
              ),
              if (business.category != null)
                StatusBadge(
                  label: business.category!,
                  color: palette.brand,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
