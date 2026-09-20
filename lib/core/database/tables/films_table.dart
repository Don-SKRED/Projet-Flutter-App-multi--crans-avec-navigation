import 'package:drift/drift.dart';

class FilmsTable extends Table {
  IntColumn get id => integer()();
  TextColumn get title => text()();
  IntColumn get release => integer()();
  TextColumn get synopsis => text()();
  TextColumn get genre => text()();
  TextColumn get poster => text()();

  @override
  Set<Column> get primaryKey => {id};
}
