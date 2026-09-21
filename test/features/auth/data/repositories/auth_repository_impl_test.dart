import 'package:flutter_test/flutter_test.dart';
import 'package:multi_screen_app_with_navigation/core/storage/secure_storage_service.dart';
import 'package:multi_screen_app_with_navigation/features/auth/data/dataSources/auth_data_source.dart';
import 'package:multi_screen_app_with_navigation/features/auth/data/model/auth_response_model.dart';
import 'package:multi_screen_app_with_navigation/features/auth/data/model/supabase_user_model.dart';
import 'package:multi_screen_app_with_navigation/features/auth/data/repositories/auth_repository_impl.dart';

// ---------------------------------------------------------------------------
// Fakes pour DataSource et SecureStorageService
// ---------------------------------------------------------------------------
class FakeRemoteAuthDataSource implements RemoteAuthDataSource {
  AuthResponseModel? responseToReturn;
  SupabaseUserModel? currentUserToReturn;
  Exception? exceptionToThrow;
  bool logoutCalled = false;

  @override
  Future<AuthResponseModel> login(String email, String password) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return responseToReturn!;
  }

  @override
  Future<AuthResponseModel> register(
    String email,
    String password,
    String? username,
  ) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return responseToReturn!;
  }

  @override
  Future<void> logout() async {
    logoutCalled = true;
    if (exceptionToThrow != null) throw exceptionToThrow!;
  }

  @override
  Future<SupabaseUserModel> getCurrentUser() async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return currentUserToReturn!;
  }
}

class FakeSecureStorageService extends SecureStorageService {
  final Map<String, String> _storage = {};

  @override
  Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    _storage['access_token'] = accessToken;
    if (refreshToken != null) {
      _storage['refresh_token'] = refreshToken;
    }
  }

  @override
  Future<String?> get accessToken async => _storage['access_token'];

  @override
  Future<String?> get refreshToken async => _storage['refresh_token'];

  @override
  Future<void> clear() async {
    _storage.clear();
  }
}

// ---------------------------------------------------------------------------
// Tests unitaires AuthRepositoryImpl
// ---------------------------------------------------------------------------
void main() {
  late FakeRemoteAuthDataSource fakeDataSource;
  late FakeSecureStorageService fakeStorage;
  late AuthRepositoryImpl repository;

  final sampleUser = SupabaseUserModel(
    id: '11111111-1111-1111-1111-111111111111',
    email: 'test@example.com',
    createdAt: DateTime.parse('2026-01-01T00:00:00Z'),
  );

  final sampleAuthResponse = AuthResponseModel(
    accessToken: 'mock_jwt_access_token',
    refreshToken: 'mock_jwt_refresh_token',
    expiresIn: 3600,
    user: sampleUser,
  );

  setUp(() {
    fakeDataSource = FakeRemoteAuthDataSource();
    fakeStorage = FakeSecureStorageService();
    repository = AuthRepositoryImpl(fakeDataSource, fakeStorage);
  });

  group('AuthRepositoryImpl - login', () {
    test(
      '1. Login : appelle remoteAuthDataSource et enregistre les tokens dans SecureStorage',
      () async {
        fakeDataSource.responseToReturn = sampleAuthResponse;

        final result = await repository.login('test@example.com', 'secret123');

        expect(result.accessToken, equals('mock_jwt_access_token'));
        expect(result.user.email, equals('test@example.com'));
        expect(await fakeStorage.accessToken, equals('mock_jwt_access_token'));
        expect(await fakeStorage.refreshToken, equals('mock_jwt_refresh_token'));
      },
    );
  });

  group('AuthRepositoryImpl - register', () {
    test(
      '2. Register : appelle remoteAuthDataSource et sauvegarde les tokens',
      () async {
        fakeDataSource.responseToReturn = sampleAuthResponse;

        final result = await repository.register(
          'new@example.com',
          'secret123',
          'JohnDoe',
        );

        expect(result.accessToken, equals('mock_jwt_access_token'));
        expect(await fakeStorage.accessToken, equals('mock_jwt_access_token'));
      },
    );
  });

  group('AuthRepositoryImpl - logout', () {
    test(
      '3. Logout : appelle remote et efface impérativement les tokens de SecureStorage',
      () async {
        await fakeStorage.saveTokens(
          accessToken: 'token_to_delete',
          refreshToken: 'refresh_to_delete',
        );

        await repository.logout();

        expect(fakeDataSource.logoutCalled, isTrue);
        expect(await fakeStorage.accessToken, isNull);
        expect(await fakeStorage.refreshToken, isNull);
      },
    );

    test(
      '4. Logout : efface SecureStorage même si le serveur distant échoue',
      () async {
        await fakeStorage.saveTokens(
          accessToken: 'token_to_delete',
          refreshToken: 'refresh_to_delete',
        );
        fakeDataSource.exceptionToThrow = Exception('Network down');

        await repository.logout();

        expect(await fakeStorage.accessToken, isNull);
        expect(await fakeStorage.refreshToken, isNull);
      },
    );
  });

  group('AuthRepositoryImpl - restoreSession', () {
    test(
      '5. restoreSession : retourne null si aucun token n\'est stocké',
      () async {
        final result = await repository.restoreSession();
        expect(result, isNull);
      },
    );

    test(
      '6. restoreSession : restaure la session complète si un token valide existe',
      () async {
        await fakeStorage.saveTokens(
          accessToken: 'stored_token',
          refreshToken: 'stored_refresh',
        );
        fakeDataSource.currentUserToReturn = sampleUser;

        final result = await repository.restoreSession();

        expect(result, isNotNull);
        expect(result!.accessToken, equals('stored_token'));
        expect(result.user.email, equals('test@example.com'));
      },
    );
  });
}
