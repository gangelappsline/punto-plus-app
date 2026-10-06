import 'package:flutter/material.dart';

import '../theme/app_palette.dart';
import '../theme/app_spacing.dart';
import '../utils/extensions.dart';
import 'skeletons.dart';

/// Miniatura de imagen remota con degradado e iniciales como respaldo.
///
/// La app no depende de `cached_network_image`: al integrarlo basta con
/// sustituir el `Image.network` por el widget con caché.
final class RemoteImage extends StatelessWidget {
  const RemoteImage({
    this.url,
    this.fallbackInitials,
    this.width = double.infinity,
    this.height = 120,
    this.radius = AppRadius.md,
    this.icon,
    this.fit = BoxFit.cover,
    super.key,
  });

  final String? url;
  final String? fallbackInitials;
  final double width;
  final double height;
  final double radius;
  final IconData? icon;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;
    final String? source = url;
    final Widget fallback = Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            palette.brandSoft,
            palette.brand.withValues(alpha: 0.35),
          ],
        ),
      ),
      child: (fallbackInitials ?? '').isEmpty
          ? Icon(
              icon ?? Icons.storefront_rounded,
              color: palette.brand,
              size: height * 0.34,
            )
          : Text(
              fallbackInitials!.initials,
              style: TextStyle(
                color: palette.brand,
                fontWeight: FontWeight.w900,
                fontSize: height * 0.3,
              ),
            ),
    );

    if (source == null || source.isEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: fallback,
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Image.network(
        source,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, __, ___) => fallback,
        loadingBuilder: (
          BuildContext context,
          Widget child,
          ImageChunkEvent? progress,
        ) =>
            progress == null
                ? child
                : ShimmerBox(height: height, width: width, radius: radius),
      ),
    );
  }
}

/// Fila con icono, título y subtítulo usada en detalles.
final class DetailRow extends StatelessWidget {
  const DetailRow({
    required this.icon,
    required this.label,
    this.value,
    this.onTap,
    this.trailing,
    super.key,
  });

  final IconData icon;
  final String label;
  final String? value;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;
    final Widget content = Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 36,
            width: 36,
            decoration: BoxDecoration(
              color: palette.surfaceAlt,
              borderRadius: AppRadius.allSm,
            ),
            child: Icon(icon, size: 18, color: palette.brand),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(label, style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 2),
                Text(
                  (value ?? '').isEmpty ? '—' : value!,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );

    if (onTap == null) return content;
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.allSm,
      child: content,
    );
  }
}
