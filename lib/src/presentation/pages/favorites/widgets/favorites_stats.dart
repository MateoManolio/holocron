import 'package:flutter/material.dart';
import '../../../../config/theme/app_theme.dart';

class FavoritesStats extends StatelessWidget {
  final int count;

  const FavoritesStats({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: isMobile
          ? Column(
              children: [
                StatCard(
                  title: 'TOTAL ENTRIES',
                  value: count.toString(),
                  subtitle: 'Secured in local archives',
                  icon: Icons.grid_view_rounded,
                ),
                const SizedBox(height: 12),
                const StatCard(
                  title: 'SYNC STATUS',
                  value: 'ACTIVE',
                  valueSuffix: 'GST',
                  subtitle: 'Database connection stable',
                  icon: Icons.restore_rounded,
                ),
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: StatCard(
                    title: 'TOTAL ENTRIES',
                    value: count.toString(),
                    subtitle: 'Secured in local archives',
                    icon: Icons.grid_view_rounded,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: StatCard(
                    title: 'SYNC STATUS',
                    value: 'ACTIVE',
                    valueSuffix: 'GST',
                    subtitle: 'Database connection stable',
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
        color: AppTheme.cardBackground.withOpacity(0.5),
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
                                color: Colors.white.withOpacity(0.5),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Icon(
                            icon,
                            size: 16,
                            color: AppTheme.terminalGreen.withOpacity(0.5),
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
                                  color: Colors.white.withOpacity(0.3),
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
                              ? AppTheme.terminalGreen.withOpacity(0.7)
                              : Colors.white.withOpacity(0.3),
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

