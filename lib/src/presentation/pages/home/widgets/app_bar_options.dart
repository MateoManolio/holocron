import 'package:flutter/material.dart';
import '../../../../config/theme/app_theme.dart';

class AppBarOptions extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onOptionSelected;

  const AppBarOptions({
    super.key,
    required this.selectedIndex,
    required this.onOptionSelected,
  });

  static const List<String> _options = ['CHARACTERS', 'FAVORITES'];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(_options.length, (index) {
        final option = _options[index];
        final isSelected = index == selectedIndex;
        return _AppBarOptionItem(
          label: option,
          isSelected: isSelected,
          onTap: () => onOptionSelected(index),
        );
      }),
    );
  }
}

class _AppBarOptionItem extends StatefulWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _AppBarOptionItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_AppBarOptionItem> createState() => _AppBarOptionItemState();
}

class _AppBarOptionItemState extends State<_AppBarOptionItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(left: 24),
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: widget.isSelected
                    ? AppTheme.holoBlue
                    : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            widget.label,
            style: AppTheme.caption.copyWith(
              color: widget.isSelected
                  ? AppTheme.holoBlue
                  : _isHovered
                  ? AppTheme.lightGray
                  : AppTheme.lightGray.withOpacity(0.6),
              fontWeight: widget.isSelected ? FontWeight.bold : FontWeight.w500,
              fontSize: 13,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }
}

