# 🎬 Multi-Screen CineApp — Application Flutter Full-Stack Connectée

[![Flutter](https://img.shields.io/badge/Flutter-3.10%2B-blue.svg)](https://flutter.dev)
[![State Management](https://img.shields.io/badge/State_Management-Riverpod_3-purple.svg)](https://riverpod.dev)
[![Database](https://img.shields.io/badge/Database-Drift_(SQLite)-green.svg)](https://drift.simonbinder.eu/)
[![Network](https://img.shields.io/badge/Network-Dio-orange.svg)](https://pub.dev/packages/dio)
[![Tests](https://img.shields.io/badge/Tests-23_Passed-brightgreen.svg)]()

---

## 📑 Sommaire des Exigences et Preuves de Code

1. [Fonctionnalité 1 : Authentification (login / register / logout) — JWT](#-1-authentification-login--register--logout--jwt)
2. [Fonctionnalité 2 : Au moins 3 écrans de données issues d'une API REST](#-2-au-moins-3-écrans-de-données-issues-dune-api-rest)
3. [Fonctionnalité 3 : Mise en cache locale des données (SQLite avec Drift)](#-3-mise-en-cache-locale-des-données-sqlite-avec-drift)
4. [Fonctionnalité 4 : Mode hors-ligne (afficher les données cachées si pas de réseau)](#-4-mode-hors-ligne-afficher-les-données-cachées-si-pas-de-réseau)
5. [Fonctionnalité 5 : Gestion d'erreurs réseau avec messages utilisateur](#-5-gestion-derreurs-réseau-avec-messages-utilisateur)
6. [Exigence Technique 1 : Architecture Clean / Feature-First](#-6-architecture-clean--feature-first)
7. [Exigence Technique 2 : Repository Pattern pour l'accès aux données](#-7-repository-pattern-pour-laccès-aux-données)
8. [Exigence Technique 3 : Dio pour les appels réseau](#-8-dio-pour-les-appels-réseau)
9. [Exigence Technique 4 : Intercepteur pour l'injection du token d'auth](#-9-intercepteur-pour-linjection-du-token-dauth)
10. [Exigence Technique 5 : Gestion du refresh token](#-10-gestion-du-refresh-token)
11. [Exigence Technique 6 : Au moins 3 tests unitaires sur la couche repository](#-11-au-moins-3-tests-unitaires-sur-la-couche-repository)
12. [Instructions de lancement et de reproduction](#-12-instructions-de-lancement-et-de-reproduction)

---

## 🔐 1. Authentification (login / register / logout) — JWT

L'authentification est entièrement fonctionnelle avec Supabase Auth (JWT), gère l'inscription, la connexion et la déconnexion avec persistance sécurisée des jetons d'accès.

### Fichier & Lignes :
- **Fichier** : `lib/features/auth/data/repositories/auth_repository_impl.dart`
- **Lignes** : `13 - 50`

```dart
// lib/features/auth/data/repositories/auth_repository_impl.dart (Lignes 13-50)
@override
Future<AuthResponseModel> login(String email, String password) async {
  final response = await remoteAuthDataSource.login(email, password);
  await secureStorage.saveTokens(
    accessToken: response.accessToken,
    refreshToken: response.refreshToken,
  );
  return response;
}

@override
Future<AuthResponseModel> register(String email, String password, String? username) async {
  final response = await remoteAuthDataSource.register(email, password, username);
  await secureStorage.saveTokens(
    accessToken: response.accessToken,
    refreshToken: response.refreshToken,
  );
  return response;
}

@override
Future<void> logout() async {
  try {
    await remoteAuthDataSource.logout();
  } catch (_) {
    // Nettoyage local garanti même en cas d'erreur serveur
  } finally {
    await secureStorage.clear();
  }
}
```

- **Déconnexion dans l'AppBar** : `lib/core/screens/homepage.dart` (Lignes `110-136`) : boîte de dialogue de confirmation appelant `authProvider.notifier.signOut()`.
- **Redirection automatique** : `lib/routing/routes.dart` (Lignes `27-38`) : redirection vers `/login` si non authentifié.

---

## 📱 2. Au moins 3 écrans de données issues d'une API REST

L'application intègre 3 écrans connectés en temps réel aux endpoints Supabase REST via Riverpod :

### Écran 1 : Page d'accueil (Catalogue Films et Personnalités)
- **Fichier** : `lib/core/screens/homepage.dart`
- **Lignes** : `79 - 224`
- **Endpoints REST** : `GET /rest/v1/films` & `GET /rest/v1/persons`
```dart
// lib/core/screens/homepage.dart (Lignes 79-81 & 153-178)
final allFilms = ref.watch(filmsProvider);
final allPersons = ref.watch(personsProvider);

// Affichage réactif avec .when(data, error, loading)
allFilms.when(
  data: (data) => ListView.separated(
    scrollDirection: Axis.horizontal,
    itemCount: data.length,
    itemBuilder: (context, index) => CardFilmWidget(film: data[index]),
  ),
  error: (error, _) => Center(child: Text("Error : $error")),
  loading: () => const Center(child: CircularProgressIndicator()),
);
```

### Écran 2 : Fiche détaillée d'un Film (Informations + Casting)
- **Fichier** : `lib/features/film/presentation/screens/specific_film_page.dart`
- **Lignes** : `16 - 208`
- **Endpoints REST** : `GET /rest/v1/films?id=eq.{id}` & `GET /rest/v1/credits?film_id=eq.{id}`
```dart
// lib/features/film/presentation/screens/specific_film_page.dart (Lignes 18-33)
final filmAsync = ref.watch(filmByIdProvider(filmId));
final creditsAsync = ref.watch(creditsByFilmIdProvider(filmId));

return Scaffold(
  body: filmAsync.when(
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (error, _) => Center(child: Text('Erreur : $error')),
    data: (film) => Stack(
      children: [
        CachedNetworkImage(imageUrl: film!.poster),
        // Informations détaillées + casting issu de creditsAsync
      ],
    ),
  ),
);
```

### Écran 3 : Fiche détaillée d'une Personnalité (Bio + Filmographie)
- **Fichier** : `lib/features/person/presentation/screens/specific_person.dart`
- **Lignes** : `22 - 283`
- **Endpoints REST** : `GET /rest/v1/persons?id=eq.{id}` & `GET /rest/v1/credits?person_id=eq.{id}`
```dart
// lib/features/person/presentation/screens/specific_person.dart (Lignes 24-40)
final personAsync = ref.watch(personByIdProvider(personId));
final creditsAsync = ref.watch(creditsByPersonIdProvider(personId));

return Scaffold(
  body: personAsync.when(
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (error, _) => Center(child: Text('Erreur : $error')),
    data: (person) => Stack(
      children: [
        // Photo, Nom, Date de naissance et liste des films participés
      ],
    ),
  ),
);
```

---

## 💾 3. Mise en cache locale des données (SQLite avec Drift)

La mise en cache utilise **Drift ORM (SQLite)** avec des tables strictement typées, des transactions batch et une base de données générée.

### Fichiers & Lignes :
- **Table Films SQLite** : `lib/core/database/tables/films_table.dart` (Lignes `3-14`)
```dart
class FilmsTable extends Table {
  IntColumn get id => integer()();
  TextColumn get title => text()();
  IntColumn get release => integer()();
  TextColumn get synopsis => text()();
  TextColumn get genre => text()();
  TextColumn get poster => text()();

  @override
  Set<Column> get primaryKey => {id};
}
```
- **Table Persons SQLite** : `lib/core/database/tables/persons_table.dart` (Lignes `3-12`)
- **Table Credits SQLite** : `lib/core/database/tables/credits_table.dart` (Lignes `3-12`)
- **Base de données Drift** : `lib/core/database/app_database.dart` (Lignes `13-29`)
```dart
@DriftDatabase(tables: [FilmsTable, PersonsTable, CreditsTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  @override
  int get schemaVersion => 1;
}
```
- **Sauvegarde et Lecture LocalDataSource** : `lib/features/film/data/data_sources/local_film_data_source.dart` (Lignes `18-68`) :
```dart
@override
Future<List<Film>> getAllFilms() async {
  final rows = await database.select(database.filmsTable).get();
  return rows.map((row) => Film(row.id, title: row.title, release: row.release, synopsis: row.synopsis, genre: row.genre, poster: row.poster)).toList();
}

@override
Future<void> saveFilms(List<Film> films) async {
  await database.batch((batch) {
    for (final film in films) {
      batch.insert(database.filmsTable, FilmsTableCompanion(...), mode: InsertMode.insertOrReplace);
    }
  });
}
```

---

## 📴 4. Mode hors-ligne (afficher les données cachées si pas de réseau)

L'application applique le pattern **Cache-Fallback (Offline-First)** : toute donnée reçue du réseau est persistée dans Drift SQLite. Si le réseau est indisponible, le repository bascule immédiatement sur les données locales SQLite.

### Fichiers & Lignes :
- **Stratégie Cache-Fallback dans le Repository** : `lib/features/film/data/repositories/film_repository_impl.dart` (Lignes `16-46`) :
```dart
// lib/features/film/data/repositories/film_repository_impl.dart (Lignes 16-29)
@override
Future<List<Film>> getAllFilm() async {
  try {
    final remoteFilms = await remoteFilmDataSource.getAllFilm();
    await localFilmDataSource.saveFilms(remoteFilms); // Sauvegarde automatique en SQLite
    return remoteFilms;
  } catch (_) {
    // Mode hors-ligne : si échec réseau, on retourne le cache local SQLite Drift
    final cachedFilms = await localFilmDataSource.getAllFilms();
    if (cachedFilms.isNotEmpty) {
      return cachedFilms;
    }
    rethrow;
  }
}
```
*(Même logique implémentée dans `PersonRepositoryImpl` lignes 19-49 et `CreditsRepositoryImpl` lignes 19-54).*

- **Détection de connectivité temps réel** : `lib/core/network/connectivity_provider.dart` (Lignes `10-21`) :
```dart
final isOnlineProvider = StreamProvider<bool>((ref) async* {
  final connectivity = ref.watch(connectivityProvider);
  final initialResults = await connectivity.checkConnectivity();
  yield initialResults.any((result) => result != ConnectivityResult.none);
  await for (final results in connectivity.onConnectivityChanged) {
    yield results.any((result) => result != ConnectivityResult.none);
  }
});
```

- **Bandeau visuel hors-ligne** : `lib/core/widgets/offline_banner_widget.dart` (Lignes `12-36`) :
Affiché en temps réel en haut de l'écran ([homepage.dart](file:///c:/dossier%20projects/flutter%20Projects/multi_screen_app_with_navigation/lib/core/screens/homepage.dart#L150), [specific_film_page.dart](file:///c:/dossier%20projects/flutter%20Projects/multi_screen_app_with_navigation/lib/features/film/presentation/screens/specific_film_page.dart#L207), [specific_person.dart](file:///c:/dossier%20projects/flutter%20Projects/multi_screen_app_with_navigation/lib/features/person/presentation/screens/specific_person.dart#L279)).

- **Synchronisation manuelle (Pull-to-refresh)** : `lib/core/screens/homepage.dart` (Lignes `139-145`) :
```dart
body: RefreshIndicator(
  onRefresh: () async {
    ref.invalidate(filmsProvider);
    ref.invalidate(personsProvider);
  },
  child: SingleChildScrollView(...),
)
```

---

## ⚠️ 5. Gestion d'erreurs réseau avec messages utilisateur

Toutes les exceptions `DioException` sont capturées et converties en exceptions métiers claires présentées à l'utilisateur.

### Fichiers & Lignes :
- **Définition des Exceptions** : `lib/core/network/error/exception.dart` (Lignes `2-54`)
```dart
sealed class AppException implements Exception {
  final String message;
  const AppException(this.message);
}
class NetworkException extends AppException {
  const NetworkException() : super('Vérifie ta connexion internet');
}
class TimeoutException extends AppException {
  const TimeoutException() : super('La connexion a expiré, réessaie');
}
```

- **Mapper d'erreur Dio** : `lib/core/network/error/dio_error_mapper.dart` (Lignes `5-49`)
```dart
AppException mapDioException(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.receiveTimeout:
      return const TimeoutException();
    case DioExceptionType.connectionError:
      return const NetworkException();
    case DioExceptionType.badResponse:
      if (status == 401) return const UnauthorizedException('Accès non autorisé');
      return const ServerException();
    default:
      return const UnknownException();
  }
}
```

---

## 🏛️ 6. Architecture Clean / Feature-First

Le code est rigoureusement séparé par fonctionnalité et par couche de responsabilité :

```
lib/
├── core/                                # Socle transverse
│   ├── database/                        # Drift ORM (SQLite) & Providers
│   ├── network/                         # Dio Client, Intercepteurs & Exceptions
│   └── widgets/                         # OfflineBannerWidget, etc.
└── features/                            # Feature-First Modules
    ├── auth/                            # Data (Remote) / Domain (Repo) / Presentation (Screens)
    ├── film/                            # Data (Remote + Drift) / Domain / Presentation (Riverpod)
    ├── person/                          # Data (Remote + Drift) / Domain / Presentation (Riverpod)
    └── credits/                         # Data (Remote + Drift) / Domain / Presentation (Riverpod)
```

---

## 📦 7. Repository Pattern pour l'accès aux données

Séparation stricte des contrats abstraits dans le `domain` et des implémentations concrètes dans la couche `data` :

- **Contrat Domain** : `lib/features/film/domain/repositories/film_repository.dart`
```dart
abstract class FilmRepository {
  Future<List<Film>> getAllFilm();
  Future<Film?> getFilmById(int id);
}
```
- **Implémentation Data** : `lib/features/film/data/repositories/film_repository_impl.dart` (injecte `RemoteFilmDataSource` et `LocalFilmDataSource`).
- Idem pour `PersonRepository` (`features/person/`) et `CreditsRepository` (`features/credits/`).

---

## 🌐 8. Dio pour les appels réseau

Le client réseau est instancié avec des configurations strictes de timeout et de headers.

### Fichier & Lignes :
- **Fichier** : `lib/core/network/dio_client.dart`
- **Lignes** : `28 - 40`
```dart
final dio = Dio(
  BaseOptions(
    baseUrl: Env.baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'apikey': Env.apiKey,
    },
  ),
);
```

---

## 🔑 9. Intercepteur pour l'injection du token d'auth

Toute requête sortante est interceptée pour y injecter le token JWT extrait du stockage chiffré.

### Fichier & Lignes :
- **Fichier** : `lib/core/network/dio_client.dart`
- **Lignes** : `41 - 49`
```dart
dio.interceptors.add(
  InterceptorsWrapper(
    onRequest: (options, handler) async {
      final token = await storage.accessToken;
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      return handler.next(options);
    },
...
```

---

## 🔄 10. Gestion du refresh token

En cas d'erreur HTTP 401 (`Unauthorized`), l'intercepteur tente automatiquement de renouveler le token via le refresh token et rejoue la requête initiale.

### Fichier & Lignes :
- **Fichier** : `lib/core/network/dio_client.dart`
- **Lignes** : `50 - 98`
```dart
onError: (error, handler) async {
  final isUnauthorized = error.response?.statusCode == 401;
  final alreadyRetried = error.requestOptions.extra['retried'] == true;

  if (isUnauthorized && !alreadyRetried) {
    final refreshToken = await storage.refreshToken;
    if (refreshToken == null) return handler.next(error);

    final response = await _refreshDio.post(
      '/auth/v1/token?grant_type=refresh_token',
      data: {'refresh_token': refreshToken},
    );

    final newAccessToken = response.data['access_token'] as String;
    final newRefreshToken = response.data['refresh_token'] as String;
    await storage.saveTokens(accessToken: newAccessToken, refreshToken: newRefreshToken);

    final retryOptions = error.requestOptions;
    retryOptions.headers['Authorization'] = 'Bearer $newAccessToken';
    retryOptions.extra['retried'] = true;
    final cloned = await _refreshDio.fetch(retryOptions);
    return handler.resolve(cloned);
  }
  return handler.next(error);
}
```

---

## 🧪 11. Au moins 3 tests unitaires sur la couche repository

La suite de tests unitaires valide exhaustivement la couche repository (**23 tests passés avec 100% de succès**).

### Fichiers & Lignes :
- **Tests FilmRepository** : `test/repository/film_repository_test.dart` (Lignes `89 - 175`)
  - Test 1 : Succès réseau -> écriture dans la BDD SQLite locale.
  - Test 2 : Échec réseau -> fallback automatique sur le cache SQLite Drift.
  - Test 3 : Échec réseau sans cache -> propagation de l'erreur réseau.
  - Test 4 : `getFilmById` en ligne -> mise en cache local.
  - Test 5 : `getFilmById` hors-ligne -> restitution depuis SQLite.
- **Tests PersonRepository** : `test/repository/person_repository_test.dart` (Lignes `79 - 157`)
  - Test 6 : Succès réseau et sauvegarde locale.
  - Test 7 : Mode hors-ligne et restitution depuis le cache.
  - Test 8 : Traduction DioException vers `NetworkException`.
  - Test 9 & 10 : `getPersonById` distant et hors-ligne.
- **Tests CreditsRepository** : `test/repository/credits_repository_test.dart` (Lignes `58 - 108`)
  - Test 11 : Enregistrement et restitution casting/filmographie avec Drift.

### Commande d'exécution :
```bash
flutter test test/repository/
```
**Résultat :**
```text
00:01 +23: All tests passed!
```

---

## 🚀 12. Instructions de lancement et de reproduction

```bash
# 1. Cloner le projet
git clone https://github.com/Don-SKRED/Projet-Flutter-App-multi--crans-avec-navigation.git
cd multi_screen_app_with_navigation

# 2. Installer les packages
flutter pub get

# 3. Lancer la génération de code Drift
dart run build_runner build --delete-conflicting-outputs --force-jit

# 4. Lancer les tests unitaires
flutter test test/repository/

# 5. Démarrer l'application
flutter run
```