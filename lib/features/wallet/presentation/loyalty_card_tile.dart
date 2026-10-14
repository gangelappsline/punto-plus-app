import 'package:flutter/material.dart';

import '../../../core/presentation/theme.dart';
import '../../../core/presentation/widgets.dart';
import '../domain/loyalty_card.dart';

class LoyaltyCardTile extends StatelessWidget {
  const LoyaltyCardTile(
      {required this.card, this.onTap, this.expanded = false, super.key});
  final LoyaltyCard card;
  final VoidCallback? onTap;
  final bool expanded;

  @override
  Widget build(BuildContext context) => Semantics(
        button: onTap != null,
        label: '${card.businessName}, ${card.stamps} de ${card.target} sellos',
        child: Material(
          color: Color(card.color),
          borderRadius: BorderRadius.circular(28),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Stack(children: [
              if (card.backgroundPath.isNotEmpty)
                Positioned.fill(
                  child: Opacity(
                      opacity: 0.12,
                      child: MediaImage(path: card.backgroundPath)),
                ),
              Positioned(
                  right: -28,
                  top: -24,
                  child: Icon(businessIcon(card.symbol),
                      size: 172, color: ink.withValues(alpha: 0.045))),
              Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Container(
                          width: 48,
                          height: 48,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.65),
                              borderRadius: BorderRadius.circular(16)),
                          child: card.logoPath.isEmpty
                              ? Icon(businessIcon(card.symbol), size: 26)
                              : MediaImage(path: card.logoPath),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                              Text(card.category,
                                  style: const TextStyle(
                                      fontSize: 10,
                                      letterSpacing: 1.8,
                                      fontWeight: FontWeight.w600)),
                              const SizedBox(height: 2),
                              Text(card.businessName,
                                  style:
                                      Theme.of(context).textTheme.titleLarge),
                            ])),
                        if (onTap != null)
                          const Icon(Icons.north_east_rounded, size: 20),
                      ]),
                      const SizedBox(height: 22),
                      Wrap(
                          spacing: 8,
                          runSpacing: 10,
                          children: List.generate(card.target, (index) {
                            final filled = index < card.stamps;
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: expanded ? 46 : 34,
                              height: expanded ? 46 : 34,
                              decoration: BoxDecoration(
                                color: filled
                                    ? ink
                                    : Colors.white.withValues(alpha: 0.35),
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: filled
                                        ? ink
                                        : ink.withValues(alpha: 0.16)),
                              ),
                              child: filled && card.stampPath.isNotEmpty
                                  ? ClipOval(
                                      child: MediaImage(path: card.stampPath))
                                  : Icon(
                                      filled
                                          ? businessIcon(card.symbol)
                                          : Icons.add_rounded,
                                      size: expanded ? 23 : 18,
                                      color: filled
                                          ? Color(card.color)
                                          : ink.withValues(alpha: 0.24)),
                            );
                          })),
                      const SizedBox(height: 20),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Text(
                                    card.canRedeem
                                        ? '¡Tu recompensa está lista!'
                                        : '${card.remaining} sellos para tu recompensa',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13))),
                            const SizedBox(width: 8),
                            Text('${card.stamps}/${card.target}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w800)),
                          ]),
                      if (expanded) ...[
                        const SizedBox(height: 8),
                        Text(card.reward)
                      ],
                    ]),
              ),
            ]),
          ),
        ),
      );
}
