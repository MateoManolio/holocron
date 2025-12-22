import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:holocron/src/presentation/pages/auth/login_page.dart';
import 'package:holocron/src/presentation/bloc/auth/auth_bloc.dart';
import 'package:holocron/src/presentation/bloc/auth/auth_event.dart';
import 'package:holocron/src/presentation/bloc/auth/auth_state.dart';
import '../../../../helpers/mocks.dart';

class FakeAuthEvent extends Fake implements AuthEvent {}

void main() {
  late MockAuthBloc mockAuthBloc;

  setUpAll(() {
    registerFallbackValue(FakeAuthEvent());
  });

  setUp(() {
    mockAuthBloc = MockAuthBloc();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<AuthBloc>.value(
        value: mockAuthBloc,
        child: const LoginPage(),
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

    await tester.tap(find.text('ENGAGE HYPERDRIVE'));
    await tester.pump();

    expect(find.text('Please enter your email'), findsOneWidget);
    expect(find.text('Please enter your password'), findsOneWidget);
  });

  testWidgets('calls AuthLoginRequested when form is valid', (
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

    await tester.tap(find.text('ENGAGE HYPERDRIVE'));
    await tester.pump();

    verify(
      () => mockAuthBloc.add(any(that: isA<AuthLoginRequested>())),
    ).called(1);
  });

  testWidgets('calls AuthGuestLoginRequested when Guest Mode is pressed', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    when(() => mockAuthBloc.state).thenReturn(const AuthState.unknown());
    when(() => mockAuthBloc.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(createWidgetUnderTest());

    await tester.tap(find.text('Guest Mode'));
    await tester.pump();

    verify(
      () => mockAuthBloc.add(any(that: isA<AuthGuestLoginRequested>())),
    ).called(1);
  });
}
