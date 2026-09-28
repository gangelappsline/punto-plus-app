import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

final class GradientButton extends StatelessWidget {
  const GradientButton({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: <Color>[AppColors.teal, AppColors.cyan],
          ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Color(0x2900616D),
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: SizedBox(
          height: 48,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(28),
              onTap: isLoading ? null : onPressed,
              child: Center(
                child: isLoading
                    ? const SizedBox.square(
                        dimension: 21,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.4,
                          color: Colors.white,
                        ),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            label,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      );
}
