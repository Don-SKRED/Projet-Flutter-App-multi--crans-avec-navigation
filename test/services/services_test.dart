import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multi_screen_app_with_navigation/features/film/application/services/film_service.dart';
import 'package:multi_screen_app_with_navigation/features/film/domain/film_model.dart';
import 'package:multi_screen_app_with_navigation/features/credits/application/service/credits_service.dart';
import 'package:multi_screen_app_with_navigation/shared/services/preference_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory tempDir;

  setUpAll(() {
    tempDir = Directory.systemTemp.createTempSync('services_test_');

    const MethodChannel channel = MethodChannel(
      'plugins.flutter.io/path_provider',
    );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          if (methodCall.method == 'getApplicationDocumentsDirectory') {
            return tempDir.path;
          }
          return null;
        });
  });

  tearDownAll(() {
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  group('FilmService Tests', () {
    late FilmService filmService;

    setUp(() {
      filmService = FilmService();
      // Supprimer le fichier local s'il existe pour démarrer sur un test propre
      final localFile = File('${tempDir.path}/${filmService.filename}');
      if (localFile.existsSync()) {
        localFile.deleteSync();
      }
    });

    test(
      'readFile() charge correctement les films depuis les assets initiaux',
      () async {
        final films = await filmService.readFile();
        expect(films, isNotEmpty);
        expect(films.length, equals(5));
        expect(films.first.title, equals('Inception'));
      },
    );

    test('findById() retourne le bon film par ID', () async {
      final film = await filmService.findById(3);
      expect(film, isNotNull);
      expect(film!.title, equals('The Dark Knight'));

      final nonExistent = await filmService.findById(999);
      expect(nonExistent, isNull);
    });

    test(
      'add() ajoute un nouveau film et generateNewId() retourne l\'ID suivant',
      () async {
        final initialNextId = await filmService.generateNewId();
        expect(initialNextId, equals(6));

        final newFilm = Film(
          initialNextId,
          title: 'Interstellar',
          release: 2014,
          synopsis: 'Space exploration',
          genre: 'Sci-Fi',
          poster: 'interstellar.jpg',
        );

        await filmService.add(newFilm);

        final films = await filmService.readFile();
        expect(films.length, equals(6));
        expect(films.last.title, equals('Interstellar'));
        expect(films.last.id, equals(6));

        final subsequentNextId = await filmService.generateNewId();
        expect(subsequentNextId, equals(7));
      },
    );

    test('update() met à jour les informations d\'un film existant', () async {
      const updatedFilm = Film(
        1,
        title: 'Inception (Version Longue)',
        release: 2010,
        synopsis: 'Dream heist extended',
        genre: 'Sci-Fi',
        poster: 'inception_extended.jpg',
      );

      await filmService.update(1, updatedFilm);

      final film = await filmService.findById(1);
      expect(film, isNotNull);
      expect(film!.title, equals('Inception (Version Longue)'));
      expect(film.synopsis, equals('Dream heist extended'));
    });
  });

  group('CreditsService Tests', () {
    late CreditsService creditsService;

    setUp(() {
      creditsService = CreditsService();
      final localFile = File('${tempDir.path}/${creditsService.filename}');
      if (localFile.existsSync()) {
        localFile.deleteSync();
      }
    });

    test('readFile() charge tous les crédits initiaux', () async {
      final credits = await creditsService.readFile();
      expect(credits, isNotEmpty);
      expect(
        credits.length,
        equals(21),
      ); // Il y a 21 items initialement dans les crédits
    });

    test('findByFilmId() filtre correctement par filmId', () async {
      final creditsForFilm3 = await creditsService.findByFilmId(3);
      // Les crédits pour le film 3 incluent Marlon Brando (1), Michael Caine (2), Christian Bale (3), Christopher Nolan (9)
      expect(creditsForFilm3.length, equals(4));
      expect(creditsForFilm3.any((c) => c.personId == 9), isTrue);
    });

    test('findByPersonId() filtre correctement par personId', () async {
      final creditsForPerson9 = await creditsService.findByPersonId(9);
      // Christopher Nolan (personId 9) est réalisateur pour Inception (filmId 1) et The Dark Knight (filmId 3)
      expect(creditsForPerson9.length, equals(2));
      expect(creditsForPerson9.any((c) => c.filmId == 1), isTrue);
      expect(creditsForPerson9.any((c) => c.filmId == 3), isTrue);
    });
  });

  group('PreferenceService Tests', () {
    late PreferenceService preferenceService;

    setUp(() {
      preferenceService = PreferenceService();
      final localFile = File('${tempDir.path}/theme_mode.json');
      if (localFile.existsSync()) {
        localFile.deleteSync();
      }
    });

    test(
      'readFile() retourne false par défaut (valeur initiale de l\'asset)',
      () async {
        final isDarkMode = await preferenceService.readFile();
        expect(isDarkMode, isFalse);
      },
    );

    test(
      'save() met à jour et persiste la préférence de mode sombre',
      () async {
        await preferenceService.save(true);
        final isDarkMode = await preferenceService.readFile();
        expect(isDarkMode, isTrue);

        await preferenceService.save(false);
        final isDarkModeUpdated = await preferenceService.readFile();
        expect(isDarkModeUpdated, isFalse);
      },
    );
  });
}
