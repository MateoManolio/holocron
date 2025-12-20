import 'package:flutter/material.dart';
import '../../../../config/theme/app_theme.dart';
import 'clear_cache_button.dart';

class FavoritesHeader extends StatelessWidget {
  const FavoritesHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.folder_open_rounded,
                color: AppTheme.terminalGreen,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'USER DATABANK // SECTOR 7',
                style: AppTheme.bodyText.copyWith(
                  color: AppTheme.terminalGreen,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PERSONAL HOLOCRON',
                      style: AppTheme.heading1.copyWith(
                        color: Colors.white,
                        fontSize: 32,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Access your secured collection of identified lifeforms. Data is encrypted and stored locally.',
                      style: AppTheme.bodyText.copyWith(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              const ClearCacheButton(),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(color: Colors.white10, height: 1),
        ],
      ),
    );
  }
}
