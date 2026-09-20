import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multi_screen_app_with_navigation/core/network/error/exception.dart';
import 'package:multi_screen_app_with_navigation/features/person/data/data_sources/local_person_data_source.dart';
import 'package:multi_screen_app_with_navigation/features/person/data/data_sources/remote_person_data_source.dart';
import 'package:multi_screen_app_with_navigation/features/person/domain/person_model.dart';
import 'package:multi_screen_app_with_navigation/features/person/data/repositories/person_repository_impl.dart';

// ---------------------------------------------------------------------------
// Fakes pour les DataSources Remote et Local
// ---------------------------------------------------------------------------
class FakeRemotePersonDataSource implements RemotePersonDataSource {
  List<Person> personsToReturn = [];
  Person? personByIdToReturn;
  Exception? exceptionToThrow;

  @override
  Future<List<Person>> getAllPerson() async {
    if (exceptionToThrow != null) {
      throw exceptionToThrow!;
    }
    return personsToReturn;
  }

  @override
  Future<Person?> getPersonById(int id) async {
    if (exceptionToThrow != null) {
      throw exceptionToThrow!;
    }
    return personByIdToReturn;
  }
}

class FakeLocalPersonDataSource implements LocalPersonDataSource {
  List<Person> cachedPersons = [];
  List<Person> savedPersons = [];
  Person? savedSinglePerson;

  @override
  Future<List<Person>> getAllPersons() async {
    return cachedPersons;
  }

  @override
  Future<Person?> getPersonById(int id) async {
    try {
      return cachedPersons.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> savePersons(List<Person> persons) async {
    savedPersons = List.from(persons);
    cachedPersons = List.from(persons);
  }

  @override
  Future<void> savePerson(Person person) async {
    savedSinglePerson = person;
    cachedPersons.removeWhere((p) => p.id == person.id);
    cachedPersons.add(person);
  }
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------
void main() {
  late FakeRemotePersonDataSource fakeRemote;
  late FakeLocalPersonDataSource fakeLocal;
  late PersonRepositoryImpl repository;

  final samplePersons = [
    Person(
      1,
      name: 'Christopher Nolan',
      birthday: '1970-07-30',
      gender: true,
      face: 'https://example.com/nolan.jpg',
    ),
    Person(
      2,
      name: 'Leonardo DiCaprio',
      birthday: '1974-11-11',
      gender: true,
      face: 'https://example.com/leo.jpg',
    ),
  ];

  setUp(() {
    fakeRemote = FakeRemotePersonDataSource();
    fakeLocal = FakeLocalPersonDataSource();
    repository = PersonRepositoryImpl(
      remotePersonDataSource: fakeRemote,
      localPersonDataSource: fakeLocal,
    );
  });

  group('PersonRepositoryImpl - getAllPerson', () {
    test(
      'Succès réseau : retourne les personnes distantes et les sauvegarde en cache',
      () async {
        fakeRemote.personsToReturn = samplePersons;

        final result = await repository.getAllPerson();

        expect(result, equals(samplePersons));
        expect(fakeLocal.savedPersons, equals(samplePersons));
      },
    );

    test(
      'Échec réseau (mode hors-ligne) : retourne les personnes du cache local',
      () async {
        fakeLocal.cachedPersons = samplePersons;
        fakeRemote.exceptionToThrow = DioException(
          requestOptions: RequestOptions(path: '/persons'),
          type: DioExceptionType.connectionError,
        );

        final result = await repository.getAllPerson();

        expect(result, equals(samplePersons));
      },
    );

    test(
      'Échec réseau sans cache local : convertit DioException en NetworkException',
      () async {
        fakeLocal.cachedPersons = [];
        fakeRemote.exceptionToThrow = DioException(
          requestOptions: RequestOptions(path: '/persons'),
          type: DioExceptionType.connectionError,
        );

        expect(
          () async => await repository.getAllPerson(),
          throwsA(isA<NetworkException>()),
        );
      },
    );
  });

  group('PersonRepositoryImpl - getPersonById', () {
    test(
      'Succès réseau : retourne la personne et la persiste en local',
      () async {
        final person = samplePersons.first;
        fakeRemote.personByIdToReturn = person;

        final result = await repository.getPersonById(1);

        expect(result, equals(person));
        expect(fakeLocal.savedSinglePerson, equals(person));
      },
    );

    test(
      'Échec réseau : retourne la personne depuis le cache local',
      () async {
        final person = samplePersons.first;
        fakeLocal.cachedPersons = [person];
        fakeRemote.exceptionToThrow = DioException(
          requestOptions: RequestOptions(path: '/persons/1'),
          type: DioExceptionType.receiveTimeout,
        );

        final result = await repository.getPersonById(1);

        expect(result, equals(person));
      },
    );
  });
}
