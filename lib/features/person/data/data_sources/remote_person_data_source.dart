import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:multi_screen_app_with_navigation/core/network/error/dio_error_mapper.dart';
import 'package:multi_screen_app_with_navigation/features/person/domain/person_model.dart';

abstract class RemotePersonDataSource {
  Future<List<Person>> getAllPerson();
  Future<Person?> getPersonById(int id);
}

class RemotePersonDataSourceImpl implements RemotePersonDataSource {
  final Dio dio;

  RemotePersonDataSourceImpl({required this.dio});

  @override
  Future<List<Person>> getAllPerson() async {
    try {
      final response = await dio.get(
        "/rest/v1/persons",
        queryParameters: {'select': "*"},
      );
      print("response: ${response.data}");
      return (response.data as List).map((e) => Person.fromJson(e)).toList();
    } on DioException catch (e) {
      debugPrint("Dio error message: ${e.message}");
      debugPrint("Dio error inner: ${e.error}");
      throw mapDioException(e);
    }
  }

  @override
  Future<Person?> getPersonById(int id) async {
    try {
      final response = await dio.get(
        '/rest/v1/persons',
        queryParameters: {'id': 'eq.$id', 'select': '*'},
      );
      final list = response.data as List;
      if (list.isEmpty) return null;
      return Person.fromJson(list.first as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint("Dio error message: ${e.message}");
      debugPrint("Dio error inner: ${e.error}");
      throw mapDioException(e);
    }
  }
}
