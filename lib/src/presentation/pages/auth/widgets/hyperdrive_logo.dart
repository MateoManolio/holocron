import 'package:flutter/material.dart';

class HyperdriveLogo extends StatelessWidget {
  const HyperdriveLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            const Color(0xFF6B4FFF).withValues(alpha: .3),
            const Color(0xFF6B4FFF).withValues(alpha: .1),
            Colors.transparent,
          ],
        ),
        border: Border.all(color: const Color(0xFF6B4FFF), width: 2),
      ),
      child: const Icon(
        Icons.rocket_launch,
        color: Color(0xFF6B4FFF),
        size: 40,
      ),
    );
  }
}
