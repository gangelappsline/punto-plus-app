import 'package:flutter/material.dart';

import '../theme/app_palette.dart';
import '../theme/app_spacing.dart';

/// Placeholder animado que se muestra mientras cargan los datos.
final class ShimmerBox extends StatefulWidget {
  const ShimmerBox({
    this.height = 16,
    this.width = double.infinity,
    this.radius = AppRadius.md,
    super.key,
  });

  final double height;
  final double width;
  final double radius;

  @override
  State<ShimmerBox> createState() => _ShimmerBoxState();
}

final class _ShimmerBoxState extends State<ShimmerBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, _) {
        final double t = _controller.value;
        return Container(
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.radius),
            gradient: LinearGradient(
              begin: Alignment(-1 + t * 2, -0.3),
              end: Alignment(0.2 + t * 2, 0.3),
              colors: <Color>[
                palette.skeletonBase,
                palette.skeletonHighlight,
                palette.skeletonBase,
              ],
              stops: const <double>[0, 0.5, 1],
            ),
          ),
        );
      },
    );
  }
}

/// Esqueleto de una tarjeta de fidelidad (listas de tarjetas).
final class CardSkeleton extends StatelessWidget {
  const CardSkeleton({this.height = 132, super.key});

  final double height;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.md),
        child: ShimmerBox(height: height, radius: AppRadius.lg),
      );
}

/// Esqueleto de lista con varios elementos.
final class ListSkeleton extends StatelessWidget {
  const ListSkeleton({this.items = 4, this.height = 84, super.key});

  final int items;
  final double height;

  @override
  Widget build(BuildContext context) => Column(
        children: List<Widget>.generate(
          items,
          (int index) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Row(
              children: <Widget>[
                ShimmerBox(
                  height: height * 0.6,
                  width: height * 0.6,
                  radius: AppRadius.md,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const ShimmerBox(height: 15, width: 180),
                      const SizedBox(height: AppSpacing.sm),
                      ShimmerBox(
                        height: 12,
                        width: index.isEven ? 240 : 140,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

/// Esqueleto de panel de métricas (dashboard del negocio).
final class StatsSkeleton extends StatelessWidget {
  const StatsSkeleton({this.items = 4, super.key});

  final int items;

  @override
  Widget build(BuildContext context) => GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: AppSpacing.md,
        crossAxisSpacing: AppSpacing.md,
        childAspectRatio: 2.1,
        children: List<Widget>.generate(
          items,
          (int index) => const ShimmerBox(
            height: double.infinity,
            radius: AppRadius.lg,
          ),
        ),
      );
}
