import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

enum SocialButtonType { google, apple }

final class SocialButton extends StatelessWidget {
  const SocialButton({
    required this.type,
    required this.onPressed,
    super.key,
  });

  final SocialButtonType type;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 49,
        child: Material(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(27),
            side: const BorderSide(color: Color(0xFFE9ECEE)),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(27),
            onTap: onPressed,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (type == SocialButtonType.google)
                  const SizedBox.square(
                    dimension: 20,
                    child: CustomPaint(painter: _GooglePainter()),
                  )
                else
                  const Icon(Icons.apple, size: 21, color: Colors.black),
                const SizedBox(width: 11),
                Text(
                  type == SocialButtonType.google ? 'Google' : 'Apple ID',
                  style: const TextStyle(
                    color: AppColors.text,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

final class _GooglePainter extends CustomPainter {
  const _GooglePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final rect = Rect.fromCircle(center: center, radius: size.width * 0.39);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.2
      ..strokeCap = StrokeCap.butt;

    void arc(Color color, double start, double sweep) {
      paint.color = color;
      canvas.drawArc(rect, start, sweep, false, paint);
    }

    arc(const Color(0xFF4285F4), -math.pi * 0.2, math.pi * 0.72);
    arc(const Color(0xFF34A853), math.pi * 0.52, math.pi * 0.48);
    arc(const Color(0xFFFBBC05), math.pi, math.pi * 0.45);
    arc(const Color(0xFFEA4335), math.pi * 1.45, math.pi * 0.35);

    paint
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromLTWH(
        center.dx,
        center.dy - size.height * 0.08,
        size.width * 0.42,
        size.height * 0.17,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
