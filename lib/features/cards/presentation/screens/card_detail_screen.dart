import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/app_routes.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_dialogs.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/feedback.dart';
import '../../../../core/widgets/image_thumb.dart';
import '../../../../core/widgets/progress.dart';
import '../../../../core/widgets/skeletons.dart';
import '../../../rewards/presentation/providers/rewards_providers.dart';
import '../../data/models/customer_card.dart';
import '../../data/models/stamp.dart';
import '../providers/cards_providers.dart';

/// Detalle de una tarjeta: sellos, recompensa e historial.
final class CardDetailScreen extends ConsumerWidget {
  const CardDetailScreen({required this.cardId, super.key});

  final String cardId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<CustomerCardModel> card = ref.watch(
      cardDetailProvider(cardId),
    );
    return AppScaffold(
      scrollable: false,
      padding: EdgeInsets.zero,
      body: card.when(
        loading: () => const Padding(
          padding: EdgeInsets.all(AppSpacing.xl),
          child: CardSkeleton(height: 210),
        ),
        error: (Object error, StackTrace stack) => Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: ErrorStateView(
            message: context.l10n.cardsDetailError,
            onRetry: () => ref.invalidate(cardDetailProvider(cardId)),
          ),
        ),
        data: (CustomerCardModel value) => _CardDetailBody(card: value),
      ),
    );
  }
}

final class _CardDetailBody extends ConsumerWidget {
  const _CardDetailBody({required this.card});

  final CustomerCardModel card;

  Future<void> _redeem(BuildContext context, WidgetRef ref) async {
    final bool confirmed = await showConfirmDialog(
      context: context,
      title: context.l10n.rewardsRedeemConfirmTitle,
      message: context.l10n.rewardsRedeemConfirmMessage,
      confirmLabel: context.l10n.rewardsRedeemAction,
      icon: Icons.redeem_rounded,
    );
    if (!confirmed) return;
    try {
      await redeemCardReward(ref, card.id);
      ref.invalidate(cardDetailProvider(card.id));
      ref.invalidate(cardsControllerProvider);
      ref.invalidate(rewardsControllerProvider);
      if (!context.mounted) return;
      context.showSnack(
        context.l10n.rewardsRedeemSuccess,
        kind: AppSnackKind.success,
      );
    } catch (error) {
      if (!context.mounted) return;
      context.showSnack(error.toString(), kind: AppSnackKind.error);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppPalette palette = context.palette;
    final AsyncValue<List<StampModel>> stamps =
        ref.watch(cardStampsProvider(card.id));
    final Color background = card.loyaltyCard.resolvedBackground;
    final Color foreground = background.computeLuminance() > 0.6
        ? Colors.black87
        : Colors.white;

    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                background,
                Color.lerp(background, palette.background, 0.55) ?? background,
              ],
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    IconActionButton(
                      icon: Icons.arrow_back_rounded,
                      color: foreground,
                      background: Colors.white.withValues(alpha: 0.18),
                      onPressed: () => Navigator.of(context).maybePop(),
                    ),
                    const Spacer(),
                    IconActionButton(
                      icon: Icons.share_rounded,
                      color: foreground,
                      background: Colors.white.withValues(alpha: 0.18),
                      onPressed: () => context.showSnack(
                        context.l10n.commonCopied,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.xl,
                    AppSpacing.md,
                    AppSpacing.xl,
                    AppSpacing.xl,
                  ),
                  child: Column(
                    children: <Widget>[
                      Text(
                        card.businessName,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: foreground,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        card.loyaltyCard.name,
                        style: TextStyle(
                          color: foreground.withValues(alpha: 0.85),
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      StampsGrid(
                        stampsCount: card.stampsCount,
                        requiredStamps: card.requiredStamps,
                        columns: 5,
                        icon: Icons.star_rounded,
                        tone: foreground,
                        pendingTone: foreground.withValues(alpha: 0.2),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        card.isCompleted
                            ? context.l10n.cardsReadyBadge
                            : '${context.l10n.cardsStampsTitle}: '
                                '${card.stampsCount}/${card.requiredStamps}',
                        style: TextStyle(
                          color: foreground,
                          fontWeight: FontWeight.w900,
                          fontSize: 13.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${context.l10n.cardsRewardLabel}: '
                        '${card.loyaltyCard.rewardDescription ?? '—'}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: foreground.withValues(alpha: 0.85),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              PrimaryButton(
                label: context.l10n.cardsShowQrAction,
                icon: Icons.qr_code_2_rounded,
                onPressed: () => context.push(AppRoutes.cardQrPath(card.id)),
              ),
              if (card.isCompleted) ...<Widget>[
                const SizedBox(height: AppSpacing.sm),
                PrimaryButton(
                  label: context.l10n.rewardsRedeemAction,
                  icon: Icons.redeem_rounded,
                  color: palette.success,
                  onPressed: () => _redeem(context, ref),
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      context.l10n.cardsRulesTitle,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    DetailRow(
                      icon: Icons.approval_rounded,
                      label: context.l10n.cardsStampsTitle,
                      value: '${card.requiredStamps}',
                    ),
                    DetailRow(
                      icon: Icons.local_activity_outlined,
                      label: context.l10n.cardsRewardLabel,
                      value: card.loyaltyCard.rewardDescription,
                    ),
                    DetailRow(
                      icon: Icons.history_rounded,
                      label: context.l10n.cardsHistoryTitle,
                      value: AppFormatters.longDate(
                        context,
                        card.lastStampAt ?? card.createdAt,
                      ),
                    ),
                    if (card.expiresAt != null)
                      DetailRow(
                        icon: Icons.event_busy_rounded,
                        label: context.l10n.promotionsExpired,
                        value: AppFormatters.longDate(context, card.expiresAt),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              SectionHeader(
                title: context.l10n.cardsHistoryTitle,
                subtitle: context.l10n.cardsSubtitle,
              ),
              AsyncValueView<List<StampModel>>(
                value: stamps,
                loading: const ListSkeleton(items: 3, height: 56),
                onRetry: () => ref.invalidate(cardStampsProvider(card.id)),
                emptyBuilder: (List<StampModel> value) => value.isEmpty
                    ? EmptyStateView(
                        compact: true,
                        icon: Icons.history_toggle_off_rounded,
                        title: context.l10n.cardsHistoryEmpty,
                        message: context.l10n.commonEmptyGenericMessage,
                      )
                    : null,
                builder: (List<StampModel> value) => Column(
                  children: value
                      .map(
                        (StampModel stamp) => AppCard(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.sm,
                          ),
                          child: Row(
                            children: <Widget>[
                              Container(
                                height: 34,
                                width: 34,
                                decoration: BoxDecoration(
                                  color: palette.brandSoft,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.star_rounded,
                                  size: 17,
                                  color: palette.brand,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      stamp.businessName ??
                                          card.businessName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 13,
                                      ),
                                    ),
                                    Text(
                                      AppFormatters.dateTime(
                                        context,
                                        stamp.createdAt,
                                      ),
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                              if (stamp.note != null)
                                Text(
                                  stamp.note!,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Espacio reservado para futuras acciones sobre la tarjeta.
final class CardDetailActions extends StatelessWidget {
  const CardDetailActions({super.key});

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
