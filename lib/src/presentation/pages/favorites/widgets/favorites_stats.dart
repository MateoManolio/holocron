import 'package:flutter/material.dart';
import 'stat_card.dart';

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
