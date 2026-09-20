import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_screen_app_with_navigation/core/providers/core_provider.dart';
import 'package:multi_screen_app_with_navigation/features/film/data/data_sources/remote_film_data_source.dart';
import 'package:multi_screen_app_with_navigation/features/film/data/model/film_model.dart';
import 'package:multi_screen_app_with_navigation/features/film/data/repositories/film_repository_impl.dart';
import 'package:multi_screen_app_with_navigation/features/film/domain/repositories/film_repository.dart';

final remoteFilmDataSourceProvider = Provider<RemoteFilmDataSource>((ref) {
  final Dio dio = ref.watch(apiClientProvider);
  return RemoteFilmDataSourceImpl(dio: dio);
});

final filmRepositoryProvider = Provider<FilmRepository>((ref) {
  final remoteFilmDataSource = ref.watch(remoteFilmDataSourceProvider);
  return FilmRepositoryImpl(remoteFilmDataSource: remoteFilmDataSource);
});

final filmsProvider = FutureProvider<List<Film>>((ref) {
  return ref.watch(filmRepositoryProvider).getAllFilm();
});

final filmByIdProvider = FutureProvider.family<Film?, int>((ref, id) {
  return ref.watch(filmRepositoryProvider).getFilmById(id);
});
