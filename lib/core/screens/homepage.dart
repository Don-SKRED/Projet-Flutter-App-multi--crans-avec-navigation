import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_screen_app_with_navigation/features/film/data/model/film_model.dart';
import 'package:multi_screen_app_with_navigation/features/film/presentation/providers/film_provider.dart';
import 'package:multi_screen_app_with_navigation/features/film/presentation/widget/card_film_widget.dart';
import 'package:multi_screen_app_with_navigation/features/film/presentation/widget/search_card_film.dart';
import 'package:multi_screen_app_with_navigation/features/person/domain/person_model.dart';
import 'package:multi_screen_app_with_navigation/features/person/presentation/providers/person_provider.dart';
import 'package:multi_screen_app_with_navigation/features/person/presentation/widgets/card_person_widget.dart';
import 'package:multi_screen_app_with_navigation/features/person/presentation/widgets/search_card_person.dart';
import 'package:multi_screen_app_with_navigation/core/utils/theme_provider.dart';
import 'package:multi_screen_app_with_navigation/core/widgets/search_result_section.dart';
import 'package:multi_screen_app_with_navigation/core/utils/responsive.dart';
import 'package:multi_screen_app_with_navigation/features/auth/presentation/provider/auth_provider.dart';
import 'package:multi_screen_app_with_navigation/core/widgets/offline_banner_widget.dart';

class Homepage extends ConsumerStatefulWidget {
  const Homepage({super.key});

  @override
  ConsumerState<Homepage> createState() => _HomepageState();
}

class _HomepageState extends ConsumerState<Homepage> {
  final String titleAppBar = "Film page";
  final String titre1 = "Film";
  final String titre2 = "Personnalité";

  @override
  Widget build(BuildContext context) {
    final allFilms = ref.watch(filmsProvider);
    final allPersons = ref.watch(personsProvider);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await context.push("film/new");
          ref.invalidate(filmsProvider);
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
                  // On lit directement les données déjà chargées dans les providers
                  listFilm: allFilms.asData?.value ?? [],
                  listPerson: allPersons.asData?.value ?? [],
                ),
              );
            },
            icon: Icon(Icons.search),
          ),
          IconButton(
            tooltip: 'Se déconnecter',
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Déconnexion'),
                  content: const Text(
                    'Voulez-vous vraiment vous déconnecter ?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Annuler'),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Déconnexion'),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                await ref.read(authProvider.notifier).signOut();
              }
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(filmsProvider);
          ref.invalidate(personsProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const OfflineBannerWidget(),
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
                child: allFilms.when(
                  data: (data) {
                    return ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () => context.push(
                            "film/${data[index].id}",
                            // extra: filmService,
                          ),
                          child: CardFilmWidget(film: data[index]),
                        );
                      },
                      separatorBuilder: (context, index) =>
                          SizedBox(width: context.spacing),
                      itemCount: data.length,
                    );
                  },
                  error: (error, _) {
                    return Center(child: Text("Error : $error"));
                  },
                  loading: () {
                    return Center(child: CircularProgressIndicator());
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

              SizedBox(
                height: context.personListHeight,
                child: allPersons.when(
                  data: (data) {
                    return ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () => context.push("person/${data[index].id}"),
                          child: CardPersonWidget(person: data[index]),
                        );
                      },
                      separatorBuilder: (context, index) =>
                          SizedBox(width: context.spacing),
                      itemCount: data.length,
                    );
                  },
                  error: (error, _) {
                    return Center(child: Text("Error : $error"));
                  },
                  loading: () {
                    return Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ],
          ),
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
