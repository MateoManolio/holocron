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
              Theme(
                data: Theme.of(
                  context,
                ).copyWith(canvasColor: AppTheme.cardBackground),
                child: DropdownButton<String>(
                  value: _selectedSort,
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white,
                    size: 18,
                  ),
                  underline: const SizedBox(),
                  style: AppTheme.bodyText.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedSort = newValue;
                      });
                    }
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
            ],
          ),
        ],
      ),
    );
  }
}
