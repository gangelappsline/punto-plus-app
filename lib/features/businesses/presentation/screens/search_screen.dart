import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/app_routes.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/feedback.dart';
import '../../../../core/widgets/skeletons.dart';
import '../../../cards/data/models/customer_card.dart';
import '../../../cards/presentation/providers/cards_providers.dart';
import '../../../cards/presentation/widgets/customer_card_tile.dart';
import '../../data/models/business.dart';
import '../providers/businesses_providers.dart';
import '../widgets/business_tile.dart';

/// Buscador global de negocios y tarjetas del cliente.
final class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

final class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;
    final String query = _query.toLowerCase().trim();
    final List<BusinessModel> businesses =
        ref.watch(nearbyBusinessesProvider).valueOrNull ?? <BusinessModel>[];
    final AsyncValue<List<CustomerCardModel>> cards =
        ref.watch(cardsControllerProvider);
    final List<BusinessModel> matchedBusinesses = query.isEmpty
        ? businesses
        : businesses
            .where(
              (BusinessModel item) =>
                  item.name.toLowerCase().contains(query) ||
                  (item.category ?? '').toLowerCase().contains(query) ||
                  (item.description ?? '').toLowerCase().contains(query),
            )
            .toList();
    final List<CustomerCardModel> matchedCards =
        (cards.valueOrNull ?? <CustomerCardModel>[])
            .where(
              (CustomerCardModel card) =>
                  query.isEmpty ||
                  card.businessName.toLowerCase().contains(query) ||
                  card.loyaltyCard.name.toLowerCase().contains(query),
            )
            .toList();

    return AppScaffold(
      scrollable: false,
      title: context.l10n.commonSearch,
      showBackButton: true,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.md,
        AppSpacing.xl,
        96,
      ),
      body: ListView(
        children: <Widget>[
          SearchField(
            controller: _controller,
            hintText: context.l10n.mapSearchHint,
            onChanged: (String value) => setState(() => _query = value),
            onClear: () => setState(() {
              _query = '';
              _controller.clear();
            }),
          ),
          const SizedBox(height: AppSpacing.lg),
          if (matchedCards.isNotEmpty) ...<Widget>[
            SectionHeader(title: context.l10n.homeMyCardsTitle),
            ...matchedCards.map(
              (CustomerCardModel card) => CustomerCardTile(
                card: card,
                compact: true,
                onTap: () => context.push(AppRoutes.cardDetailPath(card.id)),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
          SectionHeader(
            title: context.l10n.homeNearbyTitle,
            actionLabel: context.l10n.commonSeeAll,
            onAction: () => context.push(AppRoutes.favorites),
          ),
          if (matchedBusinesses.isEmpty)
            EmptyStateView(
              compact: true,
              icon: Icons.search_off_rounded,
              title: context.l10n.commonEmptyGenericTitle,
              message: context.l10n.commonEmptyGenericMessage,
            )
          else
            ...matchedBusinesses.map(
              (BusinessModel item) => BusinessTile(business: item),
            ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: <Widget>[
              Icon(Icons.favorite_rounded, size: 16, color: palette.error),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  context.l10n.businessFavoriteAdd,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              TextButton(
                onPressed: () => context.push(AppRoutes.favorites),
                child: Text(context.l10n.commonSeeDetail),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
