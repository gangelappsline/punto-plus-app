import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_palette.dart';
import '../theme/app_spacing.dart';

/// Botón principal con degradado de marca y estado de carga.
final class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.expand = true,
    this.color,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool expand;

  /// Permite usar el botón con otro color (acciones destructivas o premios).
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;
    final bool enabled = onPressed != null && !isLoading;
    return _ButtonBody(
      expand: expand,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: color == null
              ? AppColors.brandGradient
              : LinearGradient(
                  colors: <Color>[
                    color!,
                    Color.lerp(color, Colors.black, 0.12) ?? color!,
                  ],
                ),
          borderRadius: BorderRadius.circular(AppRadius.pill),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: (color ?? palette.brand).withValues(alpha: 0.28),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: SizedBox(
          height: AppSizes.buttonHeight,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(AppRadius.pill),
              onTap: enabled ? onPressed : null,
              child: Center(
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.4,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          if (icon != null) ...<Widget>[
                            Icon(icon, size: 19, color: Colors.white),
                            const SizedBox(width: AppSpacing.sm),
                          ],
                          Text(
                            label,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Botón secundario con contorno.
final class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.expand = true,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;
    return _ButtonBody(
      expand: expand,
      child: SizedBox(
        height: AppSizes.buttonHeight,
        child: OutlinedButton.icon(
          onPressed: onPressed,
          icon: icon == null ? null : Icon(icon, size: 19),
          label: Text(label),
          style: OutlinedButton.styleFrom(
            foregroundColor: palette.brand,
            side: BorderSide(color: palette.brand.withValues(alpha: 0.4)),
          ),
        ),
      ),
    );
  }
}

/// Botón para acciones destructivas.
final class DangerButton extends StatelessWidget {
  const DangerButton({
    required this.label,
    required this.onPressed,
    this.icon = Icons.delete_outline_rounded,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;
    return SizedBox(
      width: double.infinity,
      height: AppSizes.buttonHeight,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 19),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          foregroundColor: palette.error,
          side: BorderSide(color: palette.error.withValues(alpha: 0.45)),
        ),
      ),
    );
  }
}

/// Botón compacto de acción con icono (listas y tarjetas).
final class IconActionButton extends StatelessWidget {
  const IconActionButton({
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.color,
    this.background,
    super.key,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final Color? color;
  final Color? background;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;
    final Widget button = Material(
      color: background ?? palette.surfaceAlt,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Icon(icon, size: 20, color: color ?? palette.text),
        ),
      ),
    );
    return tooltip == null ? button : Tooltip(message: tooltip!, child: button);
  }
}

/// Botón de texto con icono alineado a la izquierda.
final class TextIconButton extends StatelessWidget {
  const TextIconButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    super.key,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => TextButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        label: Text(label),
      );
}

final class _ButtonBody extends StatelessWidget {
  const _ButtonBody({required this.child, required this.expand});

  final Widget child;
  final bool expand;

  @override
  Widget build(BuildContext context) =>
      expand ? SizedBox(width: double.infinity, child: child) : child;
}
