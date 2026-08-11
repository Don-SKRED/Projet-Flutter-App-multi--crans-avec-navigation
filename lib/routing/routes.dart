import 'package:go_router/go_router.dart';
import 'package:multi_screen_app_with_navigation/features/credits/application/service/credits_service.dart';
import 'package:multi_screen_app_with_navigation/features/film/application/services/film_service.dart';
import 'package:multi_screen_app_with_navigation/features/film/presentation/screens/film_form.dart';
import 'package:multi_screen_app_with_navigation/features/person/application/service/person_service.dart';
import 'package:multi_screen_app_with_navigation/features/person/presentation/screens/specific_person.dart';
import 'package:multi_screen_app_with_navigation/features/film/presentation/screens/film_page.dart';
import 'package:multi_screen_app_with_navigation/features/film/presentation/screens/specific_film_page.dart';
import 'package:multi_screen_app_with_navigation/homepage.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: "/", builder: (context, state) => const Homepage()),
    GoRoute(path: "/film", builder: (context, state) => const FilmFormScreen()),
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
        // final creditService =
        //     (state.extra as CreditsService?) ?? CreditsService();
        return SpecificPerson(
          personId: int.parse(id),
          // creditsService: creditService,
        );
      },
    ),
  ],
);
