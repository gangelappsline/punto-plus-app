import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_palette.dart';
import '../theme/app_spacing.dart';
import 'network_banner.dart';
import 'skeletons.dart';

/// Anima la aparición de cualquier widget (micro-interacciones suaves).
final class FadeSlideIn extends StatefulWidget {
  const FadeSlideIn({
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 260),
    this.offset = 14,
    super.key,
  });

  final Widget child;
  final Duration delay;
  final Duration duration;
  final double offset;

  @override
  State<FadeSlideIn> createState() => _FadeSlideInState();
}

final class _FadeSlideInState extends State<FadeSlideIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  );

  @override
  void initState() {
    super.initState();
    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      Future<void>.delayed(widget.delay, () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget? child) => Opacity(
          opacity: _controller.value,
          child: Transform.translate(
            offset: Offset(0, widget.offset * (1 - _controller.value)),
            child: child,
          ),
        ),
        child: widget.child,
      );
}

/// Contenedor base de pantalla: fondo, ancho máximo y banner de conexión.
final class AppScaffold extends StatelessWidget {
  const AppScaffold({
    required this.body,
    this.title,
    this.actions,
    this.leading,
    this.bottomBar,
    this.floatingActionButton,
    this.showBackButton = false,
    this.onBack,
    this.padding = AppSpacing.scroll,
    this.maxContentWidth = AppSizes.maxContentWidth,
    this.resizeToAvoidBottomInset = true,
    this.scrollable = true,
    super.key,
  });

  final Widget body;
  final String? title;
  final List<Widget>? actions;
  final Widget? leading;
  final Widget? bottomBar;
  final Widget? floatingActionButton;
  final bool showBackButton;
  final VoidCallback? onBack;
  final EdgeInsets padding;
  final double maxContentWidth;
  final bool resizeToAvoidBottomInset;
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);
    return Scaffold(
      backgroundColor: palette.background,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      appBar: title == null
          ? null
          : AppBar(
              title: Text(title!),
              automaticallyImplyLeading: false,
              leading: leading ??
                  (showBackButton
                      ? IconButton(
                          onPressed: onBack ?? () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.arrow_back_rounded),
                          tooltip: MaterialLocalizations.of(context)
                              .backButtonTooltip,
                        )
                      : null),
              actions: actions,
            ),
      body: SafeArea(
        bottom: bottomBar == null,
        child: Column(
          children: <Widget>[
            const ConnectivityBanner(),
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxContentWidth),
                  child: scrollable
                      ? SingleChildScrollView(
                          padding: padding,
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          child: body,
                        )
                      : Padding(padding: padding, child: body),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: bottomBar,
      floatingActionButton: floatingActionButton,
    );
  }
}

/// Encabezado de sección con acción opcional ("Ver todo").
final class SectionHeader extends StatelessWidget {
  const SectionHeader({
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
    this.leading,
    super.key,
  });

  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          if (leading != null) ...<Widget>[
            leading!,
            const SizedBox(width: AppSpacing.sm),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: palette.textMuted),
                  ),
              ],
            ),
          ),
          if (actionLabel != null && onAction != null)
            TextButton(
              onPressed: onAction,
              child: Text(actionLabel!),
            ),
        ],
      ),
    );
  }
}

/// Tarjeta base con borde suave y sombra ligera.
final class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.onTap,
    this.color,
    this.borderColor,
    this.radius = AppRadius.lg,
    super.key,
  });

  final Widget child;
  final EdgeInsets padding;
  final VoidCallback? onTap;
  final Color? color;
  final Color? borderColor;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);
    final Widget content = Padding(padding: padding, child: child);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color ?? palette.surface,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: borderColor ?? palette.divider),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: palette.shadow,
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: onTap == null
          ? content
          : Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(radius),
                child: content,
              ),
            ),
    );
  }
}

/// Bloque de esqueleto mientras llegan los datos.
final class LoadingBlock extends StatelessWidget {
  const LoadingBlock({this.height = 96, this.lines = 0, super.key});

