import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_screen_app_with_navigation/core/utils/responsive.dart';
import 'package:multi_screen_app_with_navigation/features/film/data/model/film_model.dart';
import 'package:multi_screen_app_with_navigation/features/film/presentation/providers/film_provider.dart';

class FilmForm extends ConsumerStatefulWidget {
  const FilmForm({super.key});

  @override
  ConsumerState<FilmForm> createState() => _FilmFormState();
}

class _FilmFormState extends ConsumerState<FilmForm> {
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
  String? titleValue;
  String? synopsisValue;
  String? releaseValue;
  String? genreValue;
  String? posterValue;
  bool _isLoading = false;

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
                  keyboardType: TextInputType.number,
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
                  width: context.screenWidth,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () async {
                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();
                              setState(() => _isLoading = true);
                              try {
                                final newId = await ref.read(
                                  nextFilmIdProvider.future,
                                );
                                final film = Film(
                                  newId,
                                  title: titleValue!,
                                  release: int.parse(releaseValue!),
                                  synopsis: synopsisValue!,
                                  genre: genreValue ?? _genresDisponibles[0],
                                  poster: posterValue ?? "default_poster.jpg",
                                );
                                await ref.read(addFilmProvider)(film);
                                if (context.mounted) context.pop();
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Erreur : $e'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              } finally {
                                if (mounted) setState(() => _isLoading = false);
                              }
                            }
                          },
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text("Ajouter"),
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
