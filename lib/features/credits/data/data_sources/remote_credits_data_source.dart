import 'package:dio/dio.dart';
import 'package:multi_screen_app_with_navigation/core/network/error/dio_error_mapper.dart';
import 'package:multi_screen_app_with_navigation/features/credits/domain/credits_model.dart';

abstract class RemoteCreditsDataSource {
  Future<List<Credits>> findByFilmId(int filmId);
  Future<List<Credits>> findByPersonId(int personId);
}

class RemoteCreditsDataSourceImpl implements RemoteCreditsDataSource {
  final Dio dio;
  RemoteCreditsDataSourceImpl({required this.dio});

  @override
  Future<List<Credits>> findByFilmId(int filmId) async {
    try {
      final response = await dio.get(
        "/rest/v1/credits", // ← toujours avec le "/" au début !
        queryParameters: {'filmId': 'eq.$filmId', 'select': '*'},
      );
      return (response.data as List)
          .map((e) => Credits.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      print(
        "🔴 Credits DioException status=${e.response?.statusCode} data=${e.response?.data}",
      );
      throw mapDioException(e);
    }
  }

  @override
  Future<List<Credits>> findByPersonId(int personId) async {
    try {
      final response = await dio.get(
        "/rest/v1/credits",
        queryParameters: {'personId': 'eq.$personId', 'select': '*'},
      );
      return (response.data as List)
          .map((e) => Credits.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      print(
        "🔴 Credits DioException status=${e.response?.statusCode} data=${e.response?.data}",
      );
      throw mapDioException(e);
    }
  }
}
