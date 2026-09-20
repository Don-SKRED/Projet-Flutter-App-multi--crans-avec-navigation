import 'package:multi_screen_app_with_navigation/features/person/domain/person_model.dart';

abstract class PersonRepository {
  Future<List<Person>> getAllPerson();
  Future<Person?> getPersonById(int id);
}