  final double height;
  final int lines;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ShimmerBox(height: height, width: double.infinity),
          if (lines > 0) const SizedBox(height: AppSpacing.md),
          ...List<Widget>.generate(
            lines,
            (int index) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: ShimmerBox(
                height: 14,
                width: index.isEven ? double.infinity : 220,
              ),
            ),
          ),
        ],
      );
}

/// Insignia de estado con color semántico.
final class StatusBadge extends StatelessWidget {
  const StatusBadge({
    required this.label,
    this.color,
    this.icon,
    this.filled = true,
    super.key,
  });

  final String label;
  final Color? color;
  final IconData? icon;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);
    final Color tone = color ?? palette.brand;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: filled ? tone.withValues(alpha: 0.14) : null,
        border: filled ? null : Border.all(color: tone),
        borderRadius: AppRadius.allPill,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (icon != null) ...<Widget>[
            Icon(icon, size: 13, color: tone),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              color: tone,
              fontSize: 11.5,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

/// Fila de estadísticas compactas (puntos, sellos, tarjetas).
final class StatTile extends StatelessWidget {
  const StatTile({
    required this.label,
    required this.value,
    this.icon,
    this.tone,
    super.key,
  });

  final String label;
  final String value;
  final IconData? icon;
  final Color? tone;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);
    final Color color = tone ?? palette.brand;
    return AppCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (icon != null) ...<Widget>[
            Icon(icon, size: 18, color: color),
            const SizedBox(height: 6),
          ],
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: color,
                ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}

/// Avatar circular con imagen remota o iniciales.
final class UserAvatar extends StatelessWidget {
  const UserAvatar({
    required this.initials,
    this.imageUrl,
    this.size = AppSizes.avatarMd,
    this.background,
    this.foreground,
    super.key,
  });

  final String initials;
  final String? imageUrl;
  final double size;
  final Color? background;
  final Color? foreground;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);
    final String? url = imageUrl;
    final Widget fallback = Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: AppColors.brandGradient,
        shape: BoxShape.circle,
        color: background,
      ),
      child: Text(
        initials,
        style: TextStyle(
          color: foreground ?? palette.onBrand,
          fontWeight: FontWeight.w900,
          fontSize: size * 0.36,
        ),
      ),
    );
    if (url == null || url.isEmpty) return fallback;
    return ClipOval(
      child: Image.network(
        url,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => fallback,
        loadingBuilder: (
          BuildContext context,
          Widget child,
          ImageChunkEvent? progress,
        ) =>
            progress == null
                ? child
                : SizedBox(
                    width: size,
                    height: size,
                    child: ShimmerBox(
                      height: size,
                      width: size,
                      radius: size / 2,
                    ),
                  ),
      ),
    );
  }
}

/// Barra inferior fija con acciones (formularios y detalles).
final class BottomActionBar extends StatelessWidget {
  const BottomActionBar({
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(
      AppSpacing.xl,
      AppSpacing.sm,
      AppSpacing.xl,
      AppSpacing.lg,
    ),
    super.key,
  });

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);
    return Container(
      decoration: BoxDecoration(
        color: palette.surface,
        border: Border(top: BorderSide(color: palette.divider)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}

/// Chip seleccionable usado en filtros (mapa, categorías, promos).
final class FilterChipRow extends StatelessWidget {
  const FilterChipRow({
    required this.options,
    required this.selected,
    required this.onSelected,
    this.leading,
    super.key,
  });

  final List<String> options;
  final String? selected;
  final ValueChanged<String?> onSelected;
  final Widget? leading;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 40,
        child: ListView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          children: <Widget>[
            if (leading != null) ...<Widget>[
              leading!,
              const SizedBox(width: AppSpacing.sm),
            ],
            ...options.map(
              (String option) => Padding(
                padding: const EdgeInsets.only(right: AppSpacing.sm),
                child: ChoiceChip(
                  label: Text(option),
                  selected: selected == option,
                  onSelected: (bool value) =>
                      onSelected(value ? option : null),
                ),
              ),
            ),
          ],
        ),
      );
}
