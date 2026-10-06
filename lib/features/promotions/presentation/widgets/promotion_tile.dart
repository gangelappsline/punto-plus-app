import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/image_thumb.dart';
import '../../data/models/promotion.dart';

/// Tarjeta de promoción usada en listas y carruseles.
final class PromotionTile extends StatelessWidget {
  const PromotionTile({
    required this.promotion,
    this.onTap,
    this.horizontal = false,
    super.key,
  });

  final PromotionModel promotion;
  final VoidCallback? onTap;
  final bool horizontal;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;
    final PromotionStatus status = promotion.statusAt();
    final Color tone = switch (status) {
      PromotionStatus.active => palette.success,
      PromotionStatus.scheduled => palette.brand,
      PromotionStatus.expired => palette.textMuted,
      PromotionStatus.paused => palette.warning,
    };
    final String statusLabel = switch (status) {
      PromotionStatus.active => context.l10n.managePromotionsStatusActive,
      PromotionStatus.scheduled => context.l10n.managePromotionsStatusScheduled,
      PromotionStatus.expired => context.l10n.managePromotionsStatusExpired,
      PromotionStatus.paused => context.l10n.managePromotionsStatusPaused,
    };

    if (horizontal) {
      return SizedBox(
        width: 240,
        child: AppCard(
          padding: EdgeInsets.zero,
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              RemoteImage(
                url: promotion.imageUrl,
                fallbackInitials: promotion.businessName,
                height: 96,
                radius: 0,
                icon: Icons.local_offer_rounded,
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      promotion.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 13.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      promotion.validityLabel(context),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: AppCard(
        padding: const EdgeInsets.all(AppSpacing.md),
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            RemoteImage(
              url: promotion.imageUrl,
              fallbackInitials: promotion.businessName,
              width: 72,
              height: 72,
              icon: Icons.local_offer_rounded,
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
                          promotion.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      StatusBadge(label: statusLabel, color: tone),
                    ],
                  ),
                  if (promotion.businessName != null) ...<Widget>[
                    const SizedBox(height: 2),
                    Text(
                      promotion.businessName!,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                  if (promotion.description != null) ...<Widget>[
                    const SizedBox(height: 4),
                    Text(
                      promotion.description!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                  const SizedBox(height: 6),
                  Row(
                    children: <Widget>[
                      Icon(Icons.event_outlined,
                          size: 13, color: palette.textFaint),
                      const SizedBox(width: 4),
                      Text(
                        promotion.validityLabel(context),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Etiqueta de vigencia reutilizable.
extension PromotionLabels on PromotionModel {
  String validityLabel(BuildContext context) {
    final DateTime? start = startsAt;
    final DateTime? end = endsAt;
    if (end == null) return context.l10n.promotionsTerms;
    if (start == null) {
      return '${context.l10n.promotionsTerms}: '
          '${AppFormatters.dayMonth(context, end)}';
    }
    return '${AppFormatters.dayMonth(context, start)} - '
        '${AppFormatters.dayMonth(context, end)}';
  }
}
