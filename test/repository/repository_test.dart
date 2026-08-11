import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:multi_screen_app_with_navigation/features/film/domain/film_model.dart';
import 'package:multi_screen_app_with_navigation/shared/services/repository.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

// ---------------------------------------------------------------------------
// Faux repository testable (sans Flutter, sans rootBundle)
// On surcharge getLocalfile() pour pointer vers un fichier temporaire
// créé manuellement dans le test.
// ---------------------------------------------------------------------------
class FakeFilmRepository extends Repository<Film> {
  final File testFile;

  FakeFilmRepository({required this.testFile});

  @override
  String get filename => testFile.path.split(Platform.pathSeparator).last;

  @override
  String get assetPath => 'assets/data/film_items.json'; // Non utilisé dans les tests

  @override
  Film fromJson(Map<String, dynamic> json) => Film.fromJson(json);

  @override
  Map<String, dynamic> toJson(Film item) => item.toJson();

  // On surcharge pour éviter d'utiliser path_provider et rootBundle
  @override
  Future<File> getLocalfile() async => testFile;

  // On surcharge initFile pour ne pas appeler rootBundle.loadString
  @override
  Future<File> initFile() async => testFile;
}

// ---------------------------------------------------------------------------
// Données de test
// ---------------------------------------------------------------------------
List<Film> get testFilms => [
      const Film(
        1,
        title: 'Inception',
        release: 2010,
        synopsis: 'Dream heist',
        genre: 'Sci-Fi',
        poster: 'inception.jpg',
      ),
      const Film(
        2,
        title: 'The Dark Knight',
        release: 2008,
        synopsis: 'Batman vs Joker',
        genre: 'Action',
        poster: 'dark_knight.jpg',
      ),
      const Film(
        3,
        title: 'Interstellar',
        release: 2014,
        synopsis: 'Space travel through wormhole',
        genre: 'Sci-Fi',
        poster: 'interstellar.jpg',
      ),
    ];

String encodeFilms(List<Film> films) =>
    jsonEncode(films.map((f) => f.toJson()).toList());

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------
void main() {
  late File tempFile;
  late FakeFilmRepository repo;

  setUp(() async {
    // Crée un fichier temporaire avant chaque test avec les films de référence
    final dir = Directory.systemTemp.createTempSync('repo_test_');
    tempFile = File('${dir.path}/films.json');
    await tempFile.writeAsString(encodeFilms(testFilms));
    repo = FakeFilmRepository(testFile: tempFile);
  });

  tearDown(() async {
    // Nettoie le fichier temporaire après chaque test
    if (await tempFile.exists()) {
      await tempFile.delete();
    }
  });

  // -------------------------------------------------------------------------
  group('readFile()', () {
    test('lit et retourne tous les films du fichier', () async {
      final films = await repo.readFile();

      expect(films.length, equals(3));
      expect(films[0].title, equals('Inception'));
      expect(films[1].title, equals('The Dark Knight'));
      expect(films[2].title, equals('Interstellar'));
    });

    test('retourne une liste vide si le fichier JSON contient []', () async {
      await tempFile.writeAsString('[]');
      final films = await repo.readFile();
      expect(films, isEmpty);
    });
  });

  // -------------------------------------------------------------------------
  group('findById()', () {
    test('retourne le film correspondant à l\'id donné', () async {
      final film = await repo.findById(2);

      expect(film, isNotNull);
      expect(film!.id, equals(2));
      expect(film.title, equals('The Dark Knight'));
    });

    test('retourne null si l\'id n\'existe pas', () async {
      final film = await repo.findById(999);
      expect(film, isNull);
    });

    test('retourne le premier film (id=1)', () async {
      final film = await repo.findById(1);
      expect(film, isNotNull);
      expect(film!.title, equals('Inception'));
    });
  });

  // -------------------------------------------------------------------------
  group('generateNewId()', () {
    test('génère l\'id max + 1 quand la liste est non vide', () async {
      final newId = await repo.generateNewId();
      // Les films ont les id 1, 2, 3 → max = 3 → next = 4
      expect(newId, equals(4));
    });

    test('génère l\'id 1 quand la liste est vide', () async {
      await tempFile.writeAsString('[]');
      final newId = await repo.generateNewId();
      expect(newId, equals(1));
    });
  });

  // -------------------------------------------------------------------------
  group('add()', () {
    test('ajoute un film et la liste en a un de plus', () async {
      final newFilm = Film(
        await repo.generateNewId(),
        title: 'Oppenheimer',
        release: 2023,
        synopsis: 'The father of the atomic bomb.',
        genre: 'Drama',
        poster: 'oppenheimer.jpg',
      );

      await repo.add(newFilm);

      // Laisse le temps à writeAsString de s'écrire
      await Future.delayed(const Duration(milliseconds: 50));

      final films = await repo.readFile();
      expect(films.length, equals(4));
      expect(films.last.title, equals('Oppenheimer'));
      expect(films.last.id, equals(4));
    });
  });

  // -------------------------------------------------------------------------
  group('update()', () {
    test('met à jour un film existant avec les nouvelles données', () async {
      const updatedFilm = Film(
        1,
        title: 'Inception (Version Longue)',
        release: 2010,
        synopsis: 'Extended dream heist',
        genre: 'Sci-Fi',
        poster: 'inception_extended.jpg',
      );

      await repo.update(1, updatedFilm);
      await Future.delayed(const Duration(milliseconds: 50));

      final film = await repo.findById(1);
      expect(film, isNotNull);
      expect(film!.title, equals('Inception (Version Longue)'));
      expect(film.poster, equals('inception_extended.jpg'));
    });

    test('ne modifie rien si l\'id n\'existe pas', () async {
      const nonExistentFilm = Film(
        999,
        title: 'Ghost Film',
        release: 2000,
        synopsis: 'Does not exist',
        genre: 'Mystery',
        poster: 'ghost.jpg',
      );

      await repo.update(999, nonExistentFilm);
      await Future.delayed(const Duration(milliseconds: 50));

      final films = await repo.readFile();
      // La liste ne change pas (toujours 3 films)
      expect(films.length, equals(3));
      expect(films.any((f) => f.title == 'Ghost Film'), isFalse);
    });
  });
}
