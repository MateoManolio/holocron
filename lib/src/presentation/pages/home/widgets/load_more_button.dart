import 'package:flutter/material.dart';
import '../../../../config/theme/app_theme.dart';

class LoadMoreButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final bool isLoading;

  const LoadMoreButton({super.key, this.onPressed, this.isLoading = false});

  @override
  State<LoadMoreButton> createState() => _LoadMoreButtonState();
}

class _LoadMoreButtonState extends State<LoadMoreButton>
    with SingleTickerProviderStateMixin {
  final ValueNotifier<bool> _isHovered = ValueNotifier<bool>(false);
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  static const int _animDurationMs = 150;
  static const double _initialScale = 1.0;
  static const double _hoverScale = 1.05;
  static const int _containerAnimDurationMs = 200;
  static const double _borderRadius = 12.0;
  static const double _borderWidth = 2.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: _animDurationMs),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: _initialScale,
      end: _hoverScale,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    _isHovered.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
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
          child: GestureDetector(
            onTap: widget.isLoading ? null : widget.onPressed,
            child: ValueListenableBuilder<bool>(
              valueListenable: _isHovered,
              builder: (context, isHovered, child) {
                return AnimatedContainer(
                  duration: const Duration(
                    milliseconds: _containerAnimDurationMs,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isHovered
                          ? [
                              AppTheme.holoBlue.withValues(alpha: .8),
                              AppTheme.holoBlue.withValues(alpha: .6),
                            ]
                          : [
                              AppTheme.holoBlue.withValues(alpha: .2),
                              AppTheme.holoBlue.withValues(alpha: .1),
                            ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(_borderRadius),
                    border: Border.all(
                      color: isHovered
                          ? AppTheme.holoBlue
                          : AppTheme.holoBlue.withValues(alpha: .5),
                      width: _borderWidth,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isHovered
                            ? AppTheme.holoBlue.withValues(alpha: .3)
                            : AppTheme.holoBlue.withValues(alpha: .1),
                        blurRadius: isHovered ? 15 : 8,
                        spreadRadius: isHovered ? 2 : 0,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.isLoading)
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppTheme.holoBlue,
                            ),
                          ),
                        )
                      else
                        Icon(
                          Icons.refresh,
                          color: isHovered
                              ? AppTheme.holoBlue
                              : AppTheme.holoBlue.withValues(alpha: .8),
                          size: 20,
                        ),
                      const SizedBox(width: 12),
                      Text(
                        widget.isLoading ? 'LOADING...' : 'LOAD MORE ARCHIVES',
                        style: AppTheme.caption.copyWith(
                          color: isHovered
                              ? AppTheme.holoBlue
                              : AppTheme.holoBlue.withValues(alpha: .8),
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
