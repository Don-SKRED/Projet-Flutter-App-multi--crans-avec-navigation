import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:multi_screen_app_with_navigation/core/network/error/dio_error_mapper.dart';
import 'package:multi_screen_app_with_navigation/features/film/data/model/film_model.dart';

abstract class RemoteFilmDataSource {
  Future<List<Film>> getAllFilm();
  Future<Film?> getFilmById(int id);
  Future<void> addFilm(Film film);
}

// abstract class LocalFilmDataSource {
//   Future<List<Film>> localFilmDataSource();
//   Future<Film> getFilmById(int id);
// }

class RemoteFilmDataSourceImpl implements RemoteFilmDataSource {
  final Dio dio;
  RemoteFilmDataSourceImpl({required this.dio});
  @override
  Future<List<Film>> getAllFilm() async {
    try {
      final response = await dio.get(
        "/rest/v1/films",
        queryParameters: {'select': "*"},
      );
      print("response: ${response.data}");
      return (response.data as List).map((e) => Film.fromJson(e)).toList();
    } on DioException catch (e) {
      debugPrint("Dio error message: ${e.message}");
      debugPrint("Dio error inner: ${e.error}");
      throw mapDioException(e);
    }
  }

  @override
  Future<Film?> getFilmById(int id) async {
    try {
      final response = await dio.get(
        '/rest/v1/films',
        queryParameters: {'id': 'eq.$id', 'select': '*'},
      );
      final list = response.data as List;
      if (list.isEmpty) return null;
      return Film.fromJson(list.first as Map<String, dynamic>);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<void> addFilm(Film film) async {
    try {
      await dio.post(
        '/rest/v1/films',
        data: film.toJson(),
      );
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}
