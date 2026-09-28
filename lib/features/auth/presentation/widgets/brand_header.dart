import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

final class BrandHeader extends StatelessWidget {
  const BrandHeader({super.key});

  @override
  Widget build(BuildContext context) => Column(
        children: <Widget>[
          const SizedBox(
            height: 96,
            child: Center(child: PuntoPlusLogo()),
          ),
          Container(
            height: 23,
            padding: const EdgeInsets.symmetric(horizontal: 13),
            decoration: BoxDecoration(
              color: AppColors.lightBlue,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  Icons.sell_outlined,
                  size: 14,
                  color: AppColors.navy,
                ),
                SizedBox(width: 6),
                Text(
                  'Tu billetera de recompensas favorita',
                  style: TextStyle(
                    color: AppColors.navy,
                    fontSize: 11,
                    height: 1,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Colecciona sellos, canjea premios y lleva todas tus\ncuponeras en un solo lugar.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 13,
              height: 1.23,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
}

final class PuntoPlusLogo extends StatelessWidget {
  const PuntoPlusLogo({super.key});

  @override
  Widget build(BuildContext context) => Semantics(
        label: 'Punto más',
        image: true,
        child: const Text.rich(
          TextSpan(
            children: <InlineSpan>[
              TextSpan(
                text: 'Punto',
                style: TextStyle(
                  color: AppColors.navy,
                  fontSize: 24,
                  letterSpacing: -0.7,
                  fontWeight: FontWeight.w900,
                ),
              ),
              TextSpan(
                text: '+',
                style: TextStyle(
                  color: AppColors.orange,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      );
}
