import 'package:multi_screen_app_with_navigation/features/film/domain/film_model.dart';
import 'package:multi_screen_app_with_navigation/shared/services/repository.dart';

class FilmService extends Repository<Film> {
  @override
  String get filename => 'film_items.json';
  @override
  String get assetPath => 'assets/data/film_items.json';
  @override
  Film fromJson(Map<String, dynamic> json) => Film.fromJson(json);
  @override
  Map<String, dynamic> toJson(Film item) => item.toJson();
}
