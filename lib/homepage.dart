import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_screen_app_with_navigation/features/film/application/services/film_service.dart';
import 'package:multi_screen_app_with_navigation/features/film/domain/film_model.dart';

import 'package:multi_screen_app_with_navigation/features/film/presentation/widget/card_film_widget.dart';
import 'package:multi_screen_app_with_navigation/features/person/application/service/person_service.dart';
import 'package:multi_screen_app_with_navigation/features/person/presentation/widgets/card_person_widget.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final filmService = FilmService();
  final personService = PersonService();
  final String titleAppBar = "Film page";
  final String titre1 = "Film";
  final String titre2 = "Personnalité";
  List<Film> listFilm = [];
  @override
  void initState() {
    super.initState();
    _loadData(); // On appelle la méthode asynchrone sans "await" ici
  }

  Future<void> _loadData() async {
    final value = await filmService
        .readFile(); // Utilisation autorisée du "await" ici
    setState(() {
      listFilm = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          context.push("film/new");
        },
      ),
      appBar: AppBar(
        title: Text(titleAppBar),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: MySearchDelegate(listFilm: listFilm),
              );
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                titre1,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 238, 238, 238),
              ),
              height: 400,
              child: FutureBuilder(
                future: filmService.readFile(),
                builder: (context, asyncSnapshot) {
                  if (asyncSnapshot.hasData) {
                    final data = asyncSnapshot.data!;
                    return ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () => context.push(
                            "film/${data[index].id}",
                            extra: filmService,
                          ),
                          child: CardFilmWidget(film: data[index]),
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 50),
                      itemCount: 4,
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                titre2,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),

            FutureBuilder(
              future: personService.readFile(),
              builder: (context, asyncSnapshot) {
                if (asyncSnapshot.hasData) {
                  final data = asyncSnapshot.data!;
                  return SizedBox(
                    height: 100,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () => context.push(
                            "person/${data[index].id}",
                            // extra: personService,
                          ),
                          child: CardPersonWidget(person: data[index]),
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 50),
                      itemCount: 4,
                    ),
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MySearchDelegate extends SearchDelegate {
  final List<Film> listFilm;
  MySearchDelegate({required this.listFilm});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          if (query.isEmpty) {
            close(context, null); // Ferme la recherche si le champ est vide
          } else {
            query = ''; // Efface le texte tapé
          }
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null); // Retour en arrière
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  // Affiche les résultats finaux une fois la recherche validée (Touche Entrée)
  @override
  Widget buildResults(BuildContext context) {
    final results = listFilm
        .where((film) => film.title.toLowerCase().contains(query.toLowerCase()))
        .toList();

    if (results.isEmpty) {
      return const Center(child: Text("Aucun film trouvé"));
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final film = results[index];
        return CardFilm(film: film);
      },
    );
  }

  // Filtre et affiche les suggestions en temps réel pendant la saisie
  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = listFilm
        .where((film) => film.title.toLowerCase().contains(query.toLowerCase()))
        .toList();

    if (suggestions.isEmpty) {
      return const Center(child: Text("Aucune suggestion"));
    }

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final film = suggestions[index];
        return CardFilm(film: film);
      },
    );
  }
}

class CardFilm extends StatelessWidget {
  final Film film;
  const CardFilm({super.key, required this.film});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(
        Icons.movie,
      ), // Remplace le Placeholder par une icône plus propre
      title: Text(film.title),
      subtitle: Text(film.genre),
      onTap: () {
        // Redirige vers la page de détails du film cliqué
        context.push("film/${film.id}");
      },
    );
  }
}
