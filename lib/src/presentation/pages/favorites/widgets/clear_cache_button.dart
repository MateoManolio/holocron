import 'package:flutter/material.dart';
import '../../../../config/theme/app_theme.dart';

class ClearCacheButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const ClearCacheButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.disabled_by_default_rounded,
              color: Colors.white.withOpacity(0.7),
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              'Clear Cache',
              style: AppTheme.bodyText.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

