import 'package:flutter/material.dart';
import '../../../config/theme/app_theme.dart';
import '../../widgets/widgets.dart';
import 'widgets/holocron_app_bar.dart';
import 'widgets/hero_section.dart';
import 'widgets/character_card.dart';
import 'widgets/load_more_button.dart';
import 'widgets/app_footer.dart';
import 'widgets/results_header.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data - esto debe venir de un controller/state management
    final characters = [
      {'name': 'Luke Skywalker', 'image': 'people/luke.png'},
      {'name': 'Darth Vader', 'image': 'people/vader.png'},
      {'name': 'Princess Leia', 'image': 'people/leia.png'},
      {'name': 'C-3PO', 'image': 'people/c3po.png'},
      {'name': 'Obi-Wan Kenobi', 'image': 'people/kenobi.png'},
      {'name': 'Chewbacca', 'image': 'people/chewby.png'},
      {'name': 'Han Solo', 'image': 'people/solo.png'},
      {'name': 'R2-D2', 'image': 'people/r2d2.png'},
    ];

    return Scaffold(
      backgroundColor: AppTheme.spaceBlack,
      appBar: const HolocronAppBar(),
      body: Stack(
        children: [
          const StarfieldBackground(),
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero Section con título y buscador
                const HeroSection(),

                const SizedBox(height: 20),

                // Results Header
                ResultsHeader(resultsCount: characters.length),

                // Divider
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    bottom: 20,
                  ),
                  child: Container(
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          AppTheme.holoBlue.withValues(alpha: 0.3),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),

                // Characters Grid
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _CharactersGrid(characters: characters),
                ),

                const SizedBox(height: 40),

                // Load More Button
                const LoadMoreButton(
                  onPressed: null, // Por ahora no hace nada
                ),

                // Footer
                const AppFooter(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Grid de personajes con animación de entrada y gestión de favoritos
class _CharactersGrid extends StatefulWidget {
  final List<Map<String, String>> characters;

  const _CharactersGrid({required this.characters});

  @override
  State<_CharactersGrid> createState() => _CharactersGridState();
}

class _CharactersGridState extends State<_CharactersGrid> {
  final Set<int> _favorites = {};

  void _toggleFavorite(int index) {
    setState(() {
      if (_favorites.contains(index)) {
        _favorites.remove(index);
      } else {
        _favorites.add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      // Ajuste dinámico de columnas para desktop
      itemCount: widget.characters.length,
      itemBuilder: (context, index) {
        final character = widget.characters[index];
        final isFavorite = _favorites.contains(index);

        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 400 + (index * 50)),
          curve: Curves.easeOut,
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 30 * (1 - value)),
                child: child,
              ),
            );
          },
          child: CharacterCard(
            name: character['name']!,
            imagePath: character['image']!,
            isFavorite: isFavorite,
            onTap: () => _toggleFavorite(index),
          ),
        );
      },
    );
  }
}
