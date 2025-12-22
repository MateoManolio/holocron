import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../config/theme/app_theme.dart';

class FilterPopover extends StatefulWidget {
  final VoidCallback onClose;
  final String initialGender;
  final String initialSpecies;
  final String initialStatus;
  final Function(String gender, String species, String status) onApply;

  const FilterPopover({
    super.key,
    required this.onClose,
    required this.initialGender,
    required this.initialSpecies,
    required this.initialStatus,
    required this.onApply,
  });

  @override
  State<FilterPopover> createState() => _FilterPopoverState();
}

class _FilterPopoverState extends State<FilterPopover> {
  late String selectedGender;
  late String selectedSpecies;
  late String selectedStatus;

  @override
  void initState() {
    super.initState();
    selectedGender = widget.initialGender;
    selectedSpecies = widget.initialSpecies;
    selectedStatus = widget.initialStatus;
  }

  @override
  void didUpdateWidget(FilterPopover oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialGender != widget.initialGender) {
      selectedGender = widget.initialGender;
    }
    if (oldWidget.initialSpecies != widget.initialSpecies) {
      selectedSpecies = widget.initialSpecies;
    }
    if (oldWidget.initialStatus != widget.initialStatus) {
      selectedStatus = widget.initialStatus;
    }
  }

  final List<String> genders = ['All', 'Male', 'Female', 'Droid', 'Other'];
  final List<String> species = ['All', 'Human', 'Droid', 'Wookiee', 'Yoda'];
  final List<String> statuses = ['All', 'Alive', 'Deceased'];

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, (1 - value) * -10),
              child: child,
            ),
          );
        },
        child: Container(
          width: 380,
          margin: const EdgeInsets.only(top: 8),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppTheme.cardBackground.withOpacity(0.9),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppTheme.holoBlue.withOpacity(0.2),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 30,
                offset: const Offset(0, 15),
              ),
              BoxShadow(
                color: AppTheme.holoBlue.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Popover Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'FILTER TOOLS',
                        style: AppTheme.caption.copyWith(
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                          color: AppTheme.holoBlue,
                          fontSize: 11,
                        ),
                      ),
                      IconButton(
                        onPressed: widget.onClose,
                        icon: const Icon(Icons.close, size: 18),
                        visualDensity: VisualDensity.compact,
                        color: AppTheme.lightGray.withOpacity(0.6),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white10, height: 24),

                  // Filter Sections
                  _buildSection('GENDER', genders, selectedGender, (val) {
                    setState(() => selectedGender = val);
                  }),
                  const SizedBox(height: 20),
                  _buildSection('SPECIES', species, selectedSpecies, (val) {
                    setState(() => selectedSpecies = val);
                  }),
                  const SizedBox(height: 20),
                  _buildSection('VITAL STATUS', statuses, selectedStatus, (
                    val,
                  ) {
                    setState(() => selectedStatus = val);
                  }),

                  const SizedBox(height: 28),

                  // Actions
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              selectedGender = 'All';
                              selectedSpecies = 'All';
                              selectedStatus = 'All';
                            });
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: AppTheme.lightGray,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text(
                            'Reset',
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: LinearGradient(
                              colors: [
                                AppTheme.holoBlue,
                                AppTheme.holoBlue.withOpacity(0.7),
                              ],
                            ),
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              widget.onApply(
                                selectedGender,
                                selectedSpecies,
                                selectedStatus,
                              );
                              widget.onClose();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              shadowColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Apply Filters',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(
    String title,
    List<String> options,
    String current,
    Function(String) onSelect,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white.withOpacity(0.4),
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final isSelected = current == option;
            return GestureDetector(
              onTap: () => onSelect(option),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.holoBlue.withOpacity(0.15)
                      : Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? AppTheme.holoBlue : Colors.white12,
                    width: 1,
                  ),
                ),
                child: Text(
                  option,
                  style: TextStyle(
                    color: isSelected ? AppTheme.holoBlue : AppTheme.lightGray,
                    fontSize: 12,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

