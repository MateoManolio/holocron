import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:holocron/src/presentation/pages/favorites/favorites_page.dart';
import 'package:holocron/src/presentation/bloc/favorites/favorites_bloc.dart';
import 'package:holocron/src/presentation/bloc/favorites/favorites_state.dart';
import 'package:holocron/src/domain/entities/character.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import '../../../../helpers/mocks.dart';

void main() {
  late MockFavoritesBloc mockFavoritesBloc;

  setUp(() {
    mockFavoritesBloc = MockFavoritesBloc();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: Scaffold(
        body: BlocProvider<FavoritesBloc>.value(
          value: mockFavoritesBloc,
          child: const FavoritesPage(),
        ),
      ),
    );
  }

  testWidgets('shows loading indicator when state is FavoritesLoading', (
    WidgetTester tester,
  ) async {
    when(() => mockFavoritesBloc.state).thenReturn(FavoritesLoading());
    when(
      () => mockFavoritesBloc.stream,
    ).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets(
    'shows empty message when state is FavoritesLoaded with no items',
    (WidgetTester tester) async {
      when(
        () => mockFavoritesBloc.state,
      ).thenReturn(const FavoritesLoaded(favorites: [], sortOption: 'name'));
      when(
        () => mockFavoritesBloc.stream,
      ).thenAnswer((_) => const Stream.empty());

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('NO FAVORITES ARCHIVED YET'), findsOneWidget);
    },
  );

  testWidgets('shows list of favorites when state is FavoritesLoaded', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    final favorites = [
      Character(id: 1, name: 'Luke', image: 'https://example.com/luke.png'),
      Character(id: 2, name: 'Vader', image: 'https://example.com/vader.png'),
    ];

    when(
      () => mockFavoritesBloc.state,
    ).thenReturn(FavoritesLoaded(favorites: favorites, sortOption: 'name'));
    when(
      () => mockFavoritesBloc.stream,
    ).thenAnswer((_) => const Stream.empty());

    await mockNetworkImages(() async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('LUKE'), findsOneWidget);
      expect(find.text('VADER'), findsOneWidget);
    });
  });
}
