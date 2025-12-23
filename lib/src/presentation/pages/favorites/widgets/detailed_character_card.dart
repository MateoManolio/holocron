import 'package:flutter/material.dart';
import '../../../../config/theme/app_theme.dart';
import 'delete_confirmation_popover.dart';
import 'metadata_grid.dart';
import 'status_tag.dart';

class DetailedCharacterCard extends StatelessWidget {
  final String name;
  final String imagePath;
  final String species;
  final String gender;
  final String homeworld;
  final String birthYear;
  final int? height;
  final String? eyeColor;
  final String? mass;
  final List<String> affiliations;
  final VoidCallback? onDelete;

  static const double _cardBorderRadius = 12.0;
  static const double _cardBorderWidth = 1.5;
  static const double _popoverWidth = 260.0;
  static const double _popoverOffsetTop = 70.0;
  static const double _iconSize = 16.0;

  const DetailedCharacterCard({
    super.key,
    required this.name,
    required this.imagePath,
    required this.species,
    required this.gender,
    required this.homeworld,
    required this.birthYear,
    this.height,
    this.eyeColor,
    this.mass,
    this.affiliations = const [],
    this.onDelete,
  });

  void _showDeleteConfirmation(
    BuildContext context,
    BuildContext buttonContext,
  ) {
    final RenderBox? renderBox = buttonContext.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;
    final screenWidth = MediaQuery.of(context).size.width;
    late OverlayEntry overlayEntry;

    // Calculate horizontal position
    double left;
    if (offset.dx > screenWidth / 2) {
      // Show to the left if button is on the right half of the screen
      left = offset.dx - _popoverWidth + size.width;
    } else {
      // Show to the right if button is on the left half of the screen
      left = offset.dx;
    }

    overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Background dismisser
          GestureDetector(
            onTap: () => overlayEntry.remove(),
            behavior: HitTestBehavior.opaque,
            child: Container(color: Colors.transparent),
          ),
          Positioned(
            left: left,
            top: offset.dy + _popoverOffsetTop,
            child: DeleteConfirmationPopover(
              characterName: name,
              onDelete: () {
                onDelete?.call();
              },
              onClose: () {
                if (overlayEntry.mounted) {
                  overlayEntry.remove();
                }
              },
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(overlayEntry);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppTheme.cardBackground.withValues(alpha: .4),
        borderRadius: BorderRadius.circular(_cardBorderRadius),
        border: Border.all(
          color: AppTheme.imperialYellow.withValues(alpha: 0.5),
          width: _cardBorderWidth,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.imperialYellow.withValues(alpha: .2),
            blurRadius: 15,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(_cardBorderRadius),
                  ),
                  child: Image.network(
                    imagePath,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppTheme.darkGray,
                        child: Center(
                          child: Icon(
                            Icons.person,
                            size: 40,
                            color: AppTheme.lightGray.withValues(alpha: .3),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        AppTheme.cardBackground.withValues(alpha: .8),
                      ],
                    ),
                  ),
                ),

                Positioned(
                  top: 8,
                  right: 8,
                  child: Builder(
                    builder: (buttonContext) => Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () =>
                            _showDeleteConfirmation(context, buttonContext),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Colors.black26,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close_rounded,
                            color: Colors.white.withValues(alpha: .3),
                            size: _iconSize,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Flexible(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(_cardBorderRadius),
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name.toUpperCase(),
                        style: AppTheme.heading3.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.visible,
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: [
                          StatusTag(
                            label: species.toUpperCase(),
                            isPrimary: true,
                          ),
                          StatusTag(label: gender.toUpperCase()),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Divider(color: Colors.white10, height: 1),
                      const SizedBox(height: 12),

                      MetadataGrid(
                        homeworld: homeworld,
                        birthYear: birthYear,
                        height: height,
                        eyeColor: eyeColor,
                        mass: mass,
                      ),

                      if (affiliations.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Text(
                          'AFFILIATIONS',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: .3),
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: affiliations
                              .map(
                                (a) => StatusTag(
                                  label: a.toUpperCase(),
                                  fontSize: 8,
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
