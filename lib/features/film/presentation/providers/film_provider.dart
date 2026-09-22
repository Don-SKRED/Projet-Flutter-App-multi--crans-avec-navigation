import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_screen_app_with_navigation/core/providers/core_provider.dart';
import 'package:multi_screen_app_with_navigation/core/database/database_provider.dart';
import 'package:multi_screen_app_with_navigation/features/film/data/data_sources/local_film_data_source.dart';
import 'package:multi_screen_app_with_navigation/features/film/data/data_sources/remote_film_data_source.dart';
import 'package:multi_screen_app_with_navigation/features/film/data/model/film_model.dart';
import 'package:multi_screen_app_with_navigation/features/film/data/repositories/film_repository_impl.dart';
import 'package:multi_screen_app_with_navigation/features/film/domain/repositories/film_repository.dart';

final remoteFilmDataSourceProvider = Provider<RemoteFilmDataSource>((ref) {
  final Dio dio = ref.watch(apiClientProvider);
  return RemoteFilmDataSourceImpl(dio: dio);
});

final localFilmDataSourceProvider = Provider<LocalFilmDataSource>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return LocalFilmDataSourceImpl(database: db);
});

final filmRepositoryProvider = Provider<FilmRepository>((ref) {
  final remoteFilmDataSource = ref.watch(remoteFilmDataSourceProvider);
  final localFilmDataSource = ref.watch(localFilmDataSourceProvider);
  return FilmRepositoryImpl(
    remoteFilmDataSource: remoteFilmDataSource,
    localFilmDataSource: localFilmDataSource,
  );
});

final filmsProvider = FutureProvider<List<Film>>((ref) {
  return ref.watch(filmRepositoryProvider).getAllFilm();
});

final filmByIdProvider = FutureProvider.family<Film?, int>((ref, id) {
  return ref.watch(filmRepositoryProvider).getFilmById(id);
});

/// Ajoute un film via le repository (remote + local Drift)
final addFilmProvider = Provider<Future<void> Function(Film)>((ref) {
  return (film) async {
    await ref.read(filmRepositoryProvider).addFilm(film);
    ref.invalidate(filmsProvider);
  };
});

/// Prochain ID disponible (calculé depuis la base locale)
final nextFilmIdProvider = FutureProvider<int>((ref) {
  return ref.read(filmRepositoryProvider).getNextId();
});
