import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multi_screen_app_with_navigation/core/network/error/exception.dart';
import 'package:multi_screen_app_with_navigation/features/credits/data/data_sources/local_credits_data_source.dart';
import 'package:multi_screen_app_with_navigation/features/credits/data/data_sources/remote_credits_data_source.dart';
import 'package:multi_screen_app_with_navigation/features/credits/data/model/credits_model.dart';
import 'package:multi_screen_app_with_navigation/features/credits/data/repositories/credits_repository_impl.dart';

// ---------------------------------------------------------------------------
// Fakes pour Credits DataSources
// ---------------------------------------------------------------------------
class FakeRemoteCreditsDataSource implements RemoteCreditsDataSource {
  List<Credits> creditsToReturn = [];
  Exception? exceptionToThrow;

  @override
  Future<List<Credits>> findByFilmId(int filmId) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return creditsToReturn;
  }

  @override
  Future<List<Credits>> findByPersonId(int personId) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return creditsToReturn;
  }
}

class FakeLocalCreditsDataSource implements LocalCreditsDataSource {
  List<Credits> cachedCredits = [];
  List<Credits> savedCredits = [];

  @override
  Future<List<Credits>> findByFilmId(int filmId) async {
    return cachedCredits.where((c) => c.filmId == filmId).toList();
  }

  @override
  Future<List<Credits>> findByPersonId(int personId) async {
    return cachedCredits.where((c) => c.personId == personId).toList();
  }

  @override
  Future<void> saveCredits(List<Credits> credits) async {
    savedCredits = List.from(credits);
    cachedCredits = List.from(credits);
  }
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------
void main() {
  late FakeRemoteCreditsDataSource fakeRemote;
  late FakeLocalCreditsDataSource fakeLocal;
  late CreditsRepositoryImpl repository;

  final sampleCredits = [
    const Credits(
      1,
      filmId: 10,
      personId: 20,
      role: RoleCredit.acteur,
      personnage: 'Cobb',
    ),
  ];

  setUp(() {
    fakeRemote = FakeRemoteCreditsDataSource();
    fakeLocal = FakeLocalCreditsDataSource();
    repository = CreditsRepositoryImpl(
      remoteCreditsDataSource: fakeRemote,
      localCreditsDataSource: fakeLocal,
    );
  });

  group('CreditsRepositoryImpl - findByFilmId', () {
    test(
      'Succès réseau : retourne les crédits et les enregistre en cache local',
      () async {
        fakeRemote.creditsToReturn = sampleCredits;

        final result = await repository.findByFilmId(10);

        expect(result, equals(sampleCredits));
        expect(fakeLocal.savedCredits, equals(sampleCredits));
      },
    );

    test(
      'Échec réseau (mode hors-ligne) : retourne les crédits du cache local',
      () async {
        fakeLocal.cachedCredits = sampleCredits;
        fakeRemote.exceptionToThrow = DioException(
          requestOptions: RequestOptions(path: '/credits'),
          type: DioExceptionType.connectionError,
        );

        final result = await repository.findByFilmId(10);

        expect(result, equals(sampleCredits));
      },
    );

    test(
      'Échec réseau sans cache local : lève une exception réseau mappée',
      () async {
        fakeLocal.cachedCredits = [];
        fakeRemote.exceptionToThrow = DioException(
          requestOptions: RequestOptions(path: '/credits'),
          type: DioExceptionType.connectionError,
        );

        expect(
          () async => await repository.findByFilmId(10),
          throwsA(isA<NetworkException>()),
        );
      },
    );
  });
}
