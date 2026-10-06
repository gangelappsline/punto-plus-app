import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/progress.dart';
import '../../../cards/data/models/customer_card.dart';

/// Tarjeta visual del cliente con su progreso de sellos.
final class CustomerCardTile extends StatelessWidget {
  const CustomerCardTile({
    required this.card,
    this.onTap,
    this.compact = false,
    super.key,
  });

  final CustomerCardModel card;
  final VoidCallback? onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;
    final Color background = card.loyaltyCard.resolvedBackground;
    final Color foreground = _foregroundFor(background);
    final double progress = card.progress.clamp(0, 1);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.allLg,
          child: Ink(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  background,
                  Color.lerp(background, Colors.black, 0.22) ?? background,
                ],
              ),
              borderRadius: AppRadius.allLg,
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: background.withValues(alpha: 0.32),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _Logo(card: card, foreground: foreground),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              card.businessName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: foreground,
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              card.loyaltyCard.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: foreground.withValues(alpha: 0.82),
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (card.isCompleted)
                        CompletionBadge(label: context.l10n.cardsReadyBadge)
                      else if (!card.isActive)
                        StatusBadge(
                          label: context.l10n.cardsInactive,
                          color: foreground,
                          filled: false,
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  if (!compact) ...<Widget>[
                    StampsGrid(
                      stampsCount: card.stampsCount,
                      requiredStamps: card.requiredStamps,
                      columns: 5,
                      stampSize: 40,
                      icon: Icons.star_rounded,
                      tone: foreground,
                      pendingTone: foreground.withValues(alpha: 0.18),
                      animate: false,
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          '${card.stampsCount}/${card.requiredStamps} '
                          '${context.l10n.commonStampsCount}',
                          style: TextStyle(
                            color: foreground,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      Text(
                        '${(progress * 100).round()}%',
                        style: TextStyle(
                          color: foreground.withValues(alpha: 0.9),
                          fontSize: 12.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: AppRadius.allPill,
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 6,
                      backgroundColor: foreground.withValues(alpha: 0.22),
                      valueColor: AlwaysStoppedAnimation<Color>(foreground),
                    ),
                  ),
                  if (!compact) ...<Widget>[
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.local_activity_rounded,
                          size: 15,
                          color: foreground.withValues(alpha: 0.85),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            card.loyaltyCard.rewardDescription ??
                                context.l10n.cardsRewardLabel,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: foreground.withValues(alpha: 0.85),
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        if (palette.brand != background)
                          Icon(
                            Icons.chevron_right_rounded,
                            color: foreground.withValues(alpha: 0.9),
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _foregroundFor(Color background) =>
      background.computeLuminance() > 0.6 ? Colors.black87 : Colors.white;
}

final class _Logo extends StatelessWidget {
  const _Logo({required this.card, required this.foreground});

  final CustomerCardModel card;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    final String? url = card.loyaltyCard.logoUrl ??
        card.loyaltyCard.stampIconUrl ??
        card.loyaltyCard.businessLogoUrl;
    return Container(
      height: 46,
      width: 46,
      decoration: BoxDecoration(
        color: foreground.withValues(alpha: 0.18),
        borderRadius: AppRadius.allMd,
      ),
      clipBehavior: Clip.antiAlias,
      child: url == null || url.isEmpty
          ? Icon(Icons.storefront_rounded, color: foreground, size: 22)
          : Image.network(
              url,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  Icon(Icons.storefront_rounded, color: foreground, size: 22),
            ),
    );
  }
}
