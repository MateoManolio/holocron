import 'package:flutter/material.dart';
import '../../../../config/theme/app_theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../presentation/bloc/favorites/favorites_bloc.dart';
import '../../../../presentation/bloc/favorites/favorites_event.dart';
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
                        color: Colors.white.withValues(alpha: .5),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 32),
              ClearCacheButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: AppTheme.cardBackground,
                      title: Text(
                        'Clear Database',
                        style: AppTheme.heading1.copyWith(fontSize: 20),
                      ),
                      content: const Text(
                        'This will delete all saved characters from your local database. This action cannot be undone.',
                        style: AppTheme.bodyText,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            context.read<FavoritesBloc>().add(
                              ClearAllFavorites(),
                            );
                          },
                          child: const Text(
                            'Clear All',
                            style: TextStyle(color: Colors.redAccent),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(color: Colors.white10, height: 1),
        ],
      ),
    );
  }
}
