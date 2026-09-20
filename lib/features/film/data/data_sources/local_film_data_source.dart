import 'package:drift/drift.dart';
import 'package:multi_screen_app_with_navigation/core/database/app_database.dart';
import 'package:multi_screen_app_with_navigation/features/film/data/model/film_model.dart';

abstract class LocalFilmDataSource {
  Future<List<Film>> getAllFilms();
  Future<Film?> getFilmById(int id);
  Future<void> saveFilms(List<Film> films);
  Future<void> saveFilm(Film film);
}

class LocalFilmDataSourceImpl implements LocalFilmDataSource {
  final AppDatabase database;

  LocalFilmDataSourceImpl({required this.database});

  @override
  Future<List<Film>> getAllFilms() async {
    final rows = await database.select(database.filmsTable).get();
    return rows
        .map(
          (row) => Film(
            row.id,
            title: row.title,
            release: row.release,
            synopsis: row.synopsis,
            genre: row.genre,
            poster: row.poster,
          ),
        )
        .toList();
  }

  @override
  Future<Film?> getFilmById(int id) async {
    final query = database.select(database.filmsTable)
      ..where((tbl) => tbl.id.equals(id));
    final row = await query.getSingleOrNull();
    if (row == null) return null;
    return Film(
      row.id,
      title: row.title,
      release: row.release,
      synopsis: row.synopsis,
      genre: row.genre,
      poster: row.poster,
    );
  }

  @override
  Future<void> saveFilms(List<Film> films) async {
    await database.batch((batch) {
      for (final film in films) {
        batch.insert(
          database.filmsTable,
          FilmsTableCompanion(
            id: Value(film.id),
            title: Value(film.title),
            release: Value(film.release),
            synopsis: Value(film.synopsis),
            genre: Value(film.genre),
            poster: Value(film.poster),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }

  @override
  Future<void> saveFilm(Film film) async {
    await database.into(database.filmsTable).insert(
          FilmsTableCompanion(
            id: Value(film.id),
            title: Value(film.title),
            release: Value(film.release),
            synopsis: Value(film.synopsis),
            genre: Value(film.genre),
            poster: Value(film.poster),
          ),
          mode: InsertMode.insertOrReplace,
        );
  }
}
