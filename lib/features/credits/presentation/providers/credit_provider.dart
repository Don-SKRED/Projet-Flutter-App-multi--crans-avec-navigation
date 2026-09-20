import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_screen_app_with_navigation/core/database/database_provider.dart';
import 'package:multi_screen_app_with_navigation/core/providers/core_provider.dart';
import 'package:multi_screen_app_with_navigation/features/credits/data/data_sources/local_credits_data_source.dart';
import 'package:multi_screen_app_with_navigation/features/credits/data/data_sources/remote_credits_data_source.dart';
import 'package:multi_screen_app_with_navigation/features/credits/data/repositories/credits_repository_impl.dart';
import 'package:multi_screen_app_with_navigation/features/credits/data/model/credits_model.dart';
import 'package:multi_screen_app_with_navigation/features/credits/domain/repositories/credits_repository.dart';

final remoteCreditsDataSourceProvider = Provider<RemoteCreditsDataSource>((
  ref,
) {
  final Dio dio = ref.watch(apiClientProvider);
  return RemoteCreditsDataSourceImpl(dio: dio);
});

final localCreditsDataSourceProvider = Provider<LocalCreditsDataSource>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return LocalCreditsDataSourceImpl(database: db);
});

final creditsRepositoryProvider = Provider<CreditsRepository>((ref) {
  final remoteCreditsDataSource = ref.watch(remoteCreditsDataSourceProvider);
  final localCreditsDataSource = ref.watch(localCreditsDataSourceProvider);
  return CreditsRepositoryImpl(
    remoteCreditsDataSource: remoteCreditsDataSource,
    localCreditsDataSource: localCreditsDataSource,
  );
});

/// À utiliser dans SpecificFilmPage pour afficher le casting d'un film.
final creditsByFilmIdProvider = FutureProvider.family<List<Credits>, int>((
  ref,
  filmId,
) {
  return ref.watch(creditsRepositoryProvider).findByFilmId(filmId);
});

/// À utiliser dans SpecificPerson pour afficher la filmographie d'une personne.
final creditsByPersonIdProvider = FutureProvider.family<List<Credits>, int>((
  ref,
  personId,
) {
  return ref.watch(creditsRepositoryProvider).findByPersonId(personId);
});
