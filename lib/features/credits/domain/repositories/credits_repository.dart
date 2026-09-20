import 'package:multi_screen_app_with_navigation/features/credits/domain/credits_model.dart';

abstract class CreditsRepository {
  Future<List<Credits>> findByFilmId(int filmId);
  Future<List<Credits>> findByPersonId(int personId);
}
