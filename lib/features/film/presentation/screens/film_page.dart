import 'package:flutter/material.dart';

/// Écran formulaire, utilisé à la fois pour l'ajout (filmId == null)
/// et l'édition (filmId renseigné). 5 champs validés : titre, année,
/// durée, genre, synopsis (+ une note via Slider).
class FilmFormScreen extends StatefulWidget {
  final String? filmId;

  const FilmFormScreen({super.key, this.filmId});

  @override
  State<FilmFormScreen> createState() => _FilmFormScreenState();
}

class _FilmFormScreenState extends State<FilmFormScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _titreController = TextEditingController();
  late TextEditingController _anneeController = TextEditingController();
  late TextEditingController _dureeController = TextEditingController();
  late TextEditingController _synopsisController = TextEditingController();
  String _genre = 'Drame';
  double _note = 3.0;

  static const _genresDisponibles = [
    'Drame',
    'Comédie',
    'Science-fiction',
    'Thriller',
    'Aventure',
    'Romance',
  ];

  bool get isEdition => widget.filmId != null;

  @override
  void initState() {
    super.initState();
    // final repository = context.read<FilmRepository>();
    // final film = isEdition ? repository.getFilmById(widget.filmId!) : null;

    // _titreController = TextEditingController(text: film?.titre ?? '');
    // _anneeController =
    //     TextEditingController(text: film?.annee.toString() ?? '');
    // _dureeController =
    //     TextEditingController(text: film?.dureeMinutes.toString() ?? '');
    // _synopsisController = TextEditingController(text: film?.synopsis ?? '');
    // _genre = film?.genre ?? _genresDisponibles.first;
    // _note = film?.note ?? 3.0;
  }

  @override
  void dispose() {
    _titreController.dispose();
    _anneeController.dispose();
    _dureeController.dispose();
    _synopsisController.dispose();
    super.dispose();
  }

  void _submit() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdition ? 'Modifier le film' : 'Ajouter un film'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titreController,
              decoration: const InputDecoration(
                labelText: 'Titre',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Le titre est obligatoire';
                }
                if (value.trim().length < 2) {
                  return 'Le titre est trop court';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _anneeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Année de sortie',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                final annee = int.tryParse(value ?? '');
                if (annee == null) return 'Entrez une année valide';
                if (annee < 1900 || annee > 2100) {
                  return 'Année hors limites (1900-2100)';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _dureeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Durée (minutes)',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                final duree = int.tryParse(value ?? '');
                if (duree == null) return 'Entrez une durée valide';
                if (duree <= 0 || duree > 600) return 'Durée invalide';
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _genre,
              decoration: const InputDecoration(
                labelText: 'Genre',
                border: OutlineInputBorder(),
              ),
              items: _genresDisponibles
                  .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                  .toList(),
              onChanged: (value) => setState(() => _genre = value!),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _synopsisController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Synopsis',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              validator: (value) {
                if (value == null || value.trim().length < 10) {
                  return 'Le synopsis doit contenir au moins 10 caractères';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Text('Note : ${_note.toStringAsFixed(1)} / 5'),
            Slider(
              value: _note,
              min: 0,
              max: 5,
              divisions: 10,
              label: _note.toStringAsFixed(1),
              onChanged: (value) => setState(() => _note = value),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.save),
              label: Text(isEdition ? 'Enregistrer' : 'Ajouter le film'),
            ),
          ],
        ),
      ),
    );
  }
}
