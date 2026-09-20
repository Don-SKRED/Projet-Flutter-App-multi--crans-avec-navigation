import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multi_screen_app_with_navigation/features/film/data/data_sources/local_film_data_source.dart';
import 'package:multi_screen_app_with_navigation/features/film/data/data_sources/remote_film_data_source.dart';
import 'package:multi_screen_app_with_navigation/features/film/data/model/film_model.dart';
import 'package:multi_screen_app_with_navigation/features/film/data/repositories/film_repository_impl.dart';

// ---------------------------------------------------------------------------
// Fakes pour les DataSources Remote et Local
// ---------------------------------------------------------------------------
class FakeRemoteFilmDataSource implements RemoteFilmDataSource {
  List<Film> filmsToReturn = [];
  Film? filmByIdToReturn;
  Exception? exceptionToThrow;

  @override
  Future<List<Film>> getAllFilm() async {
    if (exceptionToThrow != null) {
      throw exceptionToThrow!;
    }
    return filmsToReturn;
  }

  @override
  Future<Film?> getFilmById(int id) async {
    if (exceptionToThrow != null) {
      throw exceptionToThrow!;
    }
    return filmByIdToReturn;
  }
}

class FakeLocalFilmDataSource implements LocalFilmDataSource {
  List<Film> cachedFilms = [];
  List<Film> savedFilms = [];
  Film? savedSingleFilm;

  @override
  Future<List<Film>> getAllFilms() async {
    return cachedFilms;
  }

  @override
  Future<Film?> getFilmById(int id) async {
    try {
      return cachedFilms.firstWhere((f) => f.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveFilms(List<Film> films) async {
    savedFilms = List.from(films);
    cachedFilms = List.from(films);
  }

  @override
  Future<void> saveFilm(Film film) async {
    savedSingleFilm = film;
    cachedFilms.removeWhere((f) => f.id == film.id);
    cachedFilms.add(film);
  }
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------
void main() {
  late FakeRemoteFilmDataSource fakeRemote;
  late FakeLocalFilmDataSource fakeLocal;
  late FilmRepositoryImpl repository;

  final sampleFilms = [
    const Film(
      1,
      title: 'Inception',
      release: 2010,
      synopsis: 'A dream heist',
      genre: 'Sci-Fi',
      poster: 'https://example.com/inception.jpg',
    ),
    const Film(
      2,
      title: 'Interstellar',
      release: 2014,
      synopsis: 'Space exploration',
      genre: 'Sci-Fi',
      poster: 'https://example.com/interstellar.jpg',
    ),
  ];

  setUp(() {
    fakeRemote = FakeRemoteFilmDataSource();
    fakeLocal = FakeLocalFilmDataSource();
    repository = FilmRepositoryImpl(
      remoteFilmDataSource: fakeRemote,
      localFilmDataSource: fakeLocal,
    );
  });

  group('FilmRepositoryImpl - getAllFilm', () {
    test(
      '1. Succès réseau : retourne les films distants et les sauvegarde en cache local',
      () async {
        fakeRemote.filmsToReturn = sampleFilms;

        final result = await repository.getAllFilm();

        expect(result, equals(sampleFilms));
        expect(fakeLocal.savedFilms, equals(sampleFilms));
        expect(fakeLocal.cachedFilms, equals(sampleFilms));
      },
    );

    test(
      '2. Échec réseau (mode hors-ligne) : retourne les données du cache SQLite',
      () async {
        // Pré-remplissage du cache local
        fakeLocal.cachedFilms = sampleFilms;
        // Simulation d'une coupure réseau DioException
        fakeRemote.exceptionToThrow = DioException(
          requestOptions: RequestOptions(path: '/films'),
          type: DioExceptionType.connectionError,
        );

        final result = await repository.getAllFilm();

        expect(result, equals(sampleFilms));
      },
    );

    test(
      '3. Échec réseau sans cache local : propage l\'exception réseau',
      () async {
        fakeLocal.cachedFilms = []; // Cache vide
        fakeRemote.exceptionToThrow = DioException(
          requestOptions: RequestOptions(path: '/films'),
          type: DioExceptionType.connectionError,
        );

        expect(
          () async => await repository.getAllFilm(),
          throwsA(isA<DioException>()),
        );
      },
    );
  });

  group('FilmRepositoryImpl - getFilmById', () {
    test(
      '4. Succès réseau : retourne le film distant et le sauvegarde en local',
      () async {
        final film = sampleFilms.first;
        fakeRemote.filmByIdToReturn = film;

        final result = await repository.getFilmById(1);

        expect(result, equals(film));
        expect(fakeLocal.savedSingleFilm, equals(film));
      },
    );

    test(
      '5. Échec réseau : retourne le film depuis le cache local',
      () async {
        final film = sampleFilms.first;
        fakeLocal.cachedFilms = [film];
        fakeRemote.exceptionToThrow = DioException(
          requestOptions: RequestOptions(path: '/films/1'),
          type: DioExceptionType.connectionTimeout,
        );

        final result = await repository.getFilmById(1);

        expect(result, equals(film));
      },
    );
  });
}
