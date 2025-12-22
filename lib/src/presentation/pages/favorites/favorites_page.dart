import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holocron/src/presentation/bloc/favorites/favorites_bloc.dart';
import 'package:holocron/src/presentation/bloc/favorites/favorites_state.dart';
import 'package:holocron/src/presentation/bloc/favorites/favorites_event.dart';
import 'widgets/detailed_character_card.dart';
import '../../../core/util/responsive_utils.dart';
import 'widgets/favorites_header.dart';
import 'widgets/favorites_sort_button.dart';
import 'widgets/favorites_stats.dart';
import '../home/widgets/app_footer.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesBloc, FavoritesState>(
      builder: (context, state) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 80),
              const FavoritesHeader(),
              FavoritesStats(
                count: state is FavoritesLoaded ? state.favorites.length : 0,
              ),
              const FavoritesSortButton(),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Divider(color: Colors.white10, height: 1),
              ),

              if (state is FavoritesLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40.0),
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                )
              else if (state is FavoritesError)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Text(
                      state.message,
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                  ),
                )
              else if (state is FavoritesLoaded)
                state.favorites.isEmpty
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(60.0),
                          child: Text(
                            'NO FAVORITES ARCHIVED YET',
                            style: TextStyle(
                              color: Colors.white30,
                              letterSpacing: 2,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    : Builder(
                        builder: (context) {
                          final width = MediaQuery.of(context).size.width;
                          final config = ResponsiveUtils.getGridConfig(
                            width,
                            isDetailed: true,
                          );
                          final crossAxisCount = config.crossAxisCount;
                          final horizontalPadding = config.horizontalPadding;
                          final childAspectRatio = config.childAspectRatio;

                          return Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: horizontalPadding,
                              vertical: 16,
                            ),
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: crossAxisCount,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
                                    childAspectRatio: childAspectRatio,
                                  ),
                              itemCount: state.favorites.length,
                              itemBuilder: (context, index) {
                                final character = state.favorites[index];
                                return TweenAnimationBuilder<double>(
                                  tween: Tween(begin: 0.0, end: 1.0),
                                  duration: Duration(
                                    milliseconds: 300 + (index * 50),
                                  ),
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
                                  child: DetailedCharacterCard(
                                    name: character.name,
                                    imagePath: character.image ?? '',
                                    species: character.species ?? 'UNKNOWN',
                                    gender: character.gender ?? 'UNKNOWN',
                                    homeworld: character.homeworld ?? 'UNKNOWN',
                                    birthYear:
                                        character.born?.toString() ?? 'UNKNOWN',
                                    height: character.height?.toInt(),
                                    eyeColor: character.eyeColor,
                                    affiliations: character.affiliations,
                                    mass: character.mass?.toString(),
                                    onDelete: () {
                                      context.read<FavoritesBloc>().add(
                                        RemoveFromFavorites(
                                          character.id.toString(),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),

              const SizedBox(height: 40),
              const AppFooter(),
            ],
          ),
        );
      },
    );
  }
}
