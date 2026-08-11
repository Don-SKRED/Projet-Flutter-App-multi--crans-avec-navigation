import 'package:flutter/material.dart';
import 'package:multi_screen_app_with_navigation/features/film/domain/film_model.dart';

class CardFilmWidget extends StatelessWidget {
  final Film film;
  const CardFilmWidget({super.key, required this.film});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Column(
        children: [
          Expanded(
            child: Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
            ),
          ),
          SizedBox(height: 50, child: Text(film.title)),
        ],
      ),
    );
  }
}
