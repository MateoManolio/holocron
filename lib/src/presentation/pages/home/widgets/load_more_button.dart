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
  bool _isHovered = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
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
          child: GestureDetector(
            onTap: widget.isLoading ? null : widget.onPressed,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _isHovered
                      ? [
                          AppTheme.holoBlue.withOpacity(0.8),
                          AppTheme.holoBlue.withOpacity(0.6),
                        ]
                      : [
                          AppTheme.holoBlue.withOpacity(0.2),
                          AppTheme.holoBlue.withOpacity(0.1),
                        ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _isHovered
                      ? AppTheme.holoBlue
                      : AppTheme.holoBlue.withOpacity(0.5),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _isHovered
                        ? AppTheme.holoBlue.withOpacity(0.3)
                        : AppTheme.holoBlue.withOpacity(0.1),
                    blurRadius: _isHovered ? 15 : 8,
                    spreadRadius: _isHovered ? 2 : 0,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.isLoading)
                    SizedBox(
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
                      color: _isHovered
                          ? AppTheme.holoBlue
                          : AppTheme.holoBlue.withOpacity(0.8),
                      size: 20,
                    ),
                  const SizedBox(width: 12),
                  Text(
                    widget.isLoading ? 'LOADING...' : 'LOAD MORE ARCHIVES',
                    style: AppTheme.caption.copyWith(
                      color: _isHovered
                          ? AppTheme.holoBlue
                          : AppTheme.holoBlue.withOpacity(0.8),
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

