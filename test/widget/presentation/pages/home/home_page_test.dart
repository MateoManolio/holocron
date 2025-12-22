import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:holocron/src/presentation/pages/home/home_page.dart';
import 'package:holocron/src/presentation/bloc/character/character_bloc.dart';
import 'package:holocron/src/presentation/bloc/character/character_state.dart';
import 'package:holocron/src/presentation/bloc/favorites/favorites_bloc.dart';
import 'package:holocron/src/presentation/bloc/favorites/favorites_state.dart';
import 'package:holocron/src/presentation/bloc/auth/auth_bloc.dart';
import 'package:holocron/src/presentation/bloc/auth/auth_state.dart';
import 'package:holocron/src/domain/entities/character.dart';
import '../../../../helpers/mocks.dart';

void main() {
  late MockCharacterBloc mockCharacterBloc;
  late MockFavoritesBloc mockFavoritesBloc;
  late MockAuthBloc mockAuthBloc;

  setUp(() {
    mockCharacterBloc = MockCharacterBloc();
    mockFavoritesBloc = MockFavoritesBloc();
    mockAuthBloc = MockAuthBloc();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<CharacterBloc>.value(value: mockCharacterBloc),
          BlocProvider<FavoritesBloc>.value(value: mockFavoritesBloc),
          BlocProvider<AuthBloc>.value(value: mockAuthBloc),
        ],
        child: const Scaffold(body: HomePage()),
      ),
    );
  }

  testWidgets('displays CharacterLoaded state', (WidgetTester tester) async {
    final tCharacters = [Character(id: 1, name: 'Luke')];

    when(() => mockCharacterBloc.state).thenReturn(
      CharacterLoaded(
        allCharacters: tCharacters,
        displayedCharacters: tCharacters,
        hasReachedMax: true,
      ),
    );
    when(
      () => mockCharacterBloc.stream,
    ).thenAnswer((_) => const Stream.empty());

    when(() => mockFavoritesBloc.state).thenReturn(FavoritesInitial());
    when(
      () => mockFavoritesBloc.stream,
    ).thenAnswer((_) => const Stream.empty());

    when(() => mockAuthBloc.state).thenReturn(const AuthState.unknown());
    when(() => mockAuthBloc.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump(); // For animations

    expect(find.text('Luke'), findsOneWidget);
  });
}
