import 'package:dio/dio.dart';
import 'package:multi_screen_app_with_navigation/core/network/error/dio_error_mapper.dart';
import 'package:multi_screen_app_with_navigation/features/person/data/data_sources/local_person_data_source.dart';
import 'package:multi_screen_app_with_navigation/features/person/data/data_sources/remote_person_data_source.dart';
import 'package:multi_screen_app_with_navigation/features/person/domain/person_model.dart';
import 'package:multi_screen_app_with_navigation/features/person/domain/repositories/person_repository.dart';

class PersonRepositoryImpl implements PersonRepository {
  final RemotePersonDataSource remotePersonDataSource;
  final LocalPersonDataSource localPersonDataSource;

  PersonRepositoryImpl({
    required this.remotePersonDataSource,
    required this.localPersonDataSource,
  });

  @override
  Future<List<Person>> getAllPerson() async {
    try {
      final remotePersons = await remotePersonDataSource.getAllPerson();
      await localPersonDataSource.savePersons(remotePersons);
      return remotePersons;
    } catch (e) {
      final cachedPersons = await localPersonDataSource.getAllPersons();
      if (cachedPersons.isNotEmpty) {
        return cachedPersons;
      }
      if (e is DioException) {
        throw mapDioException(e);
      }
      rethrow;
    }
  }

  @override
  Future<Person?> getPersonById(int id) async {
    try {
      final remotePerson = await remotePersonDataSource.getPersonById(id);
      if (remotePerson != null) {
        await localPersonDataSource.savePerson(remotePerson);
      }
      return remotePerson;
    } catch (e) {
      final cachedPerson = await localPersonDataSource.getPersonById(id);
      if (cachedPerson != null) {
        return cachedPerson;
      }
      if (e is DioException) {
        throw mapDioException(e);
      }
      rethrow;
    }
  }
}
