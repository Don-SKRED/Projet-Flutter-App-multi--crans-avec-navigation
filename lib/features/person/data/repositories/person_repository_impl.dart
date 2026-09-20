import 'package:dio/dio.dart';
import 'package:multi_screen_app_with_navigation/core/network/error/dio_error_mapper.dart';
import 'package:multi_screen_app_with_navigation/features/person/data/data_sources/remote_person_data_source.dart';
import 'package:multi_screen_app_with_navigation/features/person/domain/person_model.dart';
import 'package:multi_screen_app_with_navigation/features/person/domain/repositories/person_repository.dart';

class PersonRepositoryImpl implements PersonRepository {
  final RemotePersonDataSource remotePersonDataSource;

  PersonRepositoryImpl({required this.remotePersonDataSource});

  @override
  Future<List<Person>> getAllPerson() async {
    try {
      return await remotePersonDataSource.getAllPerson();
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<Person?> getPersonById(int id) async {
    try {
      return await remotePersonDataSource.getPersonById(id);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}
