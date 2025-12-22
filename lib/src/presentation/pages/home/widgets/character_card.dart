import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../config/theme/app_theme.dart';

class CharacterCard extends StatefulWidget {
  final String name;
  final String imagePath;
  final bool isFavorite;
  final VoidCallback? onTap;

  const CharacterCard({
    super.key,
    required this.name,
    required this.imagePath,
    this.isFavorite = false,
    this.onTap,
  });

  @override
  State<CharacterCard> createState() => _CharacterCardState();
}

class _CharacterCardState extends State<CharacterCard>
    with TickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _controller;
  late AnimationController _favoriteController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _favoriteController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void didUpdateWidget(CharacterCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFavorite && !oldWidget.isFavorite) {
      _favoriteController.forward();
    } else if (!widget.isFavorite && oldWidget.isFavorite) {
      _favoriteController.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _favoriteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: MouseRegion(
        onEnter: (_) {
          setState(() => _isHovered = true);
          _controller.forward();
        },
        onExit: (_) {
          setState(() => _isHovered = false);
          _controller.reverse();
        },
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: AnimatedBuilder(
            animation: _favoriteController,
            builder: (context, child) {
              return CustomPaint(
                foregroundPainter: BorderSpillPainter(
                  progress: _favoriteController.value,
                  color: AppTheme.imperialYellow,
                  borderRadius: 16.0,
                  strokeWidth: 2.5,
                ),
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: AppTheme.cardBackground,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _isHovered
                          ? AppTheme.holoBlue.withOpacity(0.5)
                          : AppTheme.darkGray.withOpacity(0.3),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: widget.isFavorite
                            ? AppTheme.imperialYellow
                            : _isHovered
                            ? AppTheme.holoBlue.withOpacity(0.2)
                            : Colors.black.withOpacity(0.3),
                        blurRadius: _isHovered ? 15 : 8,
                        spreadRadius: _isHovered ? 1 : 0,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      children: [
                        // Character image
                        Column(
                          children: [
                            AspectRatio(
                              aspectRatio: 1,
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppTheme.darkGray.withOpacity(0.3),
                                      AppTheme.cardBackground,
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                                child: Image.network(
                                  widget.imagePath,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Center(
                                      child: Icon(
                                        Icons.person,
                                        size: 60,
                                        color: AppTheme.lightGray.withOpacity(
                                          0.3,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            // Character name
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppTheme.cardBackground,
                                      AppTheme.darkGray.withOpacity(0.8),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    widget.name,
                                    style: AppTheme.heading3.copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Favorite button
                        Positioned(
                          top: 12,
                          right: 12,
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: AppTheme.cardBackground.withOpacity(0.9),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: widget.isFavorite
                                    ? AppTheme.imperialYellow
                                    : AppTheme.lightGray.withOpacity(0.3),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: widget.isFavorite
                                      ? AppTheme.imperialYellow.withOpacity(0.3)
                                      : Colors.black.withOpacity(0.2),
                                  blurRadius: 8,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Icon(
                              widget.isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: widget.isFavorite
                                  ? AppTheme.imperialYellow
                                  : AppTheme.lightGray.withOpacity(0.6),
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class BorderSpillPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double borderRadius;
  final double strokeWidth;

  BorderSpillPainter({
    required this.progress,
    required this.color,
    required this.borderRadius,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final double halfStroke = strokeWidth / 2;
    final double inset = halfStroke;

    final path = Path();
    path.moveTo(size.width - borderRadius, inset);
    path.arcTo(
      Rect.fromLTWH(
        size.width - 2 * borderRadius + inset,
        inset,
        2 * borderRadius - 2 * inset,
        2 * borderRadius - 2 * inset,
      ),
      -math.pi / 2,
      math.pi / 2,
      false,
    );
    path.lineTo(size.width - inset, size.height - borderRadius);
    path.arcTo(
      Rect.fromLTWH(
        size.width - 2 * borderRadius + inset,
        size.height - 2 * borderRadius + inset,
        2 * borderRadius - 2 * inset,
        2 * borderRadius - 2 * inset,
      ),
      0,
      math.pi / 2,
      false,
    );
    path.lineTo(borderRadius, size.height - inset);
    path.arcTo(
      Rect.fromLTWH(
        inset,
        size.height - 2 * borderRadius + inset,
        2 * borderRadius - 2 * inset,
        2 * borderRadius - 2 * inset,
      ),
      math.pi / 2,
      math.pi / 2,
      false,
    );
    path.lineTo(inset, borderRadius);
    path.arcTo(
      Rect.fromLTWH(
        inset,
        inset,
        2 * borderRadius - 2 * inset,
        2 * borderRadius - 2 * inset,
      ),
      math.pi,
      math.pi / 2,
      false,
    );
    path.lineTo(size.width - borderRadius, inset);

    final pathMetrics = path.computeMetrics().first;
    final totalLength = pathMetrics.length;
    final extractLength = progress * totalLength;

    if (progress < 1.0) {
      canvas.drawPath(pathMetrics.extractPath(0, extractLength), paint);
    } else {
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant BorderSpillPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}

