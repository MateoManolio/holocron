import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/theme/app_theme.dart';
import '../../../../presentation/bloc/favorites/favorites_bloc.dart';
import '../../../../presentation/bloc/favorites/favorites_event.dart';
import '../../../../presentation/bloc/favorites/favorites_state.dart';
import '../../../../core/constants/sort_constants.dart';

class FavoritesSortButton extends StatefulWidget {
  const FavoritesSortButton({super.key});

  @override
  State<FavoritesSortButton> createState() => _FavoritesSortButtonState();
}

class _FavoritesSortButtonState extends State<FavoritesSortButton> {
  static const double _buttonBorderRadius = 8.0;
  static const double _buttonHorizontalPadding = 20.0;
  static const double _buttonVerticalPadding = 16.0;
  static const double _dropdownHorizontalPadding = 16.0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesBloc, FavoritesState>(
      builder: (context, state) {
        if (state is! FavoritesLoaded) return const SizedBox.shrink();

        final currentSort = state.sortOption;

        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: _buttonHorizontalPadding,
            vertical: _buttonVerticalPadding,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: _dropdownHorizontalPadding,
            ),
            decoration: BoxDecoration(
              color: AppTheme.holoBlue,
              borderRadius: BorderRadius.circular(_buttonBorderRadius),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.holoBlue.withValues(alpha: .2),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: SortConstants.favoritesOptions.contains(currentSort)
                    ? currentSort
                    : SortConstants.favoritesOptions.first,
                dropdownColor: AppTheme.holoBlue,
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Colors.white,
                ),
                elevation: 8,
                style: AppTheme.bodyText.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                onChanged: (String? value) {
                  if (value != null) {
                    context.read<FavoritesBloc>().add(SortFavorites(value));
                  }
                },
                selectedItemBuilder: (context) {
                  return SortConstants.favoritesOptions.map((String item) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.sort_by_alpha_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(item),
                      ],
                    );
                  }).toList();
                },
                items: SortConstants.favoritesOptions
                    .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    })
                    .toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}
