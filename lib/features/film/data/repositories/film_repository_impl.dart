import 'package:multi_screen_app_with_navigation/features/film/data/data_sources/local_film_data_source.dart';
import 'package:multi_screen_app_with_navigation/features/film/data/data_sources/remote_film_data_source.dart';
import 'package:multi_screen_app_with_navigation/features/film/data/model/film_model.dart';
import 'package:multi_screen_app_with_navigation/features/film/domain/repositories/film_repository.dart';

class FilmRepositoryImpl implements FilmRepository {
  final RemoteFilmDataSource remoteFilmDataSource;
  final LocalFilmDataSource localFilmDataSource;

  FilmRepositoryImpl({
    required this.remoteFilmDataSource,
    required this.localFilmDataSource,
  });

  @override
  Future<List<Film>> getAllFilm() async {
    try {
      final remoteFilms = await remoteFilmDataSource.getAllFilm();
      await localFilmDataSource.saveFilms(remoteFilms);
      return remoteFilms;
    } catch (_) {
      // Mode hors-ligne : si pas de réseau, on charge depuis la base locale SQLite
      final cachedFilms = await localFilmDataSource.getAllFilms();
      if (cachedFilms.isNotEmpty) {
        return cachedFilms;
      }
      rethrow;
    }
  }

  @override
  Future<Film?> getFilmById(int id) async {
    try {
      final remoteFilm = await remoteFilmDataSource.getFilmById(id);
      if (remoteFilm != null) {
        await localFilmDataSource.saveFilm(remoteFilm);
      }
      return remoteFilm;
    } catch (_) {
      final cachedFilm = await localFilmDataSource.getFilmById(id);
      if (cachedFilm != null) {
        return cachedFilm;
      }
      rethrow;
    }
  }

  @override
  Future<void> addFilm(Film film) async {
    // Sauvegarde en local Drift (fonctionne hors-ligne)
    await localFilmDataSource.saveFilm(film);
    // Tente aussi d'envoyer au remote si connecté
    try {
      await remoteFilmDataSource.addFilm(film);
    } catch (_) {
      // Ignore les erreurs réseau : le film est déjà en local
    }
  }

  @override
  Future<int> getNextId() async {
    final films = await localFilmDataSource.getAllFilms();
    if (films.isEmpty) return 1;
    return films.map((f) => f.id).reduce((a, b) => a > b ? a : b) + 1;
  }
}
