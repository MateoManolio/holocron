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
  final ValueNotifier<bool> _isHovered = ValueNotifier<bool>(false);
  late AnimationController _controller;
  late AnimationController _favoriteController;
  late Animation<double> _scaleAnimation;

  static const int _animDurationMs = 150;
  static const int _favoriteAnimDurationMs = 500;
  static const double _initialScale = 1.0;
  static const double _hoverScale = 1.05;
  static const double _borderRadius = 16.0;
  static const double _strokeWidth = 2.5;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: _animDurationMs),
      vsync: this,
    );
    _favoriteController = AnimationController(
      duration: const Duration(milliseconds: _favoriteAnimDurationMs),
      vsync: this,
      value: widget.isFavorite ? 1.0 : 0.0,
    );
    _scaleAnimation = Tween<double>(
      begin: _initialScale,
      end: _hoverScale,
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
    _isHovered.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: MouseRegion(
        onEnter: (_) {
          _isHovered.value = true;
          _controller.forward();
        },
        onExit: (_) {
          _isHovered.value = false;
          _controller.reverse();
        },
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: ValueListenableBuilder<bool>(
            valueListenable: _isHovered,
            builder: (context, isHovered, child) {
              return AnimatedBuilder(
                animation: _favoriteController,
                builder: (context, child) {
                  return CustomPaint(
                    foregroundPainter: BorderSpillPainter(
                      progress: _favoriteController.value,
                      color: AppTheme.imperialYellow,
                      borderRadius: _borderRadius,
                      strokeWidth: _strokeWidth,
                    ),
                    child: Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: AppTheme.cardBackground,
                        borderRadius: BorderRadius.circular(_borderRadius),
                        border: Border.all(
                          color: isHovered
                              ? AppTheme.holoBlue.withValues(alpha: .5)
                              : AppTheme.darkGray.withValues(alpha: .3),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: widget.isFavorite
                                ? AppTheme.imperialYellow
                                : isHovered
                                ? AppTheme.holoBlue.withValues(alpha: .2)
                                : Colors.black.withValues(alpha: .3),
                            blurRadius: isHovered ? 15 : 8,
                            spreadRadius: isHovered ? 1 : 0,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(_borderRadius),
                        child: Stack(
                          children: [
                            Column(
                              children: [
                                AspectRatio(
                                  aspectRatio: 1,
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          AppTheme.darkGray.withValues(
                                            alpha: .3,
                                          ),
                                          AppTheme.cardBackground,
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                    ),
                                    child: Image.network(
                                      widget.imagePath,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Center(
                                              child: Icon(
                                                Icons.person,
                                                size: 60,
                                                color: AppTheme.lightGray
                                                    .withValues(alpha: 0.3),
                                              ),
                                            );
                                          },
                                    ),
                                  ),
                                ),

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
                                          AppTheme.darkGray.withValues(
                                            alpha: .8,
                                          ),
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

                            Positioned(
                              top: 12,
                              right: 12,
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: AppTheme.cardBackground.withValues(
                                    alpha: .9,
                                  ),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: widget.isFavorite
                                        ? AppTheme.imperialYellow
                                        : AppTheme.lightGray.withValues(
                                            alpha: .3,
                                          ),
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: widget.isFavorite
                                          ? AppTheme.imperialYellow.withValues(
                                              alpha: .3,
                                            )
                                          : Colors.black.withValues(alpha: .2),
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
                                      : AppTheme.lightGray.withValues(
                                          alpha: .6,
                                        ),
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
