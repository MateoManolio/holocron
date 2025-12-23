import 'package:flutter/material.dart';
import '../../../../config/theme/app_theme.dart';

class StatusTag extends StatelessWidget {
  final String label;
  final bool isPrimary;
  final double fontSize;

  static const double _defaultFontSize = 10.0;
  static const double _horizontalPadding = 4.0;
  static const double _verticalPadding = 1.0;
  static const double _borderRadius = 4.0;
  static const double _borderWidth = 1.0;

  const StatusTag({
    super.key,
    required this.label,
    this.isPrimary = false,
    this.fontSize = _defaultFontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: _horizontalPadding,
        vertical: _verticalPadding,
      ),
      decoration: BoxDecoration(
        color: isPrimary
            ? AppTheme.holoBlue.withValues(alpha: .1)
            : Colors.white.withValues(alpha: .05),
        borderRadius: BorderRadius.circular(_borderRadius),
        border: Border.all(
          color: isPrimary
              ? AppTheme.holoBlue.withValues(alpha: .3)
              : Colors.white.withValues(alpha: .1),
          width: _borderWidth,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isPrimary ? AppTheme.holoBlue : Colors.white60,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
