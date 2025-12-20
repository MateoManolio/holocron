import 'package:flutter/material.dart';
import 'widgets/detailed_character_card.dart';
import 'widgets/favorites_header.dart';
import 'widgets/favorites_sort_button.dart';
import 'widgets/favorites_stats.dart';

import '../home/widgets/app_footer.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data for favorites
    final favorites = [
      {
        'name': 'Luke Skywalker',
        'image': 'people/luke.png',
        'species': 'Human',
        'gender': 'Male',
        'homeworld': 'Tatooine',
        'birthYear': '19BBY',
        'height': 172,
        'eyeColor': 'Blue',
        'affiliations': ['Alliance', 'Jedi Order'],
        'mass': '77',
      },
      {
        'name': 'Darth Vader',
        'image': 'people/vader.png',
        'species': 'Human',
        'gender': 'Cyborg',
        'homeworld': 'Tatooine',
        'birthYear': '41.9BBY',
        'height': 202,
        'eyeColor': 'Yellow',
        'affiliations': ['Galactic Empire', 'Sith'],
        'mass': '136',
      },
      {
        'name': 'Leia Organa',
        'image': 'people/leia.png',
        'species': 'Human',
        'gender': 'Female',
        'homeworld': 'Alderaan',
        'birthYear': '19BBY',
        'height': 150,
        'eyeColor': 'Brown',
        'affiliations': ['Alliance', 'New Republic'],
        'mass': '49',
      },
      {
        'name': 'C-3PO',
        'image': 'people/c3po.png',
        'species': 'Droid',
        'gender': 'Protocol',
        'homeworld': 'Tatooine',
        'birthYear': '112BBY',
        'height': 167,
        'eyeColor': 'Yellow',
        'affiliations': ['Alliance', 'Resistance'],
        'mass': '32',
      },
      {
        'name': 'Chewbacca',
        'image': 'people/chewby.png',
        'species': 'Wookiee',
        'gender': 'Male',
        'homeworld': 'Kashyyyk',
        'birthYear': '200BBY',
        'height': 228,
        'eyeColor': 'Blue',
        'affiliations': ['Alliance', 'New Republic'],
        'mass': '112',
      },
      {
        'name': 'Obi-Wan Kenobi',
        'image': 'people/kenobi.png',
        'species': 'Human',
        'gender': 'Male',
        'homeworld': 'Stewjon',
        'birthYear': '57BBY',
        'height': 182,
        'eyeColor': 'Blue-gray',
        'affiliations': ['Jedi Order', 'Alliance'],
        'mass': '77',
      },
    ];

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 80), // AppBar padding

          const FavoritesHeader(),

          const FavoritesStats(),

          const FavoritesSortButton(),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Divider(color: Colors.white10, height: 1),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width > 1200
                    ? 5
                    : 4,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.52,
              ),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final character = favorites[index];
                return TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: Duration(milliseconds: 300 + (index * 50)),
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
                    name: character['name'] as String,
                    imagePath: character['image'] as String,
                    species: character['species'] as String,
                    gender: character['gender'] as String,
                    homeworld: character['homeworld'] as String,
                    birthYear: character['birthYear'] as String,
                    height: character['height'] as int?,
                    eyeColor: character['eyeColor'] as String?,
                    affiliations: character['affiliations'] as List<String>,
                    mass: character['mass'] as String?,
                    onDelete: () {
                      // Handled by state in production, here just confirming the callback
                    },
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 40),

          const AppFooter(),
        ],
      ),
    );
  }
}
