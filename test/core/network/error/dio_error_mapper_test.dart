import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multi_screen_app_with_navigation/core/network/error/dio_error_mapper.dart';
import 'package:multi_screen_app_with_navigation/core/network/error/exception.dart';

void main() {
  group('mapDioException', () {
    test('convertit connectionError en NetworkException', () {
      final dioError = DioException(
        requestOptions: RequestOptions(path: '/films'),
        type: DioExceptionType.connectionError,
      );

      final result = mapDioException(dioError);

      expect(result, isA<NetworkException>());
      expect(result.message, equals('Vérifie ta connexion internet'));
    });

    test('convertit les timeouts en TimeoutException', () {
      final dioError = DioException(
        requestOptions: RequestOptions(path: '/films'),
        type: DioExceptionType.connectionTimeout,
      );

      final result = mapDioException(dioError);

      expect(result, isA<TimeoutException>());
      expect(result.message, equals('La connexion a expiré, réessaie'));
    });

    test('convertit 401 en UnauthorizedException', () {
      final dioError = DioException(
        requestOptions: RequestOptions(path: '/user'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/user'),
          statusCode: 401,
        ),
      );

      final result = mapDioException(dioError);

      expect(result, isA<UnauthorizedException>());
    });

    test('convertit 403 en ForbiddenException', () {
      final dioError = DioException(
        requestOptions: RequestOptions(path: '/admin'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/admin'),
          statusCode: 403,
        ),
      );

      final result = mapDioException(dioError);

      expect(result, isA<ForbiddenException>());
    });

    test('convertit 404 en NotFoundException', () {
      final dioError = DioException(
        requestOptions: RequestOptions(path: '/unknown'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/unknown'),
          statusCode: 404,
        ),
      );

      final result = mapDioException(dioError);

      expect(result, isA<NotFoundException>());
    });

    test('convertit 500 en ServerException', () {
      final dioError = DioException(
        requestOptions: RequestOptions(path: '/api'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/api'),
          statusCode: 500,
        ),
      );

      final result = mapDioException(dioError);

      expect(result, isA<ServerException>());
    });
  });
}
