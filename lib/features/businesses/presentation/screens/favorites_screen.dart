import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/feedback.dart';
import '../../../../core/widgets/skeletons.dart';
import '../../data/models/business.dart';
import '../providers/businesses_providers.dart';
import '../widgets/business_tile.dart';

/// Negocios marcados como favoritos por el cliente.
final class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Set<String> favorites = ref.watch(favoritesControllerProvider).valueOrNull ??
        <String>{};
    final List<BusinessModel> businesses = ref.watch(visibleBusinessesProvider);
    final List<BusinessModel> results = businesses
        .where((BusinessModel item) => favorites.contains(item.id))
        .toList();

    return AppScaffold(
      title: context.l10n.mapFavoritesOnly,
      showBackButton: true,
      scrollable: false,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.md,
        AppSpacing.xl,
        96,
      ),
      body: ListView(
        children: <Widget>[
          if (favorites.isEmpty)
            EmptyStateView(
              icon: Icons.favorite_border_rounded,
              title: context.l10n.commonEmptyGenericTitle,
              message: context.l10n.commonEmptyGenericMessage,
            )
          else if (ref.watch(nearbyBusinessesProvider).isLoading)
            const ListSkeleton(items: 3)
          else if (results.isEmpty)
            EmptyStateView(
              compact: true,
              icon: Icons.travel_explore_rounded,
              title: context.l10n.mapEmptyTitle,
              message: context.l10n.mapEmptyMessage,
              actionLabel: context.l10n.commonRetry,
              onAction: () =>
                  ref.read(nearbyBusinessesProvider.notifier).refresh(),
            )
          else
            ...results.map((BusinessModel item) => BusinessTile(business: item)),
        ],
      ),
    );
  }
}
