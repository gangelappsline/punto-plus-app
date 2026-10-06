import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/app_routes.dart';
import '../../../../core/platform/device_services.dart';
import '../../../../core/providers/data_providers.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/feedback.dart';
import '../../../../core/widgets/image_thumb.dart';
import '../../../../core/widgets/progress.dart';
import '../../../../core/widgets/skeletons.dart';
import '../../../cards/data/models/customer_card.dart';
import '../../../cards/data/models/loyalty_card.dart';
import '../../../cards/presentation/providers/cards_providers.dart';
import '../../../cards/presentation/widgets/join_card_sheet.dart';
import '../../../promotions/data/models/promotion.dart';
import '../../../promotions/presentation/widgets/promotion_tile.dart';
import '../../data/models/business.dart';
import '../providers/businesses_providers.dart';
import '../widgets/business_tile.dart';

/// Detalle del negocio: información, tarjetas y promociones.
final class BusinessDetailScreen extends ConsumerWidget {
  const BusinessDetailScreen({required this.businessId, super.key});

  final String businessId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<BusinessDetail> detail =
        ref.watch(businessDetailProvider(businessId));
    return detail.when(
      loading: () => const AppScaffold(
        scrollable: false,
        padding: EdgeInsets.all(AppSpacing.xl),
        body: ListSkeleton(items: 4),
      ),
      error: (Object error, StackTrace stack) => AppScaffold(
        title: context.l10n.businessNotFoundTitle,
        showBackButton: true,
        body: ErrorStateView(
          message: context.l10n.businessNotFoundMessage,
          onRetry: () => ref.invalidate(businessDetailProvider(businessId)),
        ),
      ),
      data: (BusinessDetail value) => _BusinessBody(detail: value),
    );
  }
}

final class _BusinessBody extends ConsumerWidget {
  const _BusinessBody({required this.detail});

  final BusinessDetail detail;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppPalette palette = context.palette;
    final BusinessModel business = detail.business;
    final List<CustomerCardModel> myCards =
        ref.watch(cardsControllerProvider).valueOrNull ??
            <CustomerCardModel>[];
    final Set<String> joinedCardIds = <String>{
      for (final CustomerCardModel card in myCards)
        if (card.loyaltyCard.businessId == business.id) card.loyaltyCard.id,
    };

    return Scaffold(
      backgroundColor: palette.background,
      body: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          BusinessHero(business: business),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                if (business.description != null) ...<Widget>[
                  Text(
                    business.description!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        context.l10n.businessAboutTitle,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      DetailRow(
                        icon: Icons.place_outlined,
                        label: context.l10n.businessAddress,
                        value: business.address,
                      ),
                      DetailRow(
                        icon: Icons.phone_outlined,
                        label: context.l10n.businessPhone,
                        value: business.phone,
                        trailing: business.phone == null
                            ? null
                            : IconActionButton(
                                icon: Icons.phone_rounded,
                                tooltip: context.l10n.businessCallAction,
                                onPressed: () => context.showSnack(
                                  AppFormatters.phone(business.phone),
                                ),
                              ),
                      ),
                      DetailRow(
                        icon: Icons.schedule_outlined,
                        label: context.l10n.businessHours,
                        value: business.todayHours(),
                      ),
                      DetailRow(
                        icon: Icons.star_outline_rounded,
                        label: context.l10n.businessOpenNow,
                        value: business.rating == null
                            ? null
                            : '${business.rating!.toStringAsFixed(1)} '
                                '(${business.ratingCount})',
                      ),
                    ],
                  ),
                ),
                if (business.galleryUrls.isNotEmpty) ...<Widget>[
                  const SizedBox(height: AppSpacing.lg),
                  SectionHeader(
                    title: context.l10n.businessGallery,
                  ),
                  SizedBox(
                    height: 104,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: business.galleryUrls.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(width: AppSpacing.sm),
                      itemBuilder: (BuildContext context, int index) =>
                          RemoteImage(
                        url: business.galleryUrls[index],
                        width: 148,
                        height: 104,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.lg),
                SectionHeader(
                  title: context.l10n.cardsTitle,
                  subtitle: context.l10n.cardsSubtitle,
                ),
                if (detail.cards.isEmpty)
                  EmptyStateView(
                    compact: true,
                    icon: Icons.credit_card_off_outlined,
                    title: context.l10n.cardsEmptyTitle,
                    message: context.l10n.cardsEmptyMessage,
                  )
                else
                  ...detail.cards.map(
                    (LoyaltyCardModel card) => AppCard(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      card.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 14.5,
                                      ),
                                    ),
                                    if (card.rewardDescription != null)
                                      Text(
                                        card.rewardDescription!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                  ],
                                ),
                              ),
                              StatusBadge(
                                label:
                                    '${card.requiredStamps} '
                                    '${context.l10n.commonStampsCount}',
                                color: palette.brand,
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.md),
                          StampsGrid(
                            stampsCount: 0,
                            requiredStamps: card.requiredStamps,
                            columns: 6,
                            stampSize: 26,
                            pendingTone: palette.segmented,
                            tone: palette.brand,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          PrimaryButton(
                            label: joinedCardIds.contains(card.id)
                                ? context.l10n.cardsJoinAlreadyMember
                                : context.l10n.cardsJoinAction,
                            icon: joinedCardIds.contains(card.id)
                                ? Icons.check_rounded
                                : Icons.add_card_rounded,
                            onPressed: joinedCardIds.contains(card.id)
                                ? null
                                : () async {
                                    final CustomerCardModel? joined =
                                        await showJoinCardSheet(context, ref);
                                    if (joined == null ||
                                        !context.mounted) {
                                      return;
                                    }
                                    context.push(
                                      AppRoutes.cardDetailPath(joined.id),
                                    );
                                  },
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: AppSpacing.lg),
                SectionHeader(
                  title: context.l10n.businessPromotionsTitle,
                ),
                if (detail.promotions.isEmpty)
                  EmptyStateView(
                    compact: true,
                    icon: Icons.local_offer_outlined,
                    title: context.l10n.promotionsEmptyTitle,
                    message: context.l10n.promotionsEmptyMessage,
                  )
                else
                  ...detail.promotions.map(
                    (PromotionModel promotion) => PromotionTile(
                      promotion: promotion,
                    ),
                  ),
                const SizedBox(height: AppSpacing.lg),
                SecondaryButton(
                  label: context.l10n.businessShareAction,
                  icon: Icons.share_rounded,
                  onPressed: () async {
                    final ShareResult result = await ref
                        .read(shareServiceProvider)
                        .shareText(
                          '${business.name} · ${AppFormatters.distance(business.distanceKm)}',
                          subject: business.name,
                        );
                    if (!context.mounted) return;
                    if (result.copied) {
                      context.showSnack(
                        context.l10n.commonCopied,
                        kind: AppSnackKind.success,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
