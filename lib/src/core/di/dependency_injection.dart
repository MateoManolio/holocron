import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../../data/datasource/interfaces/i_favorites_local_service.dart';
import '../../data/datasource/interfaces/i_swapi_service.dart';
import '../../data/datasource/local/favorites_local_service.dart';
import '../../data/datasource/remote/swapi_service.dart';
import '../../data/repository/character_repository.dart';
import '../../data/repository/favorites_repository.dart';
import '../../domain/contracts/i_character_repository.dart';
import '../../domain/contracts/i_favorites_repository.dart';
import '../../domain/usecase/add_favorite_usecase.dart';
import '../../domain/usecase/get_character_by_id_usecase.dart';
import '../../domain/usecase/get_characters_by_query_usecase.dart';
import '../../domain/usecase/get_characters_usecase.dart';
import '../../domain/usecase/get_favorites_usecase.dart';
import '../../domain/usecase/is_favorite_usecase.dart';
import '../../domain/usecase/remove_favorite_usecase.dart';
import '../../presentation/bloc/character/character_bloc.dart';
import '../../presentation/bloc/favorites/favorites_bloc.dart';
import '../db/hive_local_storage.dart';
import '../interfaces/local_storage.dart';
import '../network/dio_client.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // Core
  final localStorage = HiveLocalStorage();
  await localStorage.init();
  sl.registerLazySingleton<ILocalStorage>(() => localStorage);

  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => DioClient(sl()));

  // Datasources
  sl.registerLazySingleton<ISwapiService>(() => SwapiService(sl()));
  sl.registerLazySingleton<IFavoritesLocalDataSource>(
    () => FavoritesLocalDataSourceImpl(sl()),
  );

  // Repositories
  sl.registerLazySingleton<ICharacterRepository>(
    () => CharacterRepository(sl()),
  );
  sl.registerLazySingleton<IFavoritesRepository>(
    () => FavoritesRepository(sl()),
  );

  // Usecases
  sl.registerLazySingleton(() => GetCharactersUseCase(sl()));
  sl.registerLazySingleton(() => GetCharacterByIdUseCase(sl()));
  sl.registerLazySingleton(() => GetCharactersByQueryUseCase(sl()));
  sl.registerLazySingleton(() => GetFavoritesUseCase(sl()));
  sl.registerLazySingleton(() => AddFavoriteUseCase(sl()));
  sl.registerLazySingleton(() => RemoveFavoriteUseCase(sl()));
  sl.registerLazySingleton(() => IsFavoriteUseCase(sl()));

  // Blocs
  sl.registerFactory(() => CharacterBloc(getCharactersUseCase: sl()));
  sl.registerFactory(
    () => FavoritesBloc(
      getFavoritesUseCase: sl(),
      addFavoriteUseCase: sl(),
      removeFavoriteUseCase: sl(),
    ),
  );
}
