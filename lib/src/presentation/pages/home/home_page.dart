import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holocron/src/presentation/bloc/character/character_bloc.dart';
import 'package:holocron/src/presentation/bloc/character/character_state.dart';
import 'package:holocron/src/presentation/bloc/character/character_event.dart';
import '../../widgets/widgets.dart';
import 'widgets/character_grid.dart';
import 'widgets/hero_section.dart';
import 'widgets/load_more_button.dart';
import 'widgets/app_footer.dart';
import 'widgets/results_count_and_sort.dart';

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
                ResultsCountAndSort(
                  resultsCount: state.displayedCharacters.length,
                ),
                const CustomDivider(),
                CharactersGrid(characters: state.displayedCharacters),
                const SizedBox(height: 40),
                LoadMoreButton(
                  isLoading: false,
                  onPressed: state.hasReachedMax
                      ? null
                      : () => context.read<CharacterBloc>().add(
                          FetchMoreCharacters(),
                        ),
                ),
              ] else if (state is CharacterLoading || state is CharacterInitial)
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
