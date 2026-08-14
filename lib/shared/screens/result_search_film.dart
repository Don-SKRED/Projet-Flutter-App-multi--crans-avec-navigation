import 'package:flutter/material.dart';
import 'package:multi_screen_app_with_navigation/features/film/domain/film_model.dart';
import 'package:multi_screen_app_with_navigation/shared/screens/homepage.dart';

class ResultSearchFilm extends StatefulWidget {
  final String query;
  final List<Film> listFilmSearch;
  const ResultSearchFilm({
    super.key,
    required this.query,
    required this.listFilmSearch,
  });

  @override
  State<ResultSearchFilm> createState() => _ResultSearchFilmState();
}

class _ResultSearchFilmState extends State<ResultSearchFilm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(children: [Text("Film"), Text(widget.query)]),
      ),
      body: ListView.builder(
        itemCount: widget.listFilmSearch.length,
        itemBuilder: (context, index) {
          return CardFilm(film: widget.listFilmSearch[index]);
        },
      ),
    );
  }
}
