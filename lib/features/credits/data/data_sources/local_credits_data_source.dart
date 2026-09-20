import 'package:drift/drift.dart';
import 'package:multi_screen_app_with_navigation/core/database/app_database.dart';
import 'package:multi_screen_app_with_navigation/features/credits/data/model/credits_model.dart';

abstract class LocalCreditsDataSource {
  Future<List<Credits>> findByFilmId(int filmId);
  Future<List<Credits>> findByPersonId(int personId);
  Future<void> saveCredits(List<Credits> credits);
}

class LocalCreditsDataSourceImpl implements LocalCreditsDataSource {
  final AppDatabase database;

  LocalCreditsDataSourceImpl({required this.database});

  @override
  Future<List<Credits>> findByFilmId(int filmId) async {
    final query = database.select(database.creditsTable)
      ..where((tbl) => tbl.filmId.equals(filmId));
    final rows = await query.get();
    return rows
        .map(
          (row) => Credits(
            row.id,
            filmId: row.filmId,
            personId: row.personId,
            role: RoleCredit.values.byName(row.role),
            personnage: row.personnage,
          ),
        )
        .toList();
  }

  @override
  Future<List<Credits>> findByPersonId(int personId) async {
    final query = database.select(database.creditsTable)
      ..where((tbl) => tbl.personId.equals(personId));
    final rows = await query.get();
    return rows
        .map(
          (row) => Credits(
            row.id,
            filmId: row.filmId,
            personId: row.personId,
            role: RoleCredit.values.byName(row.role),
            personnage: row.personnage,
          ),
        )
        .toList();
  }

  @override
  Future<void> saveCredits(List<Credits> credits) async {
    await database.batch((batch) {
      for (final credit in credits) {
        batch.insert(
          database.creditsTable,
          CreditsTableCompanion(
            id: Value(credit.id),
            filmId: Value(credit.filmId),
            personId: Value(credit.personId),
            role: Value(credit.role.name),
            personnage: Value(credit.personnage),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }
}
