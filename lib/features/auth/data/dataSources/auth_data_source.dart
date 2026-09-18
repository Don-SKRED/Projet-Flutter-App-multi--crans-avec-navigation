import 'package:dio/dio.dart';
import 'package:multi_screen_app_with_navigation/core/network/error/dio_error_mapper.dart';
import 'package:multi_screen_app_with_navigation/features/auth/data/model/auth_response_model.dart';

abstract class RemoteAuthDataSource {
  Future<AuthResponseModel> login(String email, String password);
  Future<AuthResponseModel> register(
    String email,
    String password,
    String? username,
  );
  Future<void> logout();
}

class RemoteAuthDataSourceImpl implements RemoteAuthDataSource {
  final Dio dio;
  RemoteAuthDataSourceImpl(this.dio);
  @override
  Future<AuthResponseModel> login(String email, String password) async {
    try {
      final response = await dio.post(
        '/auth/v1/token?grant_type=password',
        data: {'email': email, 'password': password},
      );
      print("response : $response");
      return AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      print('Status: ${e.response?.statusCode}');
      print('Body: ${e.response?.data}');
      print(e);
      final appException = mapDioException(e);
      throw appException.message;
    }
  }

  @override
  Future<AuthResponseModel> register(
    String email,
    String password,
    String? username,
  ) async {
    try {
      final response = await dio.post(
        '/auth/v1/signup',
        data: {
          'email': email,
          'password': password,
          'data': {if (username != null) 'username': username},
        },
      );
      print("response : $response");

      return AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      // print('Status: ${e.response?.statusCode}');
      // print('Body: ${e.response?.data}');
      // print(e);
      final appException = mapDioException(e);
      throw appException;
    }
  }

  @override
  Future<void> logout() async {
    final response = await dio.post('/auth/v1/logout');
    print("response : $response");
  }
}
