import 'package:flutter/material.dart';
import '../../../../config/theme/app_theme.dart';

class ResultsHeader extends StatefulWidget {
  final int resultsCount;

  const ResultsHeader({super.key, required this.resultsCount});

  @override
  State<ResultsHeader> createState() => _ResultsHeaderState();
}

class _ResultsHeaderState extends State<ResultsHeader> {
  String _selectedSort = 'Relevance';
  final List<String> _sortOptions = ['Relevance', 'Name', 'Newest', 'Oldest'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // "Showing X results"
          RichText(
            text: TextSpan(
              style: AppTheme.bodyText.copyWith(
                fontSize: 14,
                color: AppTheme.lightGray.withValues(alpha: 0.7),
              ),
              children: [
                const TextSpan(text: 'Showing '),
                TextSpan(
                  text: '${widget.resultsCount}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const TextSpan(text: ' results'),
              ],
            ),
          ),

          // "Sort by: [Dropdown]"
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
                    value: _selectedSort,
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
                        setState(() {
                          _selectedSort = newValue;
                        });
                      }
                    },
                    selectedItemBuilder: (BuildContext context) {
                      return _sortOptions.map<Widget>((String item) {
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
                    items: _sortOptions.map<DropdownMenuItem<String>>((
                      String value,
                    ) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
