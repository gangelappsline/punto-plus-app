import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_dialogs.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/feedback.dart';
import '../../../../core/widgets/skeletons.dart';
import '../../../businesses/presentation/providers/businesses_providers.dart';
import '../../data/models/promotion.dart';
import '../providers/promotions_providers.dart';
import '../widgets/promotion_tile.dart';

/// Listado de promociones activas con filtros por categoría y búsqueda.
final class PromotionsScreen extends ConsumerStatefulWidget {
  const PromotionsScreen({super.key});

  @override
  ConsumerState<PromotionsScreen> createState() => _PromotionsScreenState();
}

final class _PromotionsScreenState extends ConsumerState<PromotionsScreen> {
  final TextEditingController _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<PromotionModel>> promotions =
        ref.watch(promotionsControllerProvider);
    final MapFilters filters = ref.watch(mapFiltersProvider);
    final String query = filters.query.toLowerCase();
    final List<PromotionModel> items = ref
        .watch(activePromotionsProvider)
        .where(
          (PromotionModel item) =>
              (filters.category == null ||
                  item.businessName == filters.category) &&
              (query.isEmpty ||
                  item.title.toLowerCase().contains(query) ||
                  (item.businessName ?? '').toLowerCase().contains(query)),
        )
        .toList();

    final List<String> businesses = <String>{
      for (final PromotionModel item in ref.watch(activePromotionsProvider))
        if (item.businessName != null) item.businessName!,
    }.toList();

    return AppScaffold(
      scrollable: false,
      title: context.l10n.promotionsTitle,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.md,
        AppSpacing.xl,
        96,
      ),
      body: ListView(
        children: <Widget>[
          Text(
            context.l10n.promotionsSubtitle,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.md),
          SearchField(
            controller: _search,
            hintText: context.l10n.mapSearchHint,
            onChanged: (String value) =>
                ref.read(mapFiltersProvider.notifier).setQuery(value),
            onClear: () => ref.read(mapFiltersProvider.notifier).setQuery(''),
          ),
          const SizedBox(height: AppSpacing.md),
          FilterChipRow(
            options: businesses,
            selected: filters.category,
            onSelected: (String? value) =>
                ref.read(mapFiltersProvider.notifier).setCategory(value),
          ),
          const SizedBox(height: AppSpacing.lg),
          AsyncValueView<List<PromotionModel>>(
            value: promotions,
            loading: const ListSkeleton(items: 3),
            onRetry: () =>
                ref.read(promotionsControllerProvider.notifier).refresh(),
            emptyBuilder: (List<PromotionModel> value) =>
                items.isEmpty && value.isEmpty
                    ? EmptyStateView(
                        icon: Icons.local_offer_outlined,
                        title: context.l10n.promotionsEmptyTitle,
                        message: context.l10n.promotionsEmptyMessage,
                        actionLabel: context.l10n.commonRetry,
                        onAction: () => ref
                            .read(promotionsControllerProvider.notifier)
                            .refresh(),
                      )
                    : null,
            builder: (List<PromotionModel> value) => items.isEmpty
                ? EmptyStateView(
                    compact: true,
                    icon: Icons.filter_alt_off_rounded,
                    title: context.l10n.promotionsEmptyTitle,
                    message: context.l10n.promotionsEmptyMessage,
                  )
                : Column(
                    children: items
                        .map(
                          (PromotionModel item) => PromotionTile(
                            promotion: item,
                            onTap: () => _showDetail(item),
                          ),
                        )
                        .toList(),
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _showDetail(PromotionModel promotion) => showAppSheet<void>(
        context: context,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              promotion.title,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            if (promotion.businessName != null) ...<Widget>[
              const SizedBox(height: AppSpacing.xxs),
              Text(
                promotion.businessName!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            const SizedBox(height: AppSpacing.lg),
            Text(
              promotion.description ?? promotion.validityLabel(context),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.lg),
            DetailRow(
              icon: Icons.event_outlined,
              label: context.l10n.promotionsTerms,
              value: promotion.validityLabel(context),
            ),
            DetailRow(
              icon: Icons.storefront_outlined,
              label: context.l10n.businessAboutTitle,
              value: promotion.businessName,
            ),
            const SizedBox(height: AppSpacing.md),
            PrimaryButton(
              label: context.l10n.commonClose,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
}
