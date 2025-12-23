import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/util/responsive_utils.dart';
import '../../../../domain/entities/character.dart';
import '../../../bloc/favorites/favorites_bloc.dart';
import '../../../bloc/favorites/favorites_event.dart';
import '../../../bloc/favorites/favorites_state.dart';
import 'character_card.dart';

class CharactersGrid extends StatelessWidget {
  final List<Character> characters;

  const CharactersGrid({super.key, required this.characters});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesBloc, FavoritesState>(
      builder: (context, favState) {
        final favoriteIds = favState is FavoritesLoaded
            ? favState.favorites.map((f) => f.id).toSet()
            : <int>{};

        final width = MediaQuery.of(context).size.width;
        final config = ResponsiveUtils.getGridConfig(width);
        final crossAxisCount = config.crossAxisCount;
        final horizontalPadding = config.horizontalPadding;
        final childAspectRatio = config.childAspectRatio;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: childAspectRatio,
            ),
            itemCount: characters.length,
            itemBuilder: (context, index) {
              final character = characters[index];
              final isFavorite = favoriteIds.contains(character.id);

              return TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: Duration(milliseconds: 200 + (index * 50)),
                curve: Curves.easeOut,
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(0, 20 * (1 - value)),
                      child: child,
                    ),
                  );
                },
                child: CharacterCard(
                  name: character.name,
                  imagePath: character.image ?? '',
                  isFavorite: isFavorite,
                  onTap: () {
                    if (isFavorite) {
                      context.read<FavoritesBloc>().add(
                        RemoveFromFavorites(character.id.toString()),
                      );
                    } else {
                      context.read<FavoritesBloc>().add(
                        AddToFavorites(character),
                      );
                    }
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}
