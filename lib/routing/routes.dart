import 'package:go_router/go_router.dart';
import 'package:multi_screen_app_with_navigation/features/film/application/services/film_service.dart';
import 'package:multi_screen_app_with_navigation/features/film/domain/film_model.dart';
import 'package:multi_screen_app_with_navigation/features/film/presentation/screens/film_form.dart';
import 'package:multi_screen_app_with_navigation/features/person/application/service/person_service.dart';
import 'package:multi_screen_app_with_navigation/features/person/domain/person_model.dart';
import 'package:multi_screen_app_with_navigation/features/person/presentation/screens/specific_person.dart';
import 'package:multi_screen_app_with_navigation/features/film/presentation/screens/specific_film_page.dart';
import 'package:multi_screen_app_with_navigation/shared/screens/homepage.dart';
import 'package:multi_screen_app_with_navigation/shared/screens/result_search_film.dart';
import 'package:multi_screen_app_with_navigation/shared/screens/result_search_person.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
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
