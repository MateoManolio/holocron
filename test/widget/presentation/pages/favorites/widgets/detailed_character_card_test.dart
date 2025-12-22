import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:holocron/src/presentation/pages/favorites/widgets/detailed_character_card.dart';

void main() {
  testWidgets('renders character details correctly', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    const name = 'Luke Skywalker';
    const homeworld = 'Tatooine';

    await mockNetworkImages(() async {
      debugPrint('Pumping widget...');
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 300,
                height: 600,
                child: DetailedCharacterCard(
                  name: name,
                  imagePath: 'https://example.com/image.png',
                  species: 'Human',
                  gender: 'Male',
                  homeworld: homeworld,
                  birthYear: '19BBY',
                ),
              ),
            ),
          ),
        ),
      );
      debugPrint('Widget pumped.');

      expect(find.text(name.toUpperCase()), findsOneWidget);
      expect(find.text(homeworld), findsOneWidget);
    });
  });

  testWidgets('calls onDelete when delete button is pressed and confirmed', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    bool deleteCalled = false;

    await mockNetworkImages(() async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 300,
                height: 600,
                child: DetailedCharacterCard(
                  name: 'Luke',
                  imagePath: 'https://example.com/image.png',
                  species: 'Human',
                  gender: 'Male',
                  homeworld: 'Tatooine',
                  birthYear: '19BBY',
                  onDelete: () => deleteCalled = true,
                ),
              ),
            ),
          ),
        ),
      );

      final deleteButton = find.byIcon(Icons.close_rounded);
      await tester.tap(deleteButton);
      await tester.pumpAndSettle();

      // Now find the confirm button in the popover
      final confirmDelete = find.text('Confirm Removal');
      expect(confirmDelete, findsOneWidget);

      await tester.tap(confirmDelete);
      expect(deleteCalled, isTrue);
    });
  });
}
