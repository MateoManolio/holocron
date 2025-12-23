import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/theme/app_theme.dart';
import '../../../../presentation/bloc/character/character_bloc.dart';
import '../../../../presentation/bloc/character/character_event.dart';
import '../../../../presentation/bloc/character/character_state.dart';
import '../../../../core/constants/sort_constants.dart';

class ResultsCountAndSort extends StatelessWidget {
  final int resultsCount;

  const ResultsCountAndSort({super.key, required this.resultsCount});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CharacterBloc, CharacterState>(
      builder: (context, state) {
        if (state is! CharacterLoaded) return const SizedBox.shrink();

        final currentSort = state.sortOption;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  style: AppTheme.bodyText.copyWith(
                    fontSize: 14,
                    color: AppTheme.lightGray.withValues(alpha: 0.7),
                  ),
                  children: [
                    const TextSpan(text: 'Showing '),
                    TextSpan(
                      text: '$resultsCount',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const TextSpan(text: ' results'),
                  ],
                ),
              ),

              Row(
                children: [
                  Text(
                    'Sort by: ',
                    style: AppTheme.bodyText.copyWith(
                      fontSize: 14,
                      color: AppTheme.lightGray.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: AppTheme.cardBackground.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: AppTheme.holoBlue.withValues(alpha: 0.1),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.holoBlue.withValues(alpha: 0.03),
                          blurRadius: 15,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: currentSort,
                        focusColor: Colors.transparent,
                        icon: const Icon(
                          Icons.unfold_more_rounded,
                          color: AppTheme.holoBlue,
                          size: 16,
                        ),
                        dropdownColor: AppTheme.cardBackground,
                        borderRadius: BorderRadius.circular(20),
                        style: AppTheme.bodyText.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            context.read<CharacterBloc>().add(
                              SortCharacters(newValue),
                            );
                          }
                        },
                        selectedItemBuilder: (BuildContext context) {
                          return SortConstants.characterOptions.map<Widget>((
                            String item,
                          ) {
                            return Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                item,
                                style: AppTheme.bodyText.copyWith(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          }).toList();
                        },
                        items: SortConstants.characterOptions
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
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
