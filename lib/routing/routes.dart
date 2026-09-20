import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_screen_app_with_navigation/core/router/go_router_refresh_notifier.dart';
import 'package:multi_screen_app_with_navigation/core/screens/homepage.dart';
import 'package:multi_screen_app_with_navigation/core/screens/result_search_film.dart';
import 'package:multi_screen_app_with_navigation/core/screens/result_search_person.dart';
import 'package:multi_screen_app_with_navigation/features/auth/presentation/provider/auth_provider.dart';
import 'package:multi_screen_app_with_navigation/features/auth/presentation/screens/login_screen.dart';
import 'package:multi_screen_app_with_navigation/features/auth/presentation/screens/signup_screen.dart';
import 'package:multi_screen_app_with_navigation/features/film/application/services/film_service.dart';
import 'package:multi_screen_app_with_navigation/features/film/data/model/film_model.dart';
import 'package:multi_screen_app_with_navigation/features/film/presentation/screens/film_form.dart';
import 'package:multi_screen_app_with_navigation/features/film/presentation/screens/specific_film_page.dart';
import 'package:multi_screen_app_with_navigation/features/person/application/service/person_service.dart';
import 'package:multi_screen_app_with_navigation/features/person/domain/person_model.dart';
import 'package:multi_screen_app_with_navigation/features/person/presentation/screens/specific_person.dart';
// ... tes autres imports de screens inchangés

final goRouterRefreshNotifierProvider = Provider<GoRouterRefreshNotifier>((
  ref,
) {
  return GoRouterRefreshNotifier(ref);
});

final goRouterProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = ref.watch(goRouterRefreshNotifierProvider);

  return GoRouter(
    initialLocation: '/',
    refreshListenable:
        refreshNotifier, // ← re-vérifie le redirect à chaque changement d'auth

    redirect: (context, state) {
      final authState = ref.read(authProvider);
      final isLoggedIn = authState.value != null;
      final isOnAuthPage =
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/signup';

      // Pendant la toute première vérification (restauration de session
      // au démarrage), on ne redirige pas encore pour éviter un flash
      // vers /login puis retour vers / une fraction de seconde après.
      if (authState.isLoading && !authState.hasValue) return null;

      if (!isLoggedIn && !isOnAuthPage) return '/login';
      if (isLoggedIn && isOnAuthPage) return '/';
      return null;
    },

    routes: [
      GoRoute(path: "/login", builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: "/signup",
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(path: "/", builder: (context, state) => const Homepage()),
      GoRoute(
        path: "/film/new",
        builder: (context, state) {
          return const FilmForm();
        },
      ),
      GoRoute(
        path: "/film/:id",
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          final filmService = (state.extra as FilmService?) ?? FilmService();
          return SpecificFilmPage(
            filmId: int.parse(id),
            filmService: filmService,
          );
        },
      ),
      GoRoute(
        path: "/person/:id",
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          final personService =
              (state.extra as PersonService?) ?? PersonService();
          return SpecificPerson(
            personId: int.parse(id),
            personService: personService,
          );
        },
      ),
      GoRoute(
        path: "/search/film",
        builder: (context, state) {
          final query = state.uri.queryParameters['q'] ?? '';
          final listfilm = state.extra as List<Film>;
          return ResultSearchFilm(query: query, listFilmSearch: listfilm);
        },
      ),
      GoRoute(
        path: "/search/person",
        builder: (context, state) {
          final query = state.uri.queryParameters['q'] ?? '';
          final listPerson = state.extra as List<Person>;
          return ResultSearchPerson(query: query, listPerson: listPerson);
        },
      ),
    ],
  );
});
