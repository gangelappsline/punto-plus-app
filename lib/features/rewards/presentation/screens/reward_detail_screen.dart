import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/providers/data_providers.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_dialogs.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/feedback.dart';
import '../../../../core/widgets/image_thumb.dart';
import '../../../cards/presentation/providers/cards_providers.dart';
import '../../data/models/reward.dart';
import '../providers/rewards_providers.dart';

/// Detalle de un premio con su código de canje.
final class RewardDetailScreen extends ConsumerStatefulWidget {
  const RewardDetailScreen({required this.rewardId, super.key});

  final String rewardId;

  @override
  ConsumerState<RewardDetailScreen> createState() => _RewardDetailScreenState();
}

final class _RewardDetailScreenState
    extends ConsumerState<RewardDetailScreen> {
  bool _loading = false;

  Future<void> _redeem(RewardModel reward) async {
    final bool confirmed = await showConfirmDialog(
      context: context,
      title: context.l10n.rewardsRedeemConfirmTitle,
      message: context.l10n.rewardsRedeemConfirmMessage,
      confirmLabel: context.l10n.rewardsRedeemConfirmAction,
      icon: Icons.redeem_rounded,
    );
    if (!confirmed || !mounted) return;
    setState(() => _loading = true);
    try {
      await ref.read(rewardsControllerProvider.notifier).redeem(reward.id);
      ref.invalidate(cardsControllerProvider);
      if (!mounted) return;
      context.showSnack(
        context.l10n.rewardsRedeemSuccess,
        kind: AppSnackKind.success,
      );
    } catch (error) {
      if (!mounted) return;
      context.showSnack(
        context.l10n.rewardsRedeemError,
        kind: AppSnackKind.error,
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;
    final RewardModel? reward = ref.watch(rewardByIdProvider(widget.rewardId));

    if (reward == null) {
      return AppScaffold(
        title: context.l10n.rewardsDetailTitle,
        showBackButton: true,
        body: EmptyStateView(
          icon: Icons.search_off_rounded,
          title: context.l10n.rewardsEmptyAvailableTitle,
          message: context.l10n.commonEmptyGenericMessage,
          actionLabel: context.l10n.commonBack,
          onAction: () => context.pop(),
        ),
      );
    }

    final RewardStatus status = reward.resolvedStatus;
    return AppScaffold(
      title: context.l10n.rewardsDetailTitle,
      showBackButton: true,
      padding: const EdgeInsets.all(AppSpacing.xl),
      bottomBar: status.isAvailable
          ? BottomActionBar(
              child: PrimaryButton(
                label: context.l10n.rewardsRedeemAction,
                icon: Icons.redeem_rounded,
                isLoading: _loading,
                onPressed: () => _redeem(reward),
              ),
            )
          : null,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          RemoteImage(
            url: reward.imageUrl,
            fallbackInitials: reward.businessName,
            height: 190,
            radius: AppRadius.lg,
            icon: Icons.card_giftcard_rounded,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            reward.title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(height: AppSpacing.xs),
          StatusBadge(
            label: switch (status) {
              RewardStatus.available => context.l10n.rewardsStatusAvailable,
              RewardStatus.redeemed => context.l10n.rewardsStatusRedeemed,
              RewardStatus.expired => context.l10n.rewardsStatusExpired,
            },
            color: switch (status) {
              RewardStatus.available => palette.success,
              RewardStatus.redeemed => palette.brand,
              RewardStatus.expired => palette.textMuted,
            },
          ),
          if (reward.description != null) ...<Widget>[
            const SizedBox(height: AppSpacing.lg),
            Text(
              reward.description!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                DetailRow(
                  icon: Icons.storefront_outlined,
                  label: context.l10n.businessAboutTitle,
                  value: reward.businessName,
                ),
                DetailRow(
                  icon: Icons.approval_rounded,
                  label: context.l10n.cardsStampsTitle,
                  value: reward.requiredStamps?.toString(),
                ),
                DetailRow(
                  icon: Icons.event_outlined,
                  label: context.l10n.promotionsTerms,
                  value: AppFormatters.longDate(context, reward.expiresAt),
                ),
                if (reward.redeemedAt != null)
                  DetailRow(
                    icon: Icons.history_rounded,
                    label: context.l10n.rewardsStatusRedeemed,
                    value: AppFormatters.dateTime(context, reward.redeemedAt),
                  ),
              ],
            ),
          ),
          if (reward.code != null && !status.isAvailable) ...<Widget>[
            const SizedBox(height: AppSpacing.lg),
            AppCard(
              color: palette.brandSoft,
              borderColor: palette.brand.withValues(alpha: 0.3),
              child: Column(
                children: <Widget>[
                  Text(
                    context.l10n.rewardsCodeLabel,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  SelectableText(
                    reward.code!,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 3,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  SecondaryButton(
                    label: context.l10n.commonCopy,
                    icon: Icons.copy_rounded,
                    onPressed: () async {
                      await ref
                          .read(shareServiceProvider)
                          .shareText(reward.code!);
                      if (!context.mounted) return;
                      context.showSnack(context.l10n.commonCopied);
                    },
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
