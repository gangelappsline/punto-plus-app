import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import 'social_button.dart';

final class SocialSection extends StatelessWidget {
  const SocialSection({
    required this.onGoogle,
    required this.onApple,
    super.key,
  });

  final VoidCallback onGoogle;
  final VoidCallback onApple;

  @override
  Widget build(BuildContext context) => Column(
        children: <Widget>[
          const Row(
            children: <Widget>[
              Expanded(child: Divider(color: AppColors.divider, height: 1)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 9),
                child: Text(
                  'O INGRESA CON',
                  style: TextStyle(
                    color: Color(0xFF788287),
                    fontSize: 10.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Expanded(child: Divider(color: AppColors.divider, height: 1)),
            ],
          ),
          const SizedBox(height: 17),
          Row(
            children: <Widget>[
              Expanded(
                child: SocialButton(
                  type: SocialButtonType.google,
                  onPressed: onGoogle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SocialButton(
                  type: SocialButtonType.apple,
                  onPressed: onApple,
                ),
              ),
            ],
          ),
        ],
      );
}
