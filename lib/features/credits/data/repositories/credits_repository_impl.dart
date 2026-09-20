import 'package:dio/dio.dart';
import 'package:multi_screen_app_with_navigation/core/network/error/dio_error_mapper.dart';
import 'package:multi_screen_app_with_navigation/features/credits/data/data_sources/remote_credits_data_source.dart';
import 'package:multi_screen_app_with_navigation/features/credits/domain/credits_model.dart';
import 'package:multi_screen_app_with_navigation/features/credits/domain/repositories/credits_repository.dart';

class CreditsRepositoryImpl implements CreditsRepository {
  final RemoteCreditsDataSource remoteCreditsDataSource;

  CreditsRepositoryImpl({required this.remoteCreditsDataSource});

  @override
  Future<List<Credits>> findByFilmId(int filmId) async {
    try {
      return await remoteCreditsDataSource.findByFilmId(filmId);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<List<Credits>> findByPersonId(int personId) async {
    try {
      return await remoteCreditsDataSource.findByPersonId(personId);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}
