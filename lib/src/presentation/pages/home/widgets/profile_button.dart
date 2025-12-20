import 'package:flutter/material.dart';

import '../../../../config/theme/app_theme.dart';

class ProfileButton extends StatefulWidget {
  const ProfileButton({super.key});

  @override
  State<ProfileButton> createState() => _ProfileButtonState();
}

class _ProfileButtonState extends State<ProfileButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: () {
        // Acción de perfil
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: AppTheme.cardBackground,
            shape: BoxShape.circle,
            border: Border.all(
              color: AppTheme.holoBlue.withValues(alpha: .5),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.holoBlue.withValues(alpha: .2),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
          child: const Icon(
            Icons.person_outline,
            color: AppTheme.holoBlue,
            size: 24,
          ),
        ),
      ),
    );
  }
}
