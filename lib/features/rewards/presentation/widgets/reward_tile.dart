import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/image_thumb.dart';
import '../../data/models/reward.dart';

/// Fila de premio con su estado (disponible, canjeado o vencido).
final class RewardTile extends StatelessWidget {
  const RewardTile({required this.reward, this.onTap, super.key});

  final RewardModel reward;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;
    final RewardStatus status = reward.resolvedStatus;
    final (Color tone, String label) = switch (status) {
      RewardStatus.available => (
          palette.success,
          context.l10n.rewardsStatusAvailable,
        ),
      RewardStatus.redeemed => (
          palette.brand,
          context.l10n.rewardsStatusRedeemed,
        ),
      RewardStatus.expired => (
          palette.textMuted,
          context.l10n.rewardsStatusExpired,
        ),
    };

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: AppCard(
        padding: const EdgeInsets.all(AppSpacing.md),
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: <Widget>[
                RemoteImage(
                  url: reward.imageUrl,
                  fallbackInitials: reward.businessName,
                  width: 66,
                  height: 66,
                  icon: Icons.card_giftcard_rounded,
                ),
                Positioned(
                  right: 4,
                  bottom: 4,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: tone,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      switch (status) {
                        RewardStatus.available => Icons.check_rounded,
                        RewardStatus.redeemed => Icons.done_all_rounded,
                        RewardStatus.expired => Icons.close_rounded,
                      },
                      size: 11,
                      color: palette.onBrand,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    reward.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                    ),
                  ),
                  if (reward.businessName != null)
                    Text(
                      reward.businessName!,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  const SizedBox(height: 6),
                  Row(
                    children: <Widget>[
                      StatusBadge(label: label, color: tone),
                      if (reward.expiresAt != null &&
                          status.isAvailable) ...<Widget>[
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            AppFormatters.relative(context, reward.expiresAt),
                            style: Theme.of(context).textTheme.bodySmall,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: palette.textFaint,
            ),
          ],
        ),
      ),
    );
  }
}
