import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holocron/src/presentation/bloc/character/character_bloc.dart';
import 'package:holocron/src/presentation/bloc/character/character_state.dart';
import 'package:holocron/src/presentation/bloc/character/character_event.dart';
import 'package:holocron/src/presentation/bloc/favorites/favorites_bloc.dart';
import 'package:holocron/src/presentation/bloc/favorites/favorites_event.dart';
import 'package:holocron/src/presentation/bloc/favorites/favorites_state.dart';
import 'package:holocron/src/presentation/widgets/custom_divider.dart';
import '../../../domain/entities/character.dart';
import 'widgets/hero_section.dart';
import 'widgets/character_card.dart';
import 'widgets/load_more_button.dart';
import 'widgets/app_footer.dart';
import 'widgets/results_header.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CharacterBloc, CharacterState>(
      builder: (context, state) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 80),
              const HeroSection(),
              const SizedBox(height: 20),

              if (state is CharacterLoaded) ...[
                ResultsHeader(resultsCount: state.displayedCharacters.length),
                const CustomDivider(),
                _CharactersGrid(characters: state.displayedCharacters),
                const SizedBox(height: 40),
                LoadMoreButton(
                  isLoading: false,
                  onPressed: state.hasReachedMax
                      ? null
                      : () => context.read<CharacterBloc>().add(
                          FetchMoreCharacters(),
                        ),
                ),
              ] else if (state is CharacterLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40.0),
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                )
              else if (state is CharacterError)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Text(
                      state.message,
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                  ),
                ),

              const AppFooter(),
            ],
          ),
        );
      },
    );
  }
}

class _CharactersGrid extends StatelessWidget {
  final List<Character> characters;

  const _CharactersGrid({required this.characters});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesBloc, FavoritesState>(
      builder: (context, favState) {
        final favoriteIds = favState is FavoritesLoaded
            ? favState.favorites.map((f) => f.id).toSet()
            : <int>{};

        final width = MediaQuery.of(context).size.width;
        int crossAxisCount;
        double horizontalPadding;

        if (width < 600) {
          crossAxisCount = 2; // Mobile
          horizontalPadding = 16;
        } else if (width < 900) {
          crossAxisCount = 3; // Tablet small
          horizontalPadding = 24;
        } else if (width < 1200) {
          crossAxisCount = 4; // Tablet large / Laptop
          horizontalPadding = 32;
        } else if (width < 1600) {
          crossAxisCount = 5; // Desktop
          horizontalPadding = 48;
        } else {
          crossAxisCount = 6; // Ultra wide
          horizontalPadding = 80;
        }

        final childAspectRatio = width < 600 ? 0.65 : 0.72;

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
