import 'package:flutter/material.dart';

import '../../core/theme/app_palette.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/app_button.dart';

/// Pantalla genérica de error (sin conexión, mantenimiento, 403, 404).
final class ErrorScreen extends StatelessWidget {
  const ErrorScreen({
    required this.title,
    required this.message,
    required this.icon,
    this.primaryLabel,
    this.onPrimary,
    this.secondaryLabel,
    this.onSecondary,
    super.key,
  });

  final String title;
  final String message;
  final IconData icon;
  final String? primaryLabel;
  final VoidCallback? onPrimary;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;
    return Scaffold(
      backgroundColor: palette.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: AppSizes.maxContentWidth),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 96,
                    width: 96,
                    decoration: BoxDecoration(
                      color: palette.brandSoft,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, size: 42, color: palette.brand),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  if (primaryLabel != null && onPrimary != null)
                    PrimaryButton(
                      label: primaryLabel!,
                      onPressed: onPrimary,
                    ),
                  if (secondaryLabel != null && onSecondary != null) ...<Widget>[
                    const SizedBox(height: AppSpacing.sm),
                    SecondaryButton(
                      label: secondaryLabel!,
                      onPressed: onSecondary,
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
}
