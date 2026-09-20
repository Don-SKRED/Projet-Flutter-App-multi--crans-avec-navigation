import 'package:multi_screen_app_with_navigation/features/film/data/model/film_model.dart';

abstract class FilmRepository {
  Future<List<Film>> getAllFilm();
  Future<Film?> getFilmById(int id);
}
