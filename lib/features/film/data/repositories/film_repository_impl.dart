import 'package:dio/dio.dart';
import 'package:multi_screen_app_with_navigation/core/network/error/dio_error_mapper.dart';
import 'package:multi_screen_app_with_navigation/features/film/data/data_sources/remote_film_data_source.dart';
import 'package:multi_screen_app_with_navigation/features/film/data/model/film_model.dart';
import 'package:multi_screen_app_with_navigation/features/film/domain/repositories/film_repository.dart';

class FilmRepositoryImpl implements FilmRepository {
  final RemoteFilmDataSource remoteFilmDataSource;

  FilmRepositoryImpl({required this.remoteFilmDataSource});
  @override
  Future<List<Film>> getAllFilm() async {
    try {
      return await remoteFilmDataSource.getAllFilm();
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<Film?> getFilmById(int id) async {
    try {
      return await remoteFilmDataSource.getFilmById(id);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}
