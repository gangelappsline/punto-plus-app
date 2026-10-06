import 'package:flutter/material.dart';

import '../theme/app_palette.dart';
import '../theme/app_spacing.dart';
import '../utils/extensions.dart';
import 'app_button.dart';

/// Estado vacío con icono, título y mensaje accionable.
final class EmptyStateView extends StatelessWidget {
  const EmptyStateView({
    required this.title,
    required this.message,
    this.icon = Icons.inbox_rounded,
    this.actionLabel,
    this.onAction,
    this.compact = false,
    super.key,
  });

  final String title;
  final String message;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: compact ? AppSpacing.xl : AppSpacing.xxxl,
        horizontal: AppSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            height: compact ? 64 : 84,
            width: compact ? 64 : 84,
            decoration: BoxDecoration(
              color: palette.brandSoft,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: compact ? 28 : 36,
              color: palette.brand,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (actionLabel != null && onAction != null) ...<Widget>[
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: 220,
              child: PrimaryButton(
                label: actionLabel!,
                onPressed: onAction,
                icon: Icons.refresh_rounded,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Estado de error con reintento.
final class ErrorStateView extends StatelessWidget {
  const ErrorStateView({
    required this.message,
    this.title,
    this.onRetry,
    this.icon = Icons.error_outline_rounded,
    this.compact = false,
    super.key,
  });

  final String message;
  final String? title;
  final VoidCallback? onRetry;
  final IconData icon;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: compact ? AppSpacing.xl : AppSpacing.xxxl,
        horizontal: AppSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: compact ? 34 : 44, color: palette.error),
          const SizedBox(height: AppSpacing.md),
          Text(
            title ?? context.l10n.commonErrorGenericTitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (onRetry != null) ...<Widget>[
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: 200,
              child: PrimaryButton(
                label: context.l10n.commonRetry,
                onPressed: onRetry,
                icon: Icons.refresh_rounded,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Estado "sin conexión" a pantalla completa.
final class NoConnectionView extends StatelessWidget {
  const NoConnectionView({this.onRetry, super.key});

  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => EmptyStateView(
        icon: Icons.wifi_off_rounded,
        title: context.l10n.errorsNoConnectionTitle,
        message: context.l10n.errorsNoConnectionMessage,
        actionLabel: context.l10n.errorsNoConnectionAction,
        onAction: onRetry,
      );
}

/// Separador vertical reutilizable en listas y filas.
final class VerticalSpacer extends StatelessWidget {
  const VerticalSpacer({this.size = AppSpacing.md, super.key});

  final double size;

  @override
  Widget build(BuildContext context) => SizedBox(height: size);
}
