import 'package:flutter/material.dart';
import '../../../../config/theme/app_theme.dart';
import 'filter_popover.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holocron/src/presentation/bloc/character/character_bloc.dart';
import 'package:holocron/src/presentation/bloc/character/character_event.dart';
import 'package:holocron/src/presentation/bloc/character/character_state.dart';

class SearchInput extends StatefulWidget {
  const SearchInput({super.key});

  @override
  State<SearchInput> createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput> {
  bool _isFocused = false;
  final _overlayController = OverlayPortalController();
  final _layerLink = LayerLink();

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: OverlayPortal(
        controller: _overlayController,
        overlayChildBuilder: (context) {
          return Stack(
            children: [
              GestureDetector(
                onTap: () {
                  _overlayController.hide();
                  setState(() {});
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
                  child: BlocBuilder<CharacterBloc, CharacterState>(
                    builder: (context, state) {
                      String g = 'All';
                      String s = 'All';
                      String st = 'All';

                      if (state is CharacterLoaded) {
                        g = state.genderFilter;
                        s = state.speciesFilter;
                        st = state.statusFilter;
                      }

                      return FilterPopover(
                        initialGender: g,
                        initialSpecies: s,
                        initialStatus: st,
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
                          _overlayController.hide();
                          setState(() {});
                        },
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
              setState(() {
                _isFocused = hasFocus;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: AppTheme.cardBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _isFocused
                      ? AppTheme.holoBlue
                      : AppTheme.darkGray.withOpacity(0.5),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _isFocused
                        ? AppTheme.holoBlue.withOpacity(0.2)
                        : Colors.transparent,
                    blurRadius: _isFocused ? 12 : 0,
                    spreadRadius: _isFocused ? 2 : 0,
                  ),
                ],
              ),
              child: TextField(
                style: AppTheme.bodyText.copyWith(
                  color: Colors.white,
                  fontSize: 15,
                ),
                onChanged: (value) {
                  context.read<CharacterBloc>().add(SearchCharacters(value));
                },
                decoration: InputDecoration(
                  hintText: 'Search by name...',
                  hintStyle: AppTheme.bodyText.copyWith(
                    color: AppTheme.lightGray.withOpacity(0.4),
                    fontSize: 15,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: _isFocused
                        ? AppTheme.holoBlue
                        : AppTheme.lightGray.withOpacity(0.5),
                    size: 22,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.tune,
                      color: _overlayController.isShowing
                          ? AppTheme.holoBlue
                          : AppTheme.lightGray.withOpacity(0.5),
                      size: 22,
                    ),
                    onPressed: () {
                      _overlayController.toggle();
                      setState(() {});
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
  }
}

