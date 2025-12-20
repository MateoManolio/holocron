import 'package:flutter/material.dart';
import '../../../../config/theme/app_theme.dart';

class FavoritesStats extends StatelessWidget {
  const FavoritesStats({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: StatCard(
              title: 'TOTAL ENTRIES',
              value: '12',
              subtitle: '+2 added this session',
              icon: Icons.grid_view_rounded,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: StatCard(
              title: 'LAST UPDATED',
              value: '12:45',
              valueSuffix: 'GST',
              subtitle: 'Sync status: Active',
              icon: Icons.restore_rounded,
            ),
          ),
        ],
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String? valueSuffix;
  final String subtitle;
  final IconData icon;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    this.valueSuffix,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardBackground.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(width: 4, color: AppTheme.terminalGreen),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              title,
                              style: AppTheme.bodyText.copyWith(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.0,
                                color: Colors.white.withValues(alpha: 0.5),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Icon(
                            icon,
                            size: 16,
                            color: AppTheme.terminalGreen.withValues(
                              alpha: 0.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            value,
                            style: AppTheme.heading1.copyWith(
                              fontSize: 28,
                              color: Colors.white,
                            ),
                          ),
                          if (valueSuffix != null) ...[
                            const SizedBox(width: 4),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Text(
                                valueSuffix!,
                                style: AppTheme.bodyText.copyWith(
                                  fontSize: 14,
                                  color: Colors.white.withValues(alpha: 0.3),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        subtitle,
                        style: AppTheme.bodyText.copyWith(
                          fontSize: 12,
                          color: title == 'TOTAL ENTRIES'
                              ? AppTheme.terminalGreen.withValues(alpha: 0.7)
                              : Colors.white.withValues(alpha: 0.3),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
