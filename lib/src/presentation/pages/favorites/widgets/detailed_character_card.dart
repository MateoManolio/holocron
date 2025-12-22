import 'package:flutter/material.dart';
import '../../../../config/theme/app_theme.dart';
import 'delete_confirmation_popover.dart';

class DetailedCharacterCard extends StatelessWidget {
  final String name;
  final String imagePath;
  final String species;
  final String gender;
  final String homeworld;
  final String birthYear;
  final int? height;
  final String? eyeColor;
  final String? mass; // Added Mass stat instead
  final List<String> affiliations;
  final VoidCallback? onDelete;

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

  void _showDeleteConfirmation(BuildContext context, GlobalKey buttonKey) {
    final RenderBox? renderBox =
        buttonKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;
    final screenWidth = MediaQuery.of(context).size.width;
    late OverlayEntry overlayEntry;

    // Popover width is fixed at 260. Margin 4.
    const popoverWidth = 260.0;

    // Calculate horizontal position
    double left;
    if (offset.dx > screenWidth / 2) {
      // Show to the left if button is on the right half of the screen
      left = offset.dx - popoverWidth + size.width;
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
            top: offset.dy + 70, // Moved down to avoid covering eyes/face
            child: DeleteConfirmationPopover(
              characterName: name,
              onDelete: () {
                onDelete?.call();
                overlayEntry.remove();
              },
              onClose: () => overlayEntry.remove(),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(overlayEntry);
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey deleteButtonKey = GlobalKey();
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppTheme.cardBackground.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.imperialYellow.withValues(
            alpha: 0.5,
          ), // Vibrant yellow border
          width: 1.5, // Thicker border
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.imperialYellow.withValues(
              alpha: 0.2,
            ), // Noticeable glow
            blurRadius: 15,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section
          AspectRatio(
            aspectRatio: 1,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
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
                            color: AppTheme.lightGray.withValues(alpha: 0.3),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Gradient overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        AppTheme.cardBackground.withValues(alpha: 0.8),
                      ],
                    ),
                  ),
                ),

                // Delete button
                Positioned(
                  top: 8,
                  right: 8,
                  child: Material(
                    key: deleteButtonKey,
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () =>
                          _showDeleteConfirmation(context, deleteButtonKey),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Colors.black26,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close_rounded,
                          color: Colors.white.withValues(alpha: 0.6),
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content Section
          Flexible(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(12),
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
                          _Tag(label: species.toUpperCase(), isPrimary: true),
                          _Tag(label: gender.toUpperCase()),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Divider(color: Colors.white10, height: 1),
                      const SizedBox(height: 12),

                      // Metadata grid
                      _MetadataGrid(
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
                            color: Colors.white.withValues(alpha: 0.3),
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
                                (a) =>
                                    _Tag(label: a.toUpperCase(), fontSize: 8),
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

class _MetadataGrid extends StatelessWidget {
  final String homeworld;
  final String birthYear;
  final int? height;
  final String? eyeColor;
  final String? mass;

  const _MetadataGrid({
    required this.homeworld,
    required this.birthYear,
    this.height,
    this.eyeColor,
    this.mass,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _MetadataRow(label: 'HOMEWORLD', value: homeworld),
            ),
            Expanded(
              child: _MetadataRow(label: 'BIRTH YEAR', value: birthYear),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _MetadataRow(
                label: 'HEIGHT',
                value: height != null ? '${height}cm' : 'UNKNOWN',
              ),
            ),
            Expanded(
              child: _MetadataRow(
                label: 'EYE COLOR',
                value: eyeColor?.toUpperCase() ?? 'UNKNOWN',
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _MetadataRow(
                label: 'MASS',
                value: mass != null ? '${mass}kg' : 'UNKNOWN',
              ),
            ),
            const Expanded(child: SizedBox()),
          ],
        ),
      ],
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final bool isPrimary;
  final double fontSize;

  const _Tag({required this.label, this.isPrimary = false, this.fontSize = 10});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      decoration: BoxDecoration(
        color: isPrimary
            ? AppTheme.terminalGreen.withValues(alpha: 0.1)
            : Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: isPrimary
              ? AppTheme.terminalGreen.withValues(alpha: 0.3)
              : Colors.white.withValues(alpha: 0.1),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isPrimary ? AppTheme.terminalGreen : Colors.white60,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _MetadataRow extends StatelessWidget {
  final String label;
  final String value;

  const _MetadataRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.3),
            fontSize: 8,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 1),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
