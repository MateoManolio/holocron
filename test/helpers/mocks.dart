import 'package:mocktail/mocktail.dart';
import 'package:holocron/src/domain/contracts/i_auth_repository.dart';
import 'package:holocron/src/domain/contracts/i_character_repository.dart';
import 'package:holocron/src/domain/contracts/i_favorites_repository.dart';
import 'package:holocron/src/core/services/auth_service.dart';
import 'package:holocron/src/core/services/analytics_service.dart';
import 'package:holocron/src/data/datasource/interfaces/i_favorites_local_service.dart';
import 'package:holocron/src/presentation/bloc/auth/auth_bloc.dart';
import 'package:holocron/src/presentation/bloc/character/character_bloc.dart';
import 'package:holocron/src/presentation/bloc/favorites/favorites_bloc.dart';
import 'package:holocron/src/domain/usecase/auth_usecases.dart';
import 'package:holocron/src/domain/usecase/get_characters_usecase.dart';
import 'package:holocron/src/domain/usecase/add_favorite_usecase.dart';
import 'package:holocron/src/domain/usecase/remove_favorite_usecase.dart';
import 'package:holocron/src/domain/usecase/get_favorites_usecase.dart';
import 'package:holocron/src/domain/usecase/clear_favorites_usecase.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

// Repositories
class MockAuthRepository extends Mock implements IAuthRepository {}

class MockCharacterRepository extends Mock implements ICharacterRepository {}

class MockFavoritesRepository extends Mock implements IFavoritesRepository {}

// Services
class MockAuthService extends Mock implements AuthService {}

class MockAnalyticsService extends Mock implements AnalyticsService {}

class MockFavoritesDataSource extends Mock implements IFavoritesDataSource {}

// BLoCs
class MockAuthBloc extends Mock implements AuthBloc {}

class MockCharacterBloc extends Mock implements CharacterBloc {}

class MockFavoritesBloc extends Mock implements FavoritesBloc {}

// Use Cases
class MockGetAuthStreamUseCase extends Mock implements GetAuthStreamUseCase {}

class MockSignOutUseCase extends Mock implements SignOutUseCase {}

class MockSignInUseCase extends Mock implements SignInUseCase {}

class MockSignUpUseCase extends Mock implements SignUpUseCase {}

class MockSignInAnonymouslyUseCase extends Mock
    implements SignInAnonymouslyUseCase {}

class MockGetCharactersUseCase extends Mock implements GetCharactersUseCase {}

class MockAddFavoriteUseCase extends Mock implements AddFavoriteUseCase {}

class MockRemoveFavoriteUseCase extends Mock implements RemoveFavoriteUseCase {}

class MockGetFavoritesUseCase extends Mock implements GetFavoritesUseCase {}

class MockClearFavoritesUseCase extends Mock implements ClearFavoritesUseCase {}

// External Dependencies
class MockFirebaseAuth extends Mock implements firebase_auth.FirebaseAuth {}

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockFirebaseAnalytics extends Mock implements FirebaseAnalytics {}

class MockUserCredential extends Mock implements firebase_auth.UserCredential {}

class MockUser extends Mock implements firebase_auth.User {}
