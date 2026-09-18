// lib/core/errors/dio_error_mapper.dart
import 'package:dio/dio.dart';
import 'package:multi_screen_app_with_navigation/core/network/error/exception.dart';

AppException mapDioException(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.transformTimeout:
      return const TimeoutException();

    case DioExceptionType.connectionError:
      return const NetworkException();

    case DioExceptionType.badResponse:
      final status = e.response?.statusCode;
      final body = e.response?.data;
      switch (status) {
        case 400:
          return const InvalidInputException();
        case 401:
          return const UnauthorizedException();
        case 403:
          return const ForbiddenException();
        case 404:
          return const NotFoundException();
        case 409:
          final msg = body is Map ? body['msg'] ?? body['message'] : null;
          return ConflictException(msg ?? 'Conflit sur cette ressource');
        case 422:
          final msg = body is Map ? body['msg'] ?? body['message'] : null;
          return ConflictException(msg ?? 'Requête invalide');
        default:
          if (status != null && status >= 500) return const ServerException();
          return const UnknownException();
      }

    case DioExceptionType.cancel:
    case DioExceptionType.badCertificate:
    case DioExceptionType.unknown:
      return const UnknownException();
  }
}
