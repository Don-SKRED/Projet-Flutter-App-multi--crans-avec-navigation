import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_screen_app_with_navigation/features/film/application/services/film_service.dart';
import 'package:multi_screen_app_with_navigation/features/film/domain/film_model.dart';

import 'package:multi_screen_app_with_navigation/features/film/presentation/widget/card_film_widget.dart';
import 'package:multi_screen_app_with_navigation/features/film/presentation/widget/search_card_film.dart';
import 'package:multi_screen_app_with_navigation/features/person/application/service/person_service.dart';
import 'package:multi_screen_app_with_navigation/features/person/domain/person_model.dart';
import 'package:multi_screen_app_with_navigation/features/person/presentation/widgets/card_person_widget.dart';
import 'package:multi_screen_app_with_navigation/features/person/presentation/widgets/search_card_person.dart';
import 'package:multi_screen_app_with_navigation/shared/utils/theme_provider.dart';
import 'package:multi_screen_app_with_navigation/shared/widgets/search_result_section.dart';
import 'package:multi_screen_app_with_navigation/shared/utils/responsive.dart';

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

  @override
  void initState() {
    super.initState();
    _filmsFuture = filmService.readFile();
    _personsFuture = personService.readFile();
    _loadData();
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
          ListenableBuilder(
            listenable: themeProvider, // l'objet entier, pas un champ précis
            builder: (context, child) {
              // Ici, PAS de "value" fourni automatiquement — on relit nous-mêmes :
              return IconButton(
                onPressed: () {
                  themeProvider.changeMode(!themeProvider.isDarkMode);
                },
                icon: Icon(
                  themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                ),
              );
            },
          ),
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
              decoration: const BoxDecoration(color: Colors.deepPurple),
              height: context.filmsListHeight,
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
                          SizedBox(width: context.spacing),
                      itemCount: data.length,
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
                    height: context.personListHeight,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () => context.push(
                            "person/${data[index].id}",
                            extra: personService,
                          ),
                          child: CardPersonWidget(person: data[index]),
                        );
                      },
                      separatorBuilder: (context, index) =>
                          SizedBox(width: context.spacing),
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
          SearchResultSection<Film>(
            titre: "Film",
            items: resultsFilm,
            itemBuilder: (context, film) => CardFilm(film: film),
            onVoirTout: () =>
                context.go("search/film?q=$query", extra: resultsFilm),
          ),
          SearchResultSection<Person>(
            titre: "Pesonnalité",
            items: resultsPerson,
            itemBuilder: (context, person) => CardPerson(person: person),
            onVoirTout: () =>
                context.push("search/person?q=$query", extra: resultsPerson),
          ),
        ],
      ),
    );
  }

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
          SearchResultSection<Film>(
            titre: "Film",
            items: suggestionsFilm,
            itemBuilder: (context, film) => CardFilm(film: film),
            onVoirTout: () =>
                context.push("search/film?q=$query", extra: suggestionsFilm),
          ),
          SearchResultSection<Person>(
            titre: "Pesonnalité",
            items: suggestionPerson,
            itemBuilder: (context, person) => CardPerson(person: person),
            onVoirTout: () =>
                context.go("search/person?q=$query", extra: suggestionPerson),
          ),
        ],
      ),
    );
  }
}
