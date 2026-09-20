import 'package:drift/drift.dart';
import 'package:multi_screen_app_with_navigation/core/database/app_database.dart';
import 'package:multi_screen_app_with_navigation/features/person/domain/person_model.dart';

abstract class LocalPersonDataSource {
  Future<List<Person>> getAllPersons();
  Future<Person?> getPersonById(int id);
  Future<void> savePersons(List<Person> persons);
  Future<void> savePerson(Person person);
}

class LocalPersonDataSourceImpl implements LocalPersonDataSource {
  final AppDatabase database;

  LocalPersonDataSourceImpl({required this.database});

  @override
  Future<List<Person>> getAllPersons() async {
    final rows = await database.select(database.personsTable).get();
    return rows
        .map(
          (row) => Person(
            row.id,
            name: row.name,
            birthday: row.birthday,
            gender: row.gender,
            face: row.face,
          ),
        )
        .toList();
  }

  @override
  Future<Person?> getPersonById(int id) async {
    final query = database.select(database.personsTable)
      ..where((tbl) => tbl.id.equals(id));
    final row = await query.getSingleOrNull();
    if (row == null) return null;
    return Person(
      row.id,
      name: row.name,
      birthday: row.birthday,
      gender: row.gender,
      face: row.face,
    );
  }

  @override
  Future<void> savePersons(List<Person> persons) async {
    await database.batch((batch) {
      for (final person in persons) {
        batch.insert(
          database.personsTable,
          PersonsTableCompanion(
            id: Value(person.id),
            name: Value(person.name),
            birthday: Value(person.birthday),
            gender: Value(person.gender),
            face: Value(person.face),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }

  @override
  Future<void> savePerson(Person person) async {
    await database.into(database.personsTable).insert(
          PersonsTableCompanion(
            id: Value(person.id),
            name: Value(person.name),
            birthday: Value(person.birthday),
            gender: Value(person.gender),
            face: Value(person.face),
          ),
          mode: InsertMode.insertOrReplace,
        );
  }
}
