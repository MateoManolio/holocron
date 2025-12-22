import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import '../../data/datasource/interfaces/i_favorites_local_service.dart';
import '../../data/datasource/interfaces/i_swapi_service.dart';
import '../../data/datasource/local/favorites_local_service.dart';
import '../../data/datasource/remote/favorites_remote_service.dart';
import '../../data/datasource/remote/swapi_service.dart';
import '../../data/repository/auth_repository.dart';
import '../../data/repository/character_repository.dart';
import '../../data/repository/favorites_repository.dart';
import '../../domain/contracts/i_auth_repository.dart';
import '../../domain/contracts/i_character_repository.dart';
import '../../domain/contracts/i_favorites_repository.dart';
import '../../domain/usecase/add_favorite_usecase.dart';
import '../../domain/usecase/auth_usecases.dart';
import '../../domain/usecase/clear_favorites_usecase.dart';
import '../../domain/usecase/get_character_by_id_usecase.dart';
import '../../domain/usecase/get_characters_by_query_usecase.dart';
import '../../domain/usecase/get_characters_usecase.dart';
import '../../domain/usecase/get_favorites_usecase.dart';
import '../../domain/usecase/is_favorite_usecase.dart';
import '../../domain/usecase/remove_favorite_usecase.dart';
import '../../presentation/bloc/auth/auth_bloc.dart';
import '../../presentation/bloc/character/character_bloc.dart';
import '../../presentation/bloc/favorites/favorites_bloc.dart';
import '../db/hive_local_storage.dart';
import '../interfaces/local_storage.dart';
import '../network/dio_client.dart';
import '../services/analytics_service.dart';
import '../services/auth_service.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // Core
  final localStorage = HiveLocalStorage();
  await localStorage.init();
  sl.registerLazySingleton<ILocalStorage>(() => localStorage);

  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => DioClient(sl()));
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => FirebaseAnalytics.instance);

  // Auth
  sl.registerLazySingleton<IAuthRepository>(() => AuthRepository(sl()));
  sl.registerLazySingleton(() => AuthService(sl()));

  // Analytics
  sl.registerLazySingleton(() => AnalyticsService(sl()));

  // Datasources
  sl.registerLazySingleton<ISwapiService>(() => SwapiService(sl()));

  // Register local datasource with instance name
  sl.registerLazySingleton<IFavoritesDataSource>(
    () => FavoritesLocalDataSourceImpl(sl()),
    instanceName: 'local',
  );

  // Register remote datasource with instance name
  sl.registerLazySingleton<IFavoritesDataSource>(
    () => FavoritesRemoteDataSourceImpl(sl(), sl(), sl()),
    instanceName: 'remote',
  );

  // Repositories
  sl.registerLazySingleton<ICharacterRepository>(
    () => CharacterRepository(sl()),
  );
  sl.registerLazySingleton<IFavoritesRepository>(
    () => FavoritesRepository(
      localDataSource: sl(instanceName: 'local'),
      remoteDataSource: sl(instanceName: 'remote'),
      authService: sl(),
      analytics: sl(),
    ),
  );

  // Usecases
  sl.registerLazySingleton(() => GetCharactersUseCase(sl()));
  sl.registerLazySingleton(() => GetCharacterByIdUseCase(sl()));
  sl.registerLazySingleton(() => GetCharactersByQueryUseCase(sl()));
  sl.registerLazySingleton(() => GetFavoritesUseCase(sl()));
  sl.registerLazySingleton(() => AddFavoriteUseCase(sl()));
  sl.registerLazySingleton(() => RemoveFavoriteUseCase(sl()));
  sl.registerLazySingleton(() => IsFavoriteUseCase(sl()));

  sl.registerLazySingleton(() => ClearFavoritesUseCase(sl()));

  // Auth Usecases
  sl.registerLazySingleton(() => SignInUseCase(sl()));
  sl.registerLazySingleton(() => SignUpUseCase(sl()));
  sl.registerLazySingleton(() => SignOutUseCase(sl()));
  sl.registerLazySingleton(() => SignInAnonymouslyUseCase(sl()));
  sl.registerLazySingleton(() => GetAuthStreamUseCase(sl()));

  // Blocs
  sl.registerFactory(() => CharacterBloc(getCharactersUseCase: sl()));
  sl.registerFactory(
    () => FavoritesBloc(
      getFavoritesUseCase: sl(),
      addFavoriteUseCase: sl(),
      removeFavoriteUseCase: sl(),
      clearFavoritesUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => AuthBloc(
      getAuthStreamUseCase: sl(),
      signOutUseCase: sl(),
      signInUseCase: sl(),
      signUpUseCase: sl(),
      signInAnonymouslyUseCase: sl(),
    ),
  );
}

