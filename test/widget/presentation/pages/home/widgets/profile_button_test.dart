import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:holocron/src/presentation/pages/home/widgets/profile_button.dart';
import 'package:holocron/src/presentation/bloc/auth/auth_bloc.dart';
import 'package:holocron/src/presentation/bloc/auth/auth_state.dart';
import 'package:holocron/src/domain/entities/user_entity.dart';
import '../../../../../helpers/mocks.dart';

void main() {
  late MockAuthBloc mockAuthBloc;

  setUp(() {
    mockAuthBloc = MockAuthBloc();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: Scaffold(
        body: BlocProvider<AuthBloc>.value(
          value: mockAuthBloc,
          child: const ProfileButton(),
        ),
      ),
    );
  }

  testWidgets('renders login icon for guest user', (WidgetTester tester) async {
    when(
      () => mockAuthBloc.state,
    ).thenReturn(const AuthState(user: UserEntity(id: '1', isGuest: true)));
    // Needed for BlocBuilder
    when(() => mockAuthBloc.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.byIcon(Icons.login), findsOneWidget);
  });

  testWidgets('renders person icon for authenticated user', (
    WidgetTester tester,
  ) async {
    when(() => mockAuthBloc.state).thenReturn(
      const AuthState(
        status: AuthStatus.authenticated,
        user: UserEntity(id: '1', isGuest: false),
      ),
    );
    when(() => mockAuthBloc.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.byIcon(Icons.person_outline), findsOneWidget);
  });
}
