import 'package:dio/dio.dart';
import 'package:multi_screen_app_with_navigation/core/network/error/dio_error_mapper.dart';
import 'package:multi_screen_app_with_navigation/features/credits/data/data_sources/local_credits_data_source.dart';
import 'package:multi_screen_app_with_navigation/features/credits/data/data_sources/remote_credits_data_source.dart';
import 'package:multi_screen_app_with_navigation/features/credits/data/model/credits_model.dart';
import 'package:multi_screen_app_with_navigation/features/credits/domain/repositories/credits_repository.dart';

class CreditsRepositoryImpl implements CreditsRepository {
  final RemoteCreditsDataSource remoteCreditsDataSource;
  final LocalCreditsDataSource localCreditsDataSource;

  CreditsRepositoryImpl({
    required this.remoteCreditsDataSource,
    required this.localCreditsDataSource,
  });

  @override
  Future<List<Credits>> findByFilmId(int filmId) async {
    try {
      final remoteCredits = await remoteCreditsDataSource.findByFilmId(filmId);
      await localCreditsDataSource.saveCredits(remoteCredits);
      return remoteCredits;
    } catch (e) {
      final cachedCredits = await localCreditsDataSource.findByFilmId(filmId);
      if (cachedCredits.isNotEmpty) {
        return cachedCredits;
      }
      if (e is DioException) {
        throw mapDioException(e);
      }
      rethrow;
    }
  }

  @override
  Future<List<Credits>> findByPersonId(int personId) async {
    try {
      final remoteCredits =
          await remoteCreditsDataSource.findByPersonId(personId);
      await localCreditsDataSource.saveCredits(remoteCredits);
      return remoteCredits;
    } catch (e) {
      final cachedCredits =
          await localCreditsDataSource.findByPersonId(personId);
      if (cachedCredits.isNotEmpty) {
        return cachedCredits;
      }
      if (e is DioException) {
        throw mapDioException(e);
      }
      rethrow;
    }
  }
}
