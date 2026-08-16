import 'package:flutter_test/flutter_test.dart';
import 'package:multi_screen_app_with_navigation/features/film/domain/film_model.dart';

void main() {
  // Un film de référence réutilisé dans plusieurs tests
  const Film referenceFilm = Film(
    1,
    title: 'Inception',
    release: 2010,
    synopsis: 'A thief who steals corporate secrets through dream-sharing.',
    genre: 'Sci-Fi',
    poster: 'inception.jpg',
  );

  final Map<String, dynamic> referenceJson = {
    'id': 1,
    'title': 'Inception',
    'release': 2010,
    'synopsis': 'A thief who steals corporate secrets through dream-sharing.',
    'genre': 'Sci-Fi',
    'poster': 'inception.jpg',
  };

  group('Film.fromJson()', () {
    test('crée un Film correct à partir d\'un JSON valide', () {
      final film = Film.fromJson(referenceJson);

      expect(film.id, equals(1));
      expect(film.title, equals('Inception'));
      expect(film.release, equals(2010));
      expect(film.synopsis, equals('A thief who steals corporate secrets through dream-sharing.'));
      expect(film.genre, equals('Sci-Fi'));
      expect(film.poster, equals('inception.jpg'));
    });

    test('l\'id privé est bien exposé via le getter id', () {
      final film = Film.fromJson(referenceJson);
      expect(film.id, equals(referenceJson['id']));
    });

    test('gère un release à 0 sans erreur', () {
      final json = Map<String, dynamic>.from(referenceJson)..['release'] = 0;
      final film = Film.fromJson(json);
      expect(film.release, equals(0));
    });
  });

  group('Film.toJson()', () {
    test('convertit correctement un Film en Map JSON', () {
      final json = referenceFilm.toJson();

      expect(json['id'], equals(1));
      expect(json['title'], equals('Inception'));
      expect(json['release'], equals(2010));
      expect(json['synopsis'], equals('A thief who steals corporate secrets through dream-sharing.'));
      expect(json['genre'], equals('Sci-Fi'));
      expect(json['poster'], equals('inception.jpg'));
    });

    test('toJson contient exactement les 6 clés attendues', () {
      final json = referenceFilm.toJson();
      expect(json.keys, containsAll(['id', 'title', 'release', 'synopsis', 'genre', 'poster']));
      expect(json.length, equals(6));
    });
  });

  group('Film.fromJson() → toJson() (aller-retour)', () {
    test('fromJson puis toJson donne un résultat identique au JSON original', () {
      final film = Film.fromJson(referenceJson);
      final backToJson = film.toJson();

      expect(backToJson, equals(referenceJson));
    });
  });
}
