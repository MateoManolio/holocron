import 'dart:math';
import 'package:flutter/material.dart';

import '../../config/theme/app_theme.dart';

class StarfieldBackground extends StatefulWidget {
  const StarfieldBackground({super.key});

  @override
  State<StarfieldBackground> createState() => StarfieldBackgroundState();
}

class StarfieldBackgroundState extends State<StarfieldBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 60),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _StarfieldPainter(_controller.value),
          size: Size.infinite,
        );
      },
    );
  }
}

class _StarfieldPainter extends CustomPainter {
  final double animation;

  _StarfieldPainter(this.animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: .6)
      ..strokeWidth = 1.5;

    final random = Random(42);
    const int starCount = 80;

    for (int i = 0; i < starCount; i++) {
      // Generate consistent random values using the seed
      final x = random.nextDouble() * size.width;
      final rawY = random.nextDouble() * size.height;
      // Vertical displacement depends on animation for the movement effect
      final y = (rawY + animation * size.height) % size.height;

      final baseOpacity = random.nextDouble() * 0.6 + 0.2;
      final starRadius = random.nextDouble() * 1.2 + 0.3;

      paint.color = Colors.white.withValues(alpha: baseOpacity);
      canvas.drawCircle(Offset(x, y), starRadius, paint);

      // Some stars have a special glow effect
      if (random.nextDouble() > 0.85) {
        paint.color = AppTheme.holoBlue.withValues(alpha: baseOpacity * 0.4);
        canvas.drawCircle(Offset(x, y), starRadius * 2.5, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _StarfieldPainter oldDelegate) {
    return oldDelegate.animation != animation;
  }
}
