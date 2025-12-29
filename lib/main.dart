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
import 'package:sentry_flutter/sentry_flutter.dart';

void main() async {
  await SentryFlutter.init(
    (options) {
      options.dsn = const String.fromEnvironment('SENTRY_DSN');
      // Adds request headers and IP for users, for more info visit:
      // https://docs.sentry.io/platforms/dart/guides/flutter/data-management/data-collected/
      options.sendDefaultPii = true;
      options.enableLogs = true;
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for tracing.
      // We recommend adjusting this value in production.
      options.tracesSampleRate = 1.0;
      // Configure Session Replay
      options.replay.sessionSampleRate = 0.1;
      options.replay.onErrorSampleRate = 1.0;
    },
    appRunner: () async {
      // SentryFlutter.init calls ensureInitialized internally, no need to call it again
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      await initDependencies();
      runApp(SentryWidget(child: const MainApp()));
    },
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<AuthBloc>()..add(const AuthSubscriptionRequested()),
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
