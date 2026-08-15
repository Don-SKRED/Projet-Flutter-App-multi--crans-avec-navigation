import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_screen_app_with_navigation/features/film/application/services/film_service.dart';
import 'package:multi_screen_app_with_navigation/features/film/domain/film_model.dart';

class FilmForm extends StatefulWidget {
  const FilmForm({super.key});

  @override
  State<FilmForm> createState() => _FilmFormState();
}

class _FilmFormState extends State<FilmForm> {
  String titleAppBar = "Ajouter un film";
  static const _genresDisponibles = [
    'Drame',
    'Comédie',
    'Science-fiction',
    'Thriller',
    'Aventure',
    'Romance',
  ];
  var formKey = GlobalKey<FormState>();
  FilmService filmService = FilmService();
  String? titleValue;
  String? synopsisValue;
  String? releaseValue;
  String? genreValue;
  String? posterValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(titleAppBar)),
      body: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              spacing: 20,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    label: Text("Titre"),
                    border: OutlineInputBorder(borderSide: BorderSide()),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? "Veuillez remplir ce champ" : null,
                  onSaved: (newValue) => setState(() {
                    titleValue = newValue;
                  }),
                ),

                TextFormField(
                  maxLines: 5,
                  decoration: InputDecoration(
                    label: Text("Synopsis"),
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(borderSide: BorderSide()),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? "Veuillez remplir ce champ" : null,
                  onSaved: (newValue) => setState(() {
                    synopsisValue = newValue;
                  }),
                ),

                DropdownButtonFormField(
                  decoration: InputDecoration(
                    label: Text("Genre"),
                    border: OutlineInputBorder(),
                  ),
                  initialValue: _genresDisponibles[0],
                  items: _genresDisponibles
                      .map(
                        (element) => DropdownMenuItem(
                          value: element,
                          child: Text(element),
                        ),
                      )
                      .toList(),
                  onChanged: (value) => setState(() {
                    genreValue = value;
                  }),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    label: Text("Année de sortie"),
                    border: OutlineInputBorder(borderSide: BorderSide()),
                  ),
                  validator: (value) {
                    final annee = int.tryParse(value ?? '');
                    if (annee == null) return 'Entrez une année valide';
                    if (annee < 1900 || annee > 2100) {
                      return 'Année hors limites (1900-2100)';
                    }
                    return null;
                  },
                  onSaved: (newValue) => setState(() {
                    releaseValue = newValue;
                  }),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    label: Text("Poster"),
                    border: OutlineInputBorder(borderSide: BorderSide()),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? "Veuillez remplir ce champ" : null,
                  onSaved: (newValue) => setState(() {
                    posterValue = newValue;
                  }),
                ),

                SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        int newId = await filmService.generateNewId();
                        Film film = Film(
                          newId,
                          title: titleValue!,
                          release: int.parse(
                            releaseValue!,
                          ), // Assurez-vous d'avoir releaseValue
                          synopsis: synopsisValue!,
                          genre: genreValue!,
                          poster: posterValue ?? "default_poster.jpg",
                        );
                        await filmService.add(film);
                        if (context.mounted) context.pop();
                      }
                    },
                    child: Text("Ajouter"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
