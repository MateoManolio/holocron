import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/theme/app_theme.dart';
import '../../../../presentation/bloc/favorites/favorites_bloc.dart';
import '../../../../presentation/bloc/favorites/favorites_event.dart';
import '../../../../presentation/bloc/favorites/favorites_state.dart';

class FavoritesSortButton extends StatefulWidget {
  const FavoritesSortButton({super.key});

  @override
  State<FavoritesSortButton> createState() => _FavoritesSortButtonState();
}

class _FavoritesSortButtonState extends State<FavoritesSortButton> {
  final List<String> _options = [
    'Default',
    'Name A-Z',
    'Name Z-A',
    'Newest',
    'Oldest',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesBloc, FavoritesState>(
      builder: (context, state) {
        if (state is! FavoritesLoaded) return const SizedBox.shrink();

        final currentSort = state.sortOption;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppTheme.terminalGreen,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.terminalGreen.withValues(alpha: 0.2),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _options.contains(currentSort) ? currentSort : 'Default',
                dropdownColor: AppTheme.terminalGreen,
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Colors.black,
                ),
                elevation: 8,
                style: AppTheme.bodyText.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                onChanged: (String? value) {
                  if (value != null) {
                    context.read<FavoritesBloc>().add(SortFavorites(value));
                  }
                },
                selectedItemBuilder: (context) {
                  return _options.map((String item) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.sort_by_alpha_rounded,
                          color: Colors.black,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(item),
                      ],
                    );
                  }).toList();
                },
                items: _options.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}
