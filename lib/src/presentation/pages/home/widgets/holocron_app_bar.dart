import 'package:flutter/material.dart';
import 'package:holocron/src/config/theme/app_theme.dart';

import 'app_bar_options.dart';
import 'profile_button.dart';

class HolocronAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HolocronAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(-20 * (1 - value), 0),
                    child: child,
                  ),
                );
              },
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppTheme.imperialYellow, AppTheme.holoBlue],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.imperialYellow.withValues(alpha: .3),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.auto_awesome,
                      color: AppTheme.spaceBlack,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'HOLOCRON',
                    style: AppTheme.heading2.copyWith(
                      color: AppTheme.imperialYellow,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(width: 20),

                  const AppBarOptions(),
                ],
              ),
            ),

            const ProfileButton(),
          ],
        ),
      ),
    );
  }
}
