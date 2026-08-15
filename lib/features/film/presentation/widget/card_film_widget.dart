import 'package:flutter/material.dart';
import 'package:multi_screen_app_with_navigation/features/film/domain/film_model.dart';
import 'package:multi_screen_app_with_navigation/shared/utils/responsive.dart';

class CardFilmWidget extends StatelessWidget {
  final Film film;
  const CardFilmWidget({super.key, required this.film});

  @override
  Widget build(BuildContext context) {
    final cardWidth = context.filmCardWidth;
    final cardHeight = context.filmCardHeight;

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SizedBox(
        width: cardWidth,
        height: cardHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image/Placeholder
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: const Icon(Icons.movie, color: Colors.white, size: 40),
              ),
            ),
            // Titre du film
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.all(context.paddingH),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Center(
                        child: Text(
                          film.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
