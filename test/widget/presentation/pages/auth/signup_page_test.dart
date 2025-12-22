import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:holocron/src/presentation/pages/auth/signup_page.dart';
import 'package:holocron/src/presentation/bloc/auth/auth_bloc.dart';
import 'package:holocron/src/presentation/bloc/auth/auth_event.dart';
import 'package:holocron/src/presentation/bloc/auth/auth_state.dart';
import '../../../../helpers/mocks.dart';
import 'package:holocron/src/domain/entities/character.dart';

class FakeAuthEvent extends Fake implements AuthEvent {}

class FakeCharacter extends Fake implements Character {}

void main() {
  late MockAuthBloc mockAuthBloc;

  setUpAll(() {
    registerFallbackValue(FakeAuthEvent());
    registerFallbackValue(FakeCharacter());
  });

  setUp(() {
    mockAuthBloc = MockAuthBloc();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<AuthBloc>.value(
        value: mockAuthBloc,
        child: const SignUpPage(),
      ),
    );
  }

  testWidgets('shows validation errors when fields are empty', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    when(() => mockAuthBloc.state).thenReturn(const AuthState.unknown());
    when(() => mockAuthBloc.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(createWidgetUnderTest());

    await tester.tap(find.text('REGISTER PILOT'));
    await tester.pump();

    expect(find.text('Please enter your email'), findsOneWidget);
    expect(find.text('Please enter your password'), findsOneWidget);
  });

  testWidgets('calls AuthSignUpRequested when form is valid', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    when(() => mockAuthBloc.state).thenReturn(const AuthState.unknown());
    when(() => mockAuthBloc.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(createWidgetUnderTest());

    await tester.enterText(find.byType(TextField).at(0), 'test@test.com');
    await tester.enterText(find.byType(TextField).at(1), 'password123');
    await tester.enterText(find.byType(TextField).at(2), 'password123');

    await tester.tap(find.text('REGISTER PILOT'));
    await tester.pump();

    verify(
      () => mockAuthBloc.add(any(that: isA<AuthSignUpRequested>())),
    ).called(1);
  });
}
