import 'package:flutter/material.dart';
import '../../../../config/theme/app_theme.dart';
import 'filter_popover.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holocron/src/presentation/bloc/character/character_bloc.dart';
import 'package:holocron/src/presentation/bloc/character/character_event.dart';
import 'package:holocron/src/presentation/bloc/character/character_state.dart';
import '../../../../core/constants/filter_constants.dart';

class SearchInput extends StatefulWidget {
  const SearchInput({super.key});

  @override
  State<SearchInput> createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput> {
  final _overlayController = OverlayPortalController();
  final _layerLink = LayerLink();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CharacterBloc, CharacterState>(
      listener: (context, state) {
        if (state is CharacterLoaded) {
          if (state.isFilterPopoverOpen && !_overlayController.isShowing) {
            _overlayController.show();
          } else if (!state.isFilterPopoverOpen &&
              _overlayController.isShowing) {
            _overlayController.hide();
          }
        }
      },
      builder: (context, state) {
        bool isFocused = false;
        String genderFilter = FilterConstants.all;
        String speciesFilter = FilterConstants.all;
        String statusFilter = FilterConstants.all;

        if (state is CharacterLoaded) {
          isFocused = state.isSearchFocused;
          genderFilter = state.genderFilter;
          speciesFilter = state.speciesFilter;
          statusFilter = state.statusFilter;
        }

        return CompositedTransformTarget(
          link: _layerLink,
          child: OverlayPortal(
            controller: _overlayController,
            overlayChildBuilder: (context) {
              return Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      context.read<CharacterBloc>().add(
                        const FilterPopoverToggled(false),
                      );
                    },
                    behavior: HitTestBehavior.translucent,
                    child: Container(color: Colors.transparent),
                  ),
                  CompositedTransformFollower(
                    link: _layerLink,
                    targetAnchor: Alignment.bottomRight,
                    followerAnchor: Alignment.topRight,
                    offset: const Offset(0, 10),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: FilterPopover(
                        initialGender: genderFilter,
                        initialSpecies: speciesFilter,
                        initialStatus: statusFilter,
                        onApply: (gender, species, status) {
                          context.read<CharacterBloc>().add(
                            FilterCharacters(
                              gender: gender,
                              species: species,
                              status: status,
                            ),
                          );
                        },
                        onClose: () {
                          context.read<CharacterBloc>().add(
                            const FilterPopoverToggled(false),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
            child: Container(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Focus(
                onFocusChange: (hasFocus) {
                  context.read<CharacterBloc>().add(
                    SearchFocusChanged(hasFocus),
                  );
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: AppTheme.cardBackground,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isFocused
                          ? AppTheme.holoBlue
                          : AppTheme.darkGray.withValues(alpha: 0.5),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isFocused
                            ? AppTheme.holoBlue.withValues(alpha: 0.2)
                            : Colors.transparent,
                        blurRadius: isFocused ? 12 : 0,
                        spreadRadius: isFocused ? 2 : 0,
                      ),
                    ],
                  ),
                  child: TextField(
                    style: AppTheme.bodyText.copyWith(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                    onChanged: (value) {
                      context.read<CharacterBloc>().add(
                        SearchCharacters(value),
                      );
                    },
                    decoration: InputDecoration(
                      hintText: 'Search by name...',
                      hintStyle: AppTheme.bodyText.copyWith(
                        color: AppTheme.lightGray.withValues(alpha: 0.4),
                        fontSize: 15,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: isFocused
                            ? AppTheme.holoBlue
                            : AppTheme.lightGray.withValues(alpha: 0.5),
                        size: 22,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.tune,
                          color: _overlayController.isShowing
                              ? AppTheme.holoBlue
                              : AppTheme.lightGray.withValues(alpha: 0.5),
                          size: 22,
                        ),
                        onPressed: () {
                          context.read<CharacterBloc>().add(
                            FilterPopoverToggled(!_overlayController.isShowing),
                          );
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
            ),
          ),
        );
      },
    );
  }
}
