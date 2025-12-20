import 'package:flutter/material.dart';

import '../../config/theme/app_theme.dart';

/// Fondo animado de estrellas
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
      duration: const Duration(seconds: 20),
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

/// Painter para el efecto de estrellas
class _StarfieldPainter extends CustomPainter {
  final double animation;

  _StarfieldPainter(this.animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.6)
      ..strokeWidth = 1.5;

    // Generar estrellas pseudo-aleatorias
    for (int i = 0; i < 50; i++) {
      final x = (i * 37.5) % size.width;
      final y = ((i * 67.3 + animation * 100) % size.height);
      final opacity = ((i * 0.1) % 1.0) * 0.5 + 0.2;

      paint.color = Colors.white.withValues(alpha: opacity);
      canvas.drawCircle(Offset(x, y), 1.5, paint);

      // Algunas estrellas con brillo
      if (i % 7 == 0) {
        paint.color = AppTheme.holoBlue.withValues(alpha: opacity * 0.5);
        canvas.drawCircle(Offset(x, y), 2.5, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _StarfieldPainter oldDelegate) {
    return oldDelegate.animation != animation;
  }
}
