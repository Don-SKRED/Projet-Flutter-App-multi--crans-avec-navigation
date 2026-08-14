import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_screen_app_with_navigation/features/film/application/services/film_service.dart';
import 'package:multi_screen_app_with_navigation/features/film/domain/film_model.dart';

import 'package:multi_screen_app_with_navigation/features/film/presentation/widget/card_film_widget.dart';
import 'package:multi_screen_app_with_navigation/features/person/application/service/person_service.dart';
import 'package:multi_screen_app_with_navigation/features/person/domain/person_model.dart';
import 'package:multi_screen_app_with_navigation/features/person/presentation/widgets/card_person_widget.dart';
import 'package:multi_screen_app_with_navigation/shared/services/theme_provider.dart';

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

  late Future<List<Film>> _filmsFuture;
  late Future<List<Person>> _personsFuture;
  List<Film> listFilm = [];
  List<Person> listPerson = [];
  ThemeProvider themeProvider = ThemeProvider();
  @override
  void initState() {
    super.initState();
    _filmsFuture = filmService.readFile();
    _personsFuture = personService.readFile();
    _loadData();

    ThemeProvider().readFile();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future<void> _loadData() async {
    final value = await filmService.readFile();
    final valuePerson = await personService.readFile();
    setState(() {
      listFilm = value;
      listPerson = valuePerson;
    });
  }

  void _rafraichirFilms() {
    setState(() {
      _filmsFuture = filmService.readFile(); // on recrée le Future à la demande
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await context.push("film/new");
          _rafraichirFilms();
        },
      ),
      appBar: AppBar(
        title: Text(titleAppBar),
        actions: [
          IconButton(onPressed: null, icon: Icon(Icons.dark_mode)),
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: MySearchDelegate(
                  listFilm: listFilm,
                  listPerson: listPerson,
                ),
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
              decoration: BoxDecoration(color: Colors.deepPurple),
              height: 400,
              child: FutureBuilder(
                future: _filmsFuture,
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
              future: _personsFuture,
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
                      itemCount: data.length,
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
  final List<Person> listPerson;
  MySearchDelegate({required this.listFilm, required this.listPerson});

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
    final resultsFilm = listFilm
        .where(
          (film) =>
              film.title.toLowerCase().contains(query.toLowerCase()) &&
              query != '',
        )
        .toList();
    final resultsPerson = listPerson
        .where(
          (person) =>
              person.name.toLowerCase().contains(query.toLowerCase()) &&
              query != '',
        )
        .toList();

    if (resultsFilm.isEmpty && resultsPerson.isEmpty) {
      return const Center(child: Text("Aucun résultats trouvé"));
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (resultsFilm.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 30.0, bottom: 5),
              child: Text(
                "Film(${resultsFilm.length})",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 9.0, bottom: 25),
            child: (resultsFilm.isNotEmpty)
                ? Container(
                    // height: 400,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          // height: 300,
                          child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: (resultsFilm.length > 4)
                                ? 4
                                : resultsFilm.length,
                            itemBuilder: (context, index) {
                              final film = resultsFilm[index];
                              return CardFilm(film: film);
                            },
                          ),
                        ),
                        (resultsFilm.length > 4)
                            ? Divider()
                            : SizedBox.shrink(),
                        (resultsFilm.length > 4)
                            ? TextButton(
                                onPressed: () {
                                  context.go(
                                    "search/film?q=$query",
                                    extra: resultsFilm,
                                  );
                                },
                                child: Text("Tout afficher"),
                              )
                            : SizedBox.shrink(),
                      ],
                    ),
                  )
                : SizedBox(),
          ),
          if (resultsPerson.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 30.0, bottom: 5),
              child: Text(
                "Pesonnalité(${resultsPerson.length})",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 9.0),
            child: (resultsPerson.isNotEmpty)
                ? Container(
                    // height: 300,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          // height: 220,
                          child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: (resultsPerson.length > 4)
                                ? 4
                                : resultsPerson.length,
                            itemBuilder: (context, index) {
                              final person = resultsPerson[index];
                              return CardPerson(person: person);
                            },
                          ),
                        ),
                        (resultsPerson.length > 4)
                            ? Divider()
                            : SizedBox.shrink(),
                        (resultsPerson.length > 4)
                            ? TextButton(
                                onPressed: () {
                                  context.push(
                                    "search/person?q=$query",
                                    extra: resultsPerson,
                                  );
                                },
                                child: Text("Tout afficher"),
                              )
                            : SizedBox(),
                      ],
                    ),
                  )
                : SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  // Filtre et affiche les suggestions en temps réel pendant la saisie
  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionsFilm = listFilm
        .where(
          (film) =>
              film.title.toLowerCase().contains(query.toLowerCase()) &&
              query != '',
        )
        .toList();
    final suggestionPerson = listPerson
        .where(
          (person) =>
              person.name.toLowerCase().contains(query.toLowerCase()) &&
              query != '',
        )
        .toList();

    if (suggestionsFilm.isEmpty && suggestionPerson.isEmpty) {
      return const Center(child: Text("Aucune suggestion"));
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (suggestionsFilm.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 30.0, bottom: 5),
              child: Text(
                "Film(${suggestionsFilm.length})",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 9.0, bottom: 25),
            child: (suggestionsFilm.isNotEmpty)
                ? Container(
                    // height: 400,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          // height: 300,
                          child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: (suggestionsFilm.length > 4)
                                ? 4
                                : suggestionsFilm.length,
                            itemBuilder: (context, index) {
                              final film = suggestionsFilm[index];
                              return CardFilm(film: film);
                            },
                          ),
                        ),
                        (suggestionsFilm.length > 4)
                            ? Divider()
                            : SizedBox.shrink(),
                        (suggestionsFilm.length > 4)
                            ? TextButton(
                                onPressed: () {
                                  context.push(
                                    "search/film?q=$query",
                                    extra: suggestionsFilm,
                                  );
                                },
                                child: Text("Tout afficher"),
                              )
                            : SizedBox.shrink(),
                      ],
                    ),
                  )
                : SizedBox(),
          ),
          if (suggestionPerson.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 30.0, bottom: 5),
              child: Text(
                "Pesonnalité(${suggestionPerson.length})",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 9.0),
            child: (suggestionPerson.isNotEmpty)
                ? Container(
                    // height: 300,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          // height: 220,
                          child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: (suggestionPerson.length > 4)
                                ? 4
                                : suggestionPerson.length,
                            itemBuilder: (context, index) {
                              final person = suggestionPerson[index];
                              return CardPerson(person: person);
                            },
                          ),
                        ),
                        (suggestionPerson.length > 4)
                            ? Divider()
                            : SizedBox.shrink(),
                        (suggestionPerson.length > 4)
                            ? TextButton(
                                onPressed: () {
                                  context.go(
                                    "search/person?q=$query",
                                    extra: suggestionPerson,
                                  );
                                },
                                child: Text("Tout afficher"),
                              )
                            : SizedBox(),
                      ],
                    ),
                  )
                : SizedBox.shrink(),
          ),
        ],
      ),
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

class CardPerson extends StatelessWidget {
  final Person person;
  const CardPerson({super.key, required this.person});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(
        Icons.person,
      ), // Remplace le Placeholder par une icône plus propre
      title: Text(person.name),
      onTap: () {
        // Redirige vers la page de détails du film cliqué
        context.push("person/${person.id}");
      },
    );
  }
}
