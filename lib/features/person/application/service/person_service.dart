import 'package:multi_screen_app_with_navigation/features/person/domain/person_model.dart';
import 'package:multi_screen_app_with_navigation/shared/services/repository.dart';

class PersonService extends Repository<Person> {
  @override
  String get filename => 'person_items.json';
  @override
  String get assetPath => 'assets/data/person_items.json';
  @override
  Person fromJson(Map<String, dynamic> json) => Person.fromJson(json);
  @override
  Map<String, dynamic> toJson(Person item) => item.toJson();
}
