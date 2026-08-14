import 'package:multi_screen_app_with_navigation/features/credits/domain/credits_model.dart';

import 'package:multi_screen_app_with_navigation/shared/services/repository.dart';

class CreditsService extends Repository<Credits> {
  @override
  String get assetPath => 'assets/data/credits_items.json';

  @override
  String get filename => "credits_items.json";

  @override
  fromJson(Map<String, dynamic> json) {
    return Credits.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(Credits item) => item.toJson();

  Future<List<Credits>> findByPersonId(int personId) async {
    List<Credits> listCredits = await readFile();

    return listCredits
        .where((credits) => credits.personId == personId)
        .toList();
  }

  Future<List<Credits>> findByFilmId(int filmId) async {
    List<Credits> listCredits = await readFile();
    return listCredits.where((credits) => credits.filmId == filmId).toList();
  }
}
