import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_screen_app_with_navigation/core/database/database_provider.dart';
import 'package:multi_screen_app_with_navigation/core/providers/core_provider.dart';
import 'package:multi_screen_app_with_navigation/features/person/data/data_sources/local_person_data_source.dart';
import 'package:multi_screen_app_with_navigation/features/person/data/data_sources/remote_person_data_source.dart';
import 'package:multi_screen_app_with_navigation/features/person/data/repositories/person_repository_impl.dart';
import 'package:multi_screen_app_with_navigation/features/person/domain/person_model.dart';
import 'package:multi_screen_app_with_navigation/features/person/domain/repositories/person_repository.dart';

final remotePersonDataSourceProvider = Provider<RemotePersonDataSource>((ref) {
  final Dio dio = ref.watch(apiClientProvider);
  return RemotePersonDataSourceImpl(dio: dio);
});

final localPersonDataSourceProvider = Provider<LocalPersonDataSource>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return LocalPersonDataSourceImpl(database: db);
});

final personRepositoryProvider = Provider<PersonRepository>((ref) {
  final remotePersonDataSource = ref.watch(remotePersonDataSourceProvider);
  final localPersonDataSource = ref.watch(localPersonDataSourceProvider);
  return PersonRepositoryImpl(
    remotePersonDataSource: remotePersonDataSource,
    localPersonDataSource: localPersonDataSource,
  );
});

final personsProvider = FutureProvider<List<Person>>((ref) {
  return ref.watch(personRepositoryProvider).getAllPerson();
});

final personByIdProvider = FutureProvider.family<Person?, int>((ref, id) {
  return ref.watch(personRepositoryProvider).getPersonById(id);
});
