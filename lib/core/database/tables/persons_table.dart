import 'package:drift/drift.dart';

class PersonsTable extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
  TextColumn get birthday => text()();
  BoolColumn get gender => boolean()();
  TextColumn get face => text()();

  @override
  Set<Column> get primaryKey => {id};
}
