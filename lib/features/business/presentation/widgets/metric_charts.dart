import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../data/models/business_dashboard.dart';

/// Gráfica de barras de sellos por periodo (dibujada a mano).
///
/// Sustituye a `fl_chart` sin plugins: la API (`points`, `label`) se mantiene
/// para poder cambiar de implementación sin tocar las pantallas.
final class MetricBarChart extends StatelessWidget {
  const MetricBarChart({
    required this.points,
    this.height = 180,
    this.tone,
    super.key,
  });

  final List<MetricPoint> points;
  final double height;
  final Color? tone;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;
    if (points.isEmpty) {
      return SizedBox(
        height: height,
        child: Center(
          child: Text(
            context.l10n.manageDashboardChartEmpty,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      );
    }
    final int maxValue = points
        .map((MetricPoint point) => point.value)
        .reduce((int a, int b) => math.max(a, b));
    return SizedBox(
      height: height,
      child: CustomPaint(
        painter: _BarChartPainter(
          points: points,
          maxValue: math.max(1, maxValue),
          tone: tone ?? palette.brand,
          palette: palette,
        ),
        size: Size.infinite,
      ),
    );
  }
}

final class _BarChartPainter extends CustomPainter {
  const _BarChartPainter({
    required this.points,
    required this.maxValue,
    required this.tone,
    required this.palette,
  });

  final List<MetricPoint> points;
  final int maxValue;
  final Color tone;
  final AppPalette palette;

  @override
  void paint(Canvas canvas, Size size) {
    const double bottom = 26;
    const double left = 4;
    final double chartHeight = size.height - bottom;
    final double slot = (size.width - left) / points.length;
    final double barWidth = math.max(6, slot * 0.55);

    final Paint grid = Paint()
      ..color = palette.divider
      ..strokeWidth = 1;
    for (int i = 0; i <= 4; i++) {
      final double y = chartHeight - chartHeight * (i / 4);
      canvas.drawLine(Offset(left, y), Offset(size.width, y), grid);
      _text(
        canvas,
        '$maxValue',
        Offset(left, y - 14),
        palette.textFaint,
        9,
      );
    }

    for (int index = 0; index < points.length; index++) {
      final MetricPoint point = points[index];
      final double ratio = point.value / maxValue;
      final double barHeight = math.max(3, chartHeight * ratio);
      final Rect rect = Rect.fromLTWH(
        left + slot * index + (slot - barWidth) / 2,
        chartHeight - barHeight,
        barWidth,
        barHeight,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(6)),
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: <Color>[tone, tone.withValues(alpha: 0.55)],
          ).createShader(rect),
      );
      if (point.value > 0) {
        _text(
          canvas,
          '${point.value}',
          Offset(rect.center.dx - 7, rect.top - 14),
          palette.textMuted,
          9.5,
        );
      }
      _text(
        canvas,
        point.label ?? _short(point.date),
        Offset(rect.center.dx - 10, chartHeight + 6),
        palette.textFaint,
        9.5,
      );
    }
  }

  String _short(DateTime date) => '${date.day}/${date.month}';

  void _text(
    Canvas canvas,
    String value,
    Offset offset,
    Color color,
    double size,
  ) {
    TextPainter(
      text: TextSpan(
        text: value,
        style: TextStyle(
          color: color,
          fontSize: size,
          fontWeight: FontWeight.w700,
        ),
      ),
      textDirection: TextDirection.ltr,
    )
      ..layout()
      ..paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant _BarChartPainter oldDelegate) =>
      oldDelegate.points != points || oldDelegate.tone != tone;
}

/// Gráfica de línea suave para tendencias (reservada para rangos largos).
final class MetricLineChart extends StatelessWidget {
  const MetricLineChart({
    required this.points,
    this.height = 160,
    this.tone,
    super.key,
  });

  final List<MetricPoint> points;
  final double height;
  final Color? tone;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;
    if (points.isEmpty) {
      return const SizedBox.shrink();
    }
    return SizedBox(
      height: height,
      child: CustomPaint(
        painter: _LineChartPainter(
          points: points,
          tone: tone ?? palette.accent,
          palette: palette,
        ),
        size: Size.infinite,
      ),
    );
  }
}

final class _LineChartPainter extends CustomPainter {
  const _LineChartPainter({
    required this.points,
    required this.tone,
    required this.palette,
  });

  final List<MetricPoint> points;
  final Color tone;
  final AppPalette palette;

  @override
  void paint(Canvas canvas, Size size) {
    final int maxValue = math.max(
      1,
      points
          .map((MetricPoint point) => point.value)
          .reduce((int a, int b) => math.max(a, b)),
    );
    final double step = points.length <= 1 ? size.width : size.width / (points.length - 1);
    final Path path = Path();
    for (int index = 0; index < points.length; index++) {
      final double x = step * index;
      final double y = size.height -
          (points[index].value / maxValue) * (size.height - 12) -
          6;
      if (index == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = tone
        ..strokeWidth = 2.6
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
    for (int index = 0; index < points.length; index++) {
      final double x = step * index;
      final double y = size.height -
          (points[index].value / maxValue) * (size.height - 12) -
          6;
      canvas.drawCircle(x, y, 3.4, Paint()..color = tone);
    }
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter oldDelegate) =>
      oldDelegate.points != points || oldDelegate.tone != tone;
}

/// Selector de rango del dashboard (semana o mes).
final class ChartRangeSelector extends StatelessWidget {
  const ChartRangeSelector({
    required this.isMonth,
    required this.onChanged,
    super.key,
  });

  final bool isMonth;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: palette.segmented,
        borderRadius: AppRadius.allPill,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _Chip(
            label: context.l10n.manageDashboardChartRangeWeek,
            selected: !isMonth,
            onTap: () => onChanged(false),
          ),
          _Chip(
            label: context.l10n.manageDashboardChartRangeMonth,
            selected: isMonth,
            onTap: () => onChanged(true),
          ),
        ],
      ),
    );
  }
}

final class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? palette.surface : Colors.transparent,
          borderRadius: AppRadius.allPill,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w900,
            color: selected ? palette.brand : palette.textMuted,
          ),
        ),
      ),
    );
  }
}
