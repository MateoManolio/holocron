import 'package:flutter/material.dart';
import '../../../../config/theme/app_theme.dart';

class SearchInput extends StatefulWidget {
  const SearchInput({super.key});

  @override
  State<SearchInput> createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 600),
      child: Focus(
        onFocusChange: (hasFocus) {
          setState(() {
            _isFocused = hasFocus;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: AppTheme.cardBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isFocused
                  ? AppTheme.holoBlue
                  : AppTheme.darkGray.withValues(alpha: 0.5),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: _isFocused
                    ? AppTheme.holoBlue.withValues(alpha: 0.2)
                    : Colors.transparent,
                blurRadius: _isFocused ? 12 : 0,
                spreadRadius: _isFocused ? 2 : 0,
              ),
            ],
          ),
          child: TextField(
            style: AppTheme.bodyText.copyWith(
              color: Colors.white,
              fontSize: 15,
            ),
            decoration: InputDecoration(
              hintText: 'Search by name...',
              hintStyle: AppTheme.bodyText.copyWith(
                color: AppTheme.lightGray.withValues(alpha: 0.4),
                fontSize: 15,
              ),
              prefixIcon: Icon(
                Icons.search,
                color: _isFocused
                    ? AppTheme.holoBlue
                    : AppTheme.lightGray.withValues(alpha: 0.5),
                size: 22,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  Icons.tune,
                  color: AppTheme.lightGray.withValues(alpha: 0.5),
                  size: 22,
                ),
                onPressed: () {
                  // Acción de filtros
                },
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
