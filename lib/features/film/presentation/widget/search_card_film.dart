import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_screen_app_with_navigation/features/film/domain/film_model.dart';

class CardFilm extends StatelessWidget {
  final Film film;
  const CardFilm({super.key, required this.film});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.movie),
      title: Text(film.title),
      subtitle: Text(film.genre),
      onTap: () => context.push("film/${film.id}"),
    );
  }
}
