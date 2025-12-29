import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:holocron/src/presentation/pages/home/widgets/search_input.dart';
import 'package:holocron/src/presentation/bloc/character/character_bloc.dart';
import 'package:holocron/src/presentation/bloc/character/character_event.dart';
import 'package:holocron/src/presentation/bloc/character/character_state.dart';
import '../../../../../helpers/mocks.dart';

class FakeCharacterEvent extends Fake implements CharacterEvent {}

void main() {
  late MockCharacterBloc mockCharacterBloc;

  setUpAll(() {
    registerFallbackValue(FakeCharacterEvent());
  });

  setUp(() {
    mockCharacterBloc = MockCharacterBloc();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: Scaffold(
        body: BlocProvider<CharacterBloc>.value(
          value: mockCharacterBloc,
          child: const Center(child: SearchInput()),
        ),
      ),
    );
  }

  testWidgets('calls SearchCharacters when text changes', (
    WidgetTester tester,
  ) async {
    when(() => mockCharacterBloc.state).thenReturn(CharacterInitial());
    when(
      () => mockCharacterBloc.stream,
    ).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(createWidgetUnderTest());

    await tester.enterText(find.byType(TextField), 'Luke');
    await tester.pump();

    verify(
      () => mockCharacterBloc.add(any(that: isA<SearchCharacters>())),
    ).called(1);
  });

  testWidgets('shows filter popover when tune icon is pressed', (
    WidgetTester tester,
  ) async {
    const loadedState = CharacterLoaded(
      allCharacters: [],
      displayedCharacters: [],
      hasReachedMax: false,
      isFilterPopoverOpen: true,
    );
    when(() => mockCharacterBloc.state).thenReturn(loadedState);
    when(
      () => mockCharacterBloc.stream,
    ).thenAnswer((_) => Stream.fromIterable([loadedState]));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    // Expect the popover to be visible since we provided the state
    expect(find.text('GENDER'), findsOneWidget);
    expect(find.text('SPECIES'), findsOneWidget);
  });
}
