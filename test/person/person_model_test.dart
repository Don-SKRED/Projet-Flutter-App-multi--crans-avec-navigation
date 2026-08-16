import 'package:flutter_test/flutter_test.dart';
import 'package:multi_screen_app_with_navigation/features/person/domain/person_model.dart';

void main() {
  // Données de référence
  // Note: Person.fromJson utilise DateTime(json['birthday']).
  // On passe donc un int (l'année), ce que DateTime(year) accepte.
  final Map<String, dynamic> referenceJson = {
    'id': 1,
    'name': 'Marlon Brando',
    'birthday': '1924',
    'gender': true,
    'face': 'brando.jpg',
  };

  final Person referencePerson = Person(
    1,
    name: 'Marlon Brando',
    birthday: "1924",
    gender: true,
    face: 'brando.jpg',
  );

  group('Person.fromJson()', () {
    test('crée une Person correcte à partir d\'un JSON valide', () {
      final person = Person.fromJson(referenceJson);

      expect(person.id, equals(1));
      expect(person.name, equals('Marlon Brando'));
      expect(person.birthday, equals('1924'));
      expect(person.gender, isTrue);
      expect(person.face, equals('brando.jpg'));
    });

    test('le getter id retourne bien la valeur privée _id', () {
      final person = Person.fromJson(referenceJson);
      expect(person.id, equals(referenceJson['id']));
    });

    test('gender à false est bien géré', () {
      final json = Map<String, dynamic>.from(referenceJson)..['gender'] = false;
      final person = Person.fromJson(json);
      expect(person.gender, isFalse);
    });
  });

  group('Person.toJson()', () {
    test('convertit correctement une Person en Map JSON', () {
      final json = referencePerson.toJson();

      expect(json['id'], equals(1));
      expect(json['name'], equals('Marlon Brando'));
      expect(json['birthday'], equals('1924'));
      expect(json['gender'], isTrue);
      expect(json['face'], equals('brando.jpg'));
    });

    test('toJson contient exactement les 5 clés attendues', () {
      final json = referencePerson.toJson();
      expect(
        json.keys,
        containsAll(['id', 'name', 'birthday', 'gender', 'face']),
      );
      expect(json.length, equals(5));
    });
  });
}
