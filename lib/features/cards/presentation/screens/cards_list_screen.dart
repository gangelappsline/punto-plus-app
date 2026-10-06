import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/app_routes.dart';
import '../../../../core/providers/app_providers.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/feedback.dart';
import '../../../../core/widgets/progress.dart';
import '../../../../core/widgets/skeletons.dart';
import '../../../businesses/data/models/business.dart';
import '../../../businesses/presentation/providers/businesses_providers.dart';
import '../../../businesses/presentation/widgets/business_tile.dart';
import '../../../home/presentation/screens/home_shell.dart';
import '../../../promotions/data/models/promotion.dart';
import '../../../promotions/presentation/providers/promotions_providers.dart';
import '../../../promotions/presentation/widgets/promotion_tile.dart';
import '../../data/models/customer_card.dart';
import '../providers/cards_providers.dart';
import '../widgets/customer_card_tile.dart';
import '../widgets/join_card_sheet.dart';

/// Pantalla de inicio del cliente: resumen, tarjetas y accesos rápidos.
final class CardsListScreen extends ConsumerStatefulWidget {
  const CardsListScreen({super.key});

  @override
  ConsumerState<CardsListScreen> createState() => _CardsListScreenState();
}

final class _CardsListScreenState extends ConsumerState<CardsListScreen> {
  Future<void> _openJoinSheet() async {
    final CustomerCardModel? card = await showJoinCardSheet(context, ref);
    if (card == null || !mounted) return;
    await context.push(AppRoutes.cardDetailPath(card.id));
  }

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;
    final AsyncValue<List<CustomerCardModel>> cards =
        ref.watch(cardsControllerProvider);
    final int points = ref.watch(currentUserProvider)?.points ?? 0;
    final List<CustomerCardModel> completed =
        ref.watch(completedCardsProvider);
    final List<CustomerCardModel> all =
        cards.valueOrNull ?? <CustomerCardModel>[];

