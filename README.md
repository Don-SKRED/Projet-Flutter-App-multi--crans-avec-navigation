# 🎬 Multi-Screen CineApp — Application Flutter Full-Stack Connectée

[![Flutter](https://img.shields.io/badge/Flutter-3.10%2B-blue.svg)](https://flutter.dev)
[![State Management](https://img.shields.io/badge/State_Management-Riverpod_3-purple.svg)](https://riverpod.dev)
[![Database](https://img.shields.io/badge/Database-Drift_(SQLite)-green.svg)](https://drift.simonbinder.eu/)
[![Network](https://img.shields.io/badge/Network-Dio-orange.svg)](https://pub.dev/packages/dio)
[![Tests](https://img.shields.io/badge/Tests-27_Passed-brightgreen.svg)]()

Application mobile Flutter complète connectée à un backend réel (**Supabase REST API & Auth**), implémentant une architecture **Feature-First / Clean Architecture**, une gestion d'état réactive avec **Riverpod**, une persistance locale avec **Drift (SQLite)**, un mode hors-ligne avec cache-fallback automatique et une suite complète de tests unitaires sur la couche repository (27 tests passés avec 100% de succès).

---

## 📸 Galerie & Aperçu de l'Application

| 🏠 Accueil & Catalogue | 🎬 Fiche Film & Casting | 👤 Personnalité & Bio |
| :---: | :---: | :---: |
| ![Accueil](screenshot/homepage.png) | ![Détail film](screenshot/page%20film.png) | ![Fiche personnalité](screenshot/page%20personnalité.png) |

| 🔍 Recherche & Filtres | 📑 Liste Complète Films | 🎭 Liste Personnalités |
| :---: | :---: | :---: |
| ![Recherche](screenshot/page%20de%20recherche%20et%20flitrage.png) | ![Résultats films](screenshot/page%20de%20recherche%20et%20filitrage(affihcer%20plus%20de%20film).png) | ![Résultats personnalités](screenshot/page%20de%20recherche%20et%20filitrage(affihcer%20plus%20de%20personnalité).png) |

| ✍️ Formulaire d'Ajout |
| :---: |
| ![Formulaire d'ajout](screenshot/formulaire%20d'ajout%20de%20film.png) |

---

## 📋 Grille d'Évaluation & Preuves d'Implémentation (100 pts)

Chaque exigence du projet est détaillée ci-dessous avec : **le fichier source exact**, **les lignes de code correspondantes**, **l'aperçu du code source** et **la capture d'écran associée**.

| Exigence du Sujet | Fichier(s) Source | Lignes de Code | Statut |
| :--- | :--- | :---: | :---: |
| **1. Authentification (login/register/logout) — JWT** | `lib/features/auth/data/repositories/auth_repository_impl.dart`<br>`lib/features/auth/presentation/screens/login_screen.dart`<br>`lib/features/auth/presentation/screens/signup_screen.dart`<br>`lib/core/screens/homepage.dart` | `13 - 50`<br>écran complet<br>écran complet<br>`110 - 136` | ✅ Validé |
| **2. Au moins 3 écrans de données issues d'une API REST** | `lib/core/screens/homepage.dart`<br>`lib/features/film/presentation/screens/specific_film_page.dart`<br>`lib/features/person/presentation/screens/specific_person.dart` | `79 - 224`<br>`16 - 208`<br>`22 - 283` | ✅ Validé |
| **3. Mise en cache locale des données (SQLite)** | `lib/core/database/tables/films_table.dart`<br>`lib/core/database/app_database.dart`<br>`lib/features/film/data/data_sources/local_film_data_source.dart` | `3 - 14`<br>`13 - 29`<br>`18 - 68` | ✅ Validé |
| **4. Mode hors-ligne : afficher le cache si pas de réseau** | `lib/features/film/data/repositories/film_repository_impl.dart`<br>`lib/core/network/connectivity_provider.dart`<br>`lib/core/widgets/offline_banner_widget.dart` | `16 - 29`<br>`10 - 21`<br>`12 - 36` | ✅ Validé |
| **5. Gestion d'erreurs réseau avec messages utilisateur** | `lib/core/network/error/exception.dart`<br>`lib/core/network/error/dio_error_mapper.dart` | `2 - 54`<br>`5 - 49` | ✅ Validé |
| **6. Architecture Clean (data/domain/presentation)** | Structure `lib/core/` et `lib/features/` | Projet entier | ✅ Validé |
| **7. Repository Pattern pour l'accès aux données** | `lib/features/film/domain/repositories/film_repository.dart`<br>`lib/features/film/data/repositories/film_repository_impl.dart` | Contrat & Implémentation | ✅ Validé |
| **8. Dio pour les appels réseau** | `lib/core/network/dio_client.dart` | `28 - 40` | ✅ Validé |
| **9. Intercepteur pour l'injection du token d'auth** | `lib/core/network/dio_client.dart` | `41 - 49` | ✅ Validé |
| **10. Gestion du refresh token** | `lib/core/network/dio_client.dart` | `50 - 98` | ✅ Validé |
| **11. Au moins 3 tests unitaires sur le repository** | `test/features/film/data/repositories/film_repository_impl_test.dart`<br>`test/features/person/data/repositories/person_repository_impl_test.dart`<br>`test/features/credits/data/repositories/credits_repository_impl_test.dart`<br>`test/features/auth/data/repositories/auth_repository_impl_test.dart` | 27 tests validés (100% succès) | ✅ Validé |

---

## 🔐 1. Authentification (login / register / logout) — JWT

L'authentification est connectée à l'API Supabase Auth. Les jetons JWT (`access_token` et `refresh_token`) sont stockés de façon chiffrée avec `flutter_secure_storage`.

- **Fichier** : `lib/features/auth/data/repositories/auth_repository_impl.dart`
- **Lignes de code** : `13 - 50`

```dart
// lib/features/auth/data/repositories/auth_repository_impl.dart
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
    // Nettoyage local garanti même en cas d'indisponibilité du réseau
  } finally {
    await secureStorage.clear();
  }
}
```

- **Écran de connexion (UI)** : `lib/features/auth/presentation/screens/login_screen.dart` (179 lignes) — formulaire email/mot de passe validé (`Form` + `GlobalKey<FormState>`), bouton de connexion appelant `authProvider.notifier.login(...)`, lien vers l'inscription.
- **Écran d'inscription (UI)** : `lib/features/auth/presentation/screens/signup_screen.dart` (229 lignes) — formulaire email/mot de passe/pseudo, appel à `authProvider.notifier.signUp(...)` (ligne `58`).
- **Déconnexion sécurisée** : `lib/core/screens/homepage.dart` (Lignes `110-136`) : boîte de dialogue de confirmation appelant `authProvider.notifier.signOut()`.
- **Protection des routes** : `lib/routing/routes.dart` (Lignes `27-38`) : redirection automatique vers `/login`/`/signup` si aucun jeton valide n'est présent, et inversement vers `/` si déjà connecté.

---

## 📱 2. Au moins 3 écrans de données issues d'une API REST

Les données sont consommées depuis l'API REST réelle de Supabase via des `FutureProvider` Riverpod avec gestion d'état réactive (`.when()`). Le projet expose **3 écrans distincts**, chacun alimenté par un ou plusieurs endpoints REST, et couvre **3 entités de données** différentes (films, personnes, crédits — cette dernière n'ayant pas d'écran dédié mais étant affichée dans les écrans 2 et 3 ci-dessous) :

### Écran 1 : Page d'accueil (Films & Personnalités en direct)
- **Fichier** : `lib/core/screens/homepage.dart`
- **Lignes de code** : `79 - 224`
- **Endpoints REST** : `GET /rest/v1/films` & `GET /rest/v1/persons`
- **Aperçu visuel** :

![Écran 1 - Accueil](screenshot/homepage.png)

```dart
// lib/core/screens/homepage.dart (Lignes 79-81 & 153-178)
final allFilms = ref.watch(filmsProvider);
final allPersons = ref.watch(personsProvider);

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

---

### Écran 2 : Fiche détaillée d'un Film (Infos + Casting)
- **Fichier** : `lib/features/film/presentation/screens/specific_film_page.dart`
- **Lignes de code** : `16 - 208`
- **Endpoints REST** : `GET /rest/v1/films?id=eq.{id}` & `GET /rest/v1/credits?film_id=eq.{id}`
- **Aperçu visuel** :

![Écran 2 - Détail Film](screenshot/page%20film.png)

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
        // Détails du film et casting réactif via creditsAsync
      ],
    ),
  ),
);
```

---

### Écran 3 : Fiche détaillée d'une Personnalité (Bio + Filmographie)
- **Fichier** : `lib/features/person/presentation/screens/specific_person.dart`
- **Lignes de code** : `22 - 283`
- **Endpoints REST** : `GET /rest/v1/persons?id=eq.{id}` & `GET /rest/v1/credits?person_id=eq.{id}`
- **Aperçu visuel** :

![Écran 3 - Fiche Personnalité](screenshot/page%20personnalité.png)

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
        // Bio, photo de profil et filmographie via creditsAsync
      ],
    ),
  ),
);
```

---

## 💾 3. Mise en cache locale des données (SQLite avec Drift)

La persistance locale est assurée par un ORM SQLite moderne et typé : **Drift**.

- **Tables Drift typées** :
  - `lib/core/database/tables/films_table.dart` (Lignes `3 - 14`) : Table SQLite `FilmsTable` (`id`, `title`, `release`, `synopsis`, `genre`, `poster`).
  - `lib/core/database/tables/persons_table.dart` (Lignes `3 - 12`) : Table SQLite `PersonsTable` (`id`, `name`, `birthday`, `gender`, `face`).
  - `lib/core/database/tables/credits_table.dart` (Lignes `3 - 12`) : Table SQLite `CreditsTable` (`id`, `filmId`, `personId`, `role`, `personnage`).
- **Base de données SQLite typée** : `lib/core/database/app_database.dart` (Lignes `13 - 29`)
```dart
@DriftDatabase(tables: [FilmsTable, PersonsTable, CreditsTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  @override
  int get schemaVersion => 1;
}
```
- **Opérations CRUD et Batch dans la LocalDataSource** : `lib/features/film/data/data_sources/local_film_data_source.dart` (Lignes `18 - 68`)
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

L'application implémente le pattern **Cache-Fallback** : en ligne, elle synchronise les données distantes dans la base SQLite locale Drift ; en cas de panne réseau ou de mode avion, elle restitue immédiatement les données en cache.

- **Stratégie Cache-Fallback dans le Repository** : `lib/features/film/data/repositories/film_repository_impl.dart` (Lignes `16 - 29`)
```dart
@override
Future<List<Film>> getAllFilm() async {
  try {
    final remoteFilms = await remoteFilmDataSource.getAllFilm();
    await localFilmDataSource.saveFilms(remoteFilms); // Enregistrement SQLite Drift
    return remoteFilms;
  } catch (_) {
    // Mode hors-ligne : lecture depuis le cache SQLite Drift
    final cachedFilms = await localFilmDataSource.getAllFilms();
    if (cachedFilms.isNotEmpty) {
      return cachedFilms;
    }
    rethrow;
  }
}
```
*(Implémentation identique dans `PersonRepositoryImpl` lignes 19-49 et `CreditsRepositoryImpl` lignes 19-54).*

- **Détection de connectivité temps réel** : `lib/core/network/connectivity_provider.dart` (Lignes `10 - 21`)
- **Indicateur visuel hors-ligne** : `lib/core/widgets/offline_banner_widget.dart` (Lignes `12 - 36`) affiché en haut de l'écran lors d'une déconnexion.
- **Pull-to-refresh pour resynchroniser** : `lib/core/screens/homepage.dart` (Lignes `139 - 145`).

---

## ⚠️ 5. Gestion d'erreurs réseau avec messages utilisateur

Toutes les erreurs réseau Dio sont interceptées et mappées vers des exceptions compréhensibles pour l'utilisateur.

- **Exceptions typées** : `lib/core/network/error/exception.dart` (Lignes `2 - 54`)
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
- **Mapper Dio** : `lib/core/network/error/dio_error_mapper.dart` (Lignes `5 - 49`)
- **Affichage dans l'UI** : `.when(error: (e, _) => Center(child: Text(...)))` sur chaque écran.

---

## 🏛️ 6. Architecture Clean / Feature-First

Organisation stricte du projet en modules indépendants avec séparation par couches :

```
lib/
├── core/                                # Socle applicatif transverse
│   ├── database/                        # BDD Drift (SQLite), tables et code généré
│   ├── network/                         # Client Dio, Intercepteurs JWT & Exceptions
│   └── widgets/                         # OfflineBannerWidget, widgets partagés
│
├── features/                            # Modules métiers (Feature-First)
│   ├── auth/                            # Data (Remote) / Domain (Repo) / Presentation (Screens)
│   ├── film/                            # Data (Remote + Drift) / Domain / Presentation (Riverpod)
│   ├── person/                          # Data (Remote + Drift) / Domain / Presentation (Riverpod)
│   └── credits/                         # Data (Remote + Drift) / Domain / Presentation (Riverpod)
│
└── routing/
    └── routes.dart                      # Navigation GoRouter avec redirection Auth
```

---

## 📦 7. Repository Pattern pour l'accès aux données

Séparation stricte entre les contrats abstraits (`domain`) et les implémentations concrètes (`data`) :

- **Contrat Domain** : `lib/features/film/domain/repositories/film_repository.dart`
```dart
abstract class FilmRepository {
  Future<List<Film>> getAllFilm();
  Future<Film?> getFilmById(int id);
}
```
- **Implémentation Data** : `lib/features/film/data/repositories/film_repository_impl.dart` (coordonne `RemoteFilmDataSource` et `LocalFilmDataSource`).
- Idem pour `PersonRepository` (`features/person/`) et `CreditsRepository` (`features/credits/`).

---

## 🌐 8. Dio pour les appels réseau

- **Fichier** : `lib/core/network/dio_client.dart`
- **Lignes de code** : `28 - 40`
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

- **Fichier** : `lib/core/network/dio_client.dart`
- **Lignes de code** : `41 - 49`
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

- **Fichier** : `lib/core/network/dio_client.dart`
- **Lignes de code** : `50 - 98`
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

La suite de tests unitaires respecte **rigoureusement la même arborescence que `lib/`** (structure miroir Feature-First) et valide la couche Repository avec **27 tests passés avec 100% de succès** :

- **`test/features/film/data/repositories/film_repository_impl_test.dart`** :
  - ✅ Succès réseau : chargement et écriture dans la base SQLite locale Drift.
  - ✅ Mode hors-ligne : renvoi des films du cache SQLite lors d'une coupure réseau.
  - ✅ Échec réseau sans cache local : propagation de l'erreur réseau.
  - ✅ `getFilmById` distant et mise en cache SQLite.
  - ✅ `getFilmById` hors-ligne depuis SQLite.
- **`test/features/person/data/repositories/person_repository_impl_test.dart`** :
  - ✅ Récupération et persistance locale des personnalités dans Drift.
  - ✅ Fallback automatique sur le cache hors-ligne SQLite.
  - ✅ Traduction des erreurs réseau en `NetworkException`.
  - ✅ `getPersonById` distant et hors-ligne.
- **`test/features/credits/data/repositories/credits_repository_impl_test.dart`** :
  - ✅ Synchronisation des crédits (casting et filmographie) vers SQLite Drift.
  - ✅ Restitution du casting en mode hors-ligne.
  - ✅ Gestion des erreurs sans cache.
- **`test/features/auth/data/repositories/auth_repository_impl_test.dart`** :
  - ✅ Login : délégation distante et persistance des jetons dans SecureStorage.
  - ✅ Register : création de compte et sauvegarde des jetons.
  - ✅ Logout : nettoyage impératif des tokens même en cas d'erreur serveur.
  - ✅ `restoreSession` : restauration de session active si jeton présent.
- **`test/core/network/error/dio_error_mapper_test.dart`** :
  - ✅ Traduction des erreurs réseau Dio en exceptions métiers (`NetworkException`, `TimeoutException`, `UnauthorizedException`, etc.).

### Exécuter les tests :
```bash
flutter test test/features/ test/core/
```
**Résultat :**
```text
00:15 +27: All tests passed!
```

---

## 🚀 12. Instructions d'installation et de lancement

```bash
# 1. Cloner le projet et se placer sur la branche de développement
git clone https://github.com/Don-SKRED/Projet-Flutter-App-multi--crans-avec-navigation.git
cd Projet-Flutter-App-multi--crans-avec-navigation
git checkout feature/film

# 2. Installer les dépendances
flutter pub get

# 3. Configurer les variables d'environnement (backend Supabase)
cp .env.exemple .env
# Puis éditer .env et renseigner tes propres identifiants Supabase :
#   SUPABASE_URL=https://<ton-projet>.supabase.co
#   SUPABASE_ANON_KEY=<ta clé anon publique>
# (Dashboard Supabase → Project Settings → API)

# 4. Lancer la génération de code Drift (SQLite)
dart run build_runner build --delete-conflicting-outputs --force-jit

# 5. Lancer les tests unitaires du repository
flutter test test/features/ test/core/

# 6. Démarrer l'application
flutter run
```

### ⚙️ Configuration du backend Supabase

L'application s'appuie sur les tables Supabase suivantes (schéma REST + Auth) :

| Table | Description |
| :--- | :--- |
| `films` | Catalogue des films (titre, synopsis, genre, année, poster) |
| `persons` | Acteurs / réalisateurs (nom, date de naissance, genre, photo) |
| `credits` | Table de liaison film ↔ personne (rôle dans le casting) |

L'authentification (login/register/logout, JWT, refresh token) utilise directement **Supabase Auth**, aucune table custom n'est nécessaire pour les utilisateurs.

---

## 🗺️ Axes d'amélioration connus

- **Tests widgets sur les écrans d'authentification** : `LoginScreen` et `SignupScreen` ne sont couverts que manuellement pour le moment ; les 27 tests automatisés portent sur les couches repository, le mapper d'erreurs et quelques widgets partagés (`CardFilmWidget`, `SearchResultSection`), mais pas encore sur les formulaires d'auth eux-mêmes.
- **Extraction du refresh token** : la logique de refresh dans `DioClient.onError` pourrait être isolée dans une classe dédiée (ex. `AuthInterceptor`) pour améliorer la lisibilité.
- **Pipeline CI/CD** : non requis par le sujet, mais l'ajout d'un workflow GitHub Actions (`flutter analyze` + `flutter test`) sécuriserait les prochaines évolutions.

---

## 👤 Auteur

Projet réalisé par **Don-SKRED** dans le cadre de la certification Full-Stack Flutter.
