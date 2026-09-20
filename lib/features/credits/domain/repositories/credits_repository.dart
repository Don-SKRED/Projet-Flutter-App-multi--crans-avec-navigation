import 'package:multi_screen_app_with_navigation/features/credits/data/model/credits_model.dart';

abstract class CreditsRepository {
  Future<List<Credits>> findByFilmId(int filmId);
  Future<List<Credits>> findByPersonId(int personId);
}