    return AppScaffold(
      scrollable: false,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.md,
        AppSpacing.xl,
        96,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref
              .read(cardsControllerProvider.notifier)
              .refresh();
          await ref
              .read(promotionsControllerProvider.notifier)
              .refresh();
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: <Widget>[
            PendingVerificationBanner(),
            _Header(
              name: currentUserName(ref) ?? context.l10n.homeGreetingNoName,
            ),
            const SizedBox(height: AppSpacing.lg),
            _PointsCard(
              points: points,
              cardsCount: all.length,
              stampsCount: ref.watch(totalStampsProvider),
            ),
            if (completed.isNotEmpty) ...<Widget>[
              const SizedBox(height: AppSpacing.lg),
              _CompletedBanner(card: completed.first),
            ],
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: <Widget>[
                Expanded(
                  child: _QuickAction(
                    icon: Icons.qr_code_2_rounded,
                    label: context.l10n.cardsShowQrAction,
                    onTap: all.isEmpty
                        ? _openJoinSheet
                        : () => context
                            .push(AppRoutes.cardQrPath(all.first.id)),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _QuickAction(
                    icon: Icons.add_card_rounded,
                    label: context.l10n.homeQuickJoinCard,
                    onTap: _openJoinSheet,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _QuickAction(
                    icon: Icons.people_outline_rounded,
                    label: context.l10n.homeQuickReferral,
                    onTap: () => context.push(AppRoutes.referral),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            SectionHeader(
              title: context.l10n.homeMyCardsTitle,
              subtitle: context.l10n.cardsSubtitle,
              actionLabel: context.l10n.commonSeeAll,
              onAction: () => context.push(AppRoutes.search),
            ),
            const SizedBox(height: AppSpacing.sm),
            AsyncValueView<List<CustomerCardModel>>(
              value: cards,
              loading: const CardSkeleton(),
              onRetry: () => ref.read(cardsControllerProvider.notifier).refresh(),
              emptyBuilder: (List<CustomerCardModel> value) => value.isEmpty
                  ? EmptyStateView(
                      icon: Icons.credit_card_outlined,
                      title: context.l10n.homeNoCardsTitle,
                      message: context.l10n.homeNoCardsMessage,
                      actionLabel: context.l10n.cardsJoinAction,
                      onAction: _openJoinSheet,
                    )
                  : null,
              builder: (List<CustomerCardModel> value) => Column(
                children: value
                    .map(
                      (CustomerCardModel card) => CustomerCardTile(
                        card: card,
                        onTap: () =>
                            context.push(AppRoutes.cardDetailPath(card.id)),
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            _NearbySection(),
            const SizedBox(height: AppSpacing.lg),
            _PromotionsSection(),
            const SizedBox(height: AppSpacing.xl),
            Center(
              child: Text(
                '${context.l10n.appName} · ${context.l10n.appTagline}',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: palette.textFaint),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String? currentUserName(WidgetRef ref) =>
    ref.watch(currentUserProvider)?.displayName;

final class _Header extends StatelessWidget {
  const _Header({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                context.l10n.homeGreetingNoName,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
              ),
            ],
          ),
        ),
        IconActionButton(
          icon: Icons.notifications_none_rounded,
          tooltip: context.l10n.notificationsTitle,
          onPressed: () => context.push(AppRoutes.notifications),
        ),
      ],
    );
  }
}

final class _PointsCard extends StatelessWidget {
  const _PointsCard({
    required this.points,
    required this.cardsCount,
    required this.stampsCount,
  });

  final int points;
  final int cardsCount;
  final int stampsCount;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[palette.brandStrong, palette.brand],
        ),
        borderRadius: AppRadius.allLg,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: palette.brand.withValues(alpha: 0.28),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      context.l10n.homePointsCardTitle,
                      style: TextStyle(
                        color: palette.onBrand.withValues(alpha: 0.85),
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$points',
                      style: TextStyle(
                        color: palette.onBrand,
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      context.l10n.homePointsCardSubtitle,
                      style: TextStyle(
                        color: palette.onBrand.withValues(alpha: 0.8),
                        fontSize: 11.5,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.stars_rounded,
                color: palette.onBrand.withValues(alpha: 0.9),
                size: 44,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: <Widget>[
              Expanded(
                child: _MiniStat(
                  icon: Icons.credit_card_rounded,
                  value: '$cardsCount',
                  label: context.l10n.homeStatsCards,
                ),
              ),
              Expanded(
                child: _MiniStat(
                  icon: Icons.approval_rounded,
                  value: '$stampsCount',
                  label: context.l10n.homeStatsStamps,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

final class _MiniStat extends StatelessWidget {
  const _MiniStat({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;
    return Row(
      children: <Widget>[
        Icon(icon, size: 18, color: palette.onBrand.withValues(alpha: 0.9)),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              value,
              style: TextStyle(
                color: palette.onBrand,
                fontWeight: FontWeight.w900,
                fontSize: 16,
                height: 1.1,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: palette.onBrand.withValues(alpha: 0.8),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

final class _CompletedBanner extends StatelessWidget {
  const _CompletedBanner({required this.card});

  final CustomerCardModel card;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;
    return AppCard(
      onTap: () => context.push(AppRoutes.cardDetailPath(card.id)),
      color: palette.success.withValues(alpha: 0.1),
      borderColor: palette.success.withValues(alpha: 0.35),
      child: Row(
        children: <Widget>[
          Icon(Icons.redeem_rounded, color: palette.success, size: 26),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  context.l10n.homeCompletedBanner,
                  style: TextStyle(
                    color: palette.success,
                    fontWeight: FontWeight.w900,
                    fontSize: 13.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${card.businessName} · '
                  '${context.l10n.homeCompletedBannerMessage}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: palette.success),
        ],
      ),
    );
  }
}

final class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;
    return Material(
      color: palette.surface,
      borderRadius: AppRadius.allLg,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.allLg,
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.md,
            horizontal: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            borderRadius: AppRadius.allLg,
            border: Border.all(color: palette.divider),
          ),
          child: Column(
            children: <Widget>[
              Icon(icon, color: palette.brand, size: 22),
              const SizedBox(height: 6),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w800,
                  color: palette.text,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final class _NearbySection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<BusinessModel> businesses =
        ref.watch(nearbyBusinessesProvider).valueOrNull ??
            <BusinessModel>[];
    if (businesses.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SectionHeader(
          title: context.l10n.homeNearbyTitle,
          actionLabel: context.l10n.commonSeeAll,
          onAction: () => context.go(AppRoutes.map),
        ),
        SizedBox(
          height: 158,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: businesses.take(6).length,
            separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
            itemBuilder: (BuildContext context, int index) {
              final BusinessModel business = businesses[index];
              return SizedBox(
                width: 190,
                child: CompactBusinessCard(business: business),
              );
            },
          ),
        ),
      ],
    );
  }
}

final class _PromotionsSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<PromotionModel> promotions = ref.watch(activePromotionsProvider);
    if (promotions.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SectionHeader(
          title: context.l10n.homePromotionsTitle,
          actionLabel: context.l10n.commonSeeAll,
          onAction: () => context.go(AppRoutes.promotions),
        ),
        ...promotions
            .take(2)
            .map((PromotionModel item) => PromotionTile(promotion: item)),
      ],
    );
  }
}
