import 'package:flutter/material.dart';

import 'metadata_row.dart';

class MetadataGrid extends StatelessWidget {
  final String homeworld;
  final String birthYear;
  final int? height;
  final String? eyeColor;
  final String? mass;

  const MetadataGrid({
    super.key,
    required this.homeworld,
    required this.birthYear,
    this.height,
    this.eyeColor,
    this.mass,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: MetadataRow(label: 'HOMEWORLD', value: homeworld),
            ),
            Expanded(
              child: MetadataRow(label: 'BIRTH YEAR', value: birthYear),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: MetadataRow(
                label: 'HEIGHT',
                value: height != null ? '${height}cm' : 'UNKNOWN',
              ),
            ),
            Expanded(
              child: MetadataRow(
                label: 'EYE COLOR',
                value: eyeColor?.toUpperCase() ?? 'UNKNOWN',
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: MetadataRow(
                label: 'MASS',
                value: mass != null ? '${mass}kg' : 'UNKNOWN',
              ),
            ),
            const Expanded(child: SizedBox()),
          ],
        ),
      ],
    );
  }
}
