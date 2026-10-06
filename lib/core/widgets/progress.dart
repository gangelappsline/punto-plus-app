import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_palette.dart';
import '../theme/app_spacing.dart';

/// Barra de progreso animada (sellos acumulados).
final class AnimatedProgressBar extends StatelessWidget {
  const AnimatedProgressBar({
    required this.value,
    this.height = 10,
    this.tone,
    this.trackColor,
    super.key,
  });

  /// Progreso entre 0 y 1.
  final double value;
  final double height;
  final Color? tone;
  final Color? trackColor;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;
    final double clamped = value.clamp(0, 1);
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: clamped),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      builder: (BuildContext context, double animated, _) => ClipRRect(
        borderRadius: BorderRadius.circular(height),
        child: LinearProgressIndicator(
          value: animated,
          minHeight: height,
          backgroundColor: trackColor ?? palette.segmented,
          valueColor: AlwaysStoppedAnimation<Color>(tone ?? palette.brand),
        ),
      ),
    );
  }
}

/// Cuadrícula de sellos: obtenidos a color, pendientes en gris.
final class StampsGrid extends StatelessWidget {
  const StampsGrid({
    required this.stampsCount,
    required this.requiredStamps,
    this.columns = 5,
    this.stampSize = 44,
    this.icon = Icons.star_rounded,
    this.tone,
    this.pendingTone,
    this.animate = true,
    super.key,
  });

  final int stampsCount;
  final int requiredStamps;
  final int columns;
  final double stampSize;
  final IconData icon;
  final Color? tone;
  final Color? pendingTone;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;
    final int total = math.max(requiredStamps, stampsCount);
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final int resolvedColumns = math.max(1, columns);
        final double spacing = AppSpacing.sm;
        final double cell =
            (constraints.maxWidth - spacing * (resolvedColumns - 1)) /
                resolvedColumns;
        final double size = math.min(stampSize, cell);
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: List<Widget>.generate(
            total,
            (int index) => StampCell(
              filled: index < stampsCount,
              size: size,
              icon: icon,
              tone: tone,
              pendingTone: pendingTone,
              animate: animate,
              index: index,
            ),
          ),
        );
      },
    );
  }
}

/// Un sello individual con animación al iluminarse.
final class StampCell extends StatefulWidget {
  const StampCell({
    required this.filled,
    required this.size,
    this.icon = Icons.star_rounded,
    this.tone,
    this.pendingTone,
    this.animate = true,
    this.index = 0,
    super.key,
  });

  final bool filled;
  final double size;
  final IconData icon;
  final Color? tone;
  final Color? pendingTone;
  final bool animate;
  final int index;

  @override
  State<StampCell> createState() => _StampCellState();
}

final class _StampCellState extends State<StampCell>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 320),
  );

  @override
  void initState() {
    super.initState();
    if (widget.filled) {
      if (widget.animate) {
        Future<void>.delayed(
          Duration(milliseconds: 60 * widget.index.clamp(0, 12)),
          () {
            if (mounted) _controller.forward();
          },
        );
      } else {
        _controller.value = 1;
      }
    }
  }

  @override
  void didUpdateWidget(covariant StampCell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.filled && !oldWidget.filled) {
      _controller.forward(from: 0);
    } else if (!widget.filled && oldWidget.filled) {
      _controller.value = 0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;
    final Color filledTone = widget.tone ?? palette.stampEarned;
    final Color pending = widget.pendingTone ?? palette.stampPending;
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, _) {
        final double scale = widget.filled
            ? 0.85 + 0.15 * Curves.easeOutBack.transform(
                _controller.value.clamp(0, 1),
              )
            : 1;
        return Transform.scale(
          scale: scale,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: widget.filled ? filledTone : pending,
              shape: BoxShape.circle,
              boxShadow: widget.filled
                  ? <BoxShadow>[
                      BoxShadow(
                        color: filledTone.withValues(alpha: 0.32),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : null,
            ),
            child: Icon(
              widget.icon,
              size: widget.size * 0.5,
              color: widget.filled
                  ? palette.onBrand
                  : palette.textFaint.withValues(alpha: 0.7),
            ),
          ),
        );
      },
    );
  }
}

/// Insignia animada que celebra una tarjeta completa.
final class CompletionBadge extends StatefulWidget {
  const CompletionBadge({required this.label, this.tone, super.key});

  final String label;
  final Color? tone;

  @override
  State<CompletionBadge> createState() => _CompletionBadgeState();
}

final class _CompletionBadgeState extends State<CompletionBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;
    final Color tone = widget.tone ?? palette.accent;
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, _) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[
              tone.withValues(alpha: 0.85),
              tone.withValues(alpha: 0.55 + 0.35 * _controller.value),
            ],
          ),
          borderRadius: AppRadius.allPill,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.emoji_events_rounded, size: 14, color: palette.onBrand),
            const SizedBox(width: 5),
            Text(
              widget.label,
              style: TextStyle(
                color: palette.onBrand,
                fontSize: 11.5,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Indicador de pasos para formularios multi-paso (Stepper).
final class StepDots extends StatelessWidget {
  const StepDots({
    required this.count,
    required this.currentIndex,
    this.labels,
    super.key,
  });

  final int count;
  final int currentIndex;
  final List<String>? labels;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;
    return Row(
      children: List<Widget>.generate(count, (int index) {
        final bool done = index <= currentIndex;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: index == count - 1 ? 0 : 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  height: 5,
                  decoration: BoxDecoration(
                    color: done ? palette.brand : palette.segmented,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                if (labels != null && index < labels!.length) ...<Widget>[
                  const SizedBox(height: 4),
                  Text(
                    labels![index],
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: done ? palette.brand : palette.textFaint,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      }),
    );
  }
}
