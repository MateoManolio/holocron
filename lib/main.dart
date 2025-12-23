import 'package:flutter/material.dart';
import 'package:holocron/src/config/theme/app_theme.dart';

import 'src/core/di/dependency_injection.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'src/presentation/bloc/character/character_bloc.dart';
import 'src/presentation/bloc/character/character_event.dart';
import 'src/presentation/bloc/favorites/favorites_bloc.dart';
import 'src/presentation/bloc/favorites/favorites_event.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'src/presentation/widgets/auth/auth_wrapper.dart';
import 'src/presentation/bloc/auth/auth_bloc.dart';
import 'src/presentation/bloc/auth/auth_event.dart';
import 'src/presentation/bloc/main/main_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initDependencies();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<AuthBloc>()..add(AuthSubscriptionRequested()),
        ),
        BlocProvider(
          create: (_) => sl<CharacterBloc>()..add(FetchCharacters()),
        ),
        BlocProvider(create: (_) => sl<FavoritesBloc>()..add(LoadFavorites())),
        BlocProvider(create: (_) => sl<MainBloc>()),
      ],
      child: MaterialApp(
        title: 'Holocron',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const AuthWrapper(),
      ),
    );
  }
}
