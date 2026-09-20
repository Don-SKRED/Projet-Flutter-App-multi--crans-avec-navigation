import 'package:drift/drift.dart';

class CreditsTable extends Table {
  IntColumn get id => integer()();
  IntColumn get filmId => integer()();
  IntColumn get personId => integer()();
  TextColumn get role => text()();
  TextColumn get personnage => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
