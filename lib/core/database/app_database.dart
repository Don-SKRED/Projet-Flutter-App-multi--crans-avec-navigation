import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:multi_screen_app_with_navigation/core/database/tables/films_table.dart';
import 'package:multi_screen_app_with_navigation/core/database/tables/persons_table.dart';
import 'package:multi_screen_app_with_navigation/core/database/tables/credits_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [FilmsTable, PersonsTable, CreditsTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(DatabaseConnection super.connection);

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
