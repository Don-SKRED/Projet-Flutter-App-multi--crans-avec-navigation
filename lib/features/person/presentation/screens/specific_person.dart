import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_screen_app_with_navigation/core/utils/responsive.dart';
import 'package:multi_screen_app_with_navigation/features/credits/presentation/providers/credit_provider.dart';
import 'package:multi_screen_app_with_navigation/features/film/presentation/providers/film_provider.dart';
import 'package:multi_screen_app_with_navigation/features/film/presentation/widget/card_film_widget.dart';
import 'package:multi_screen_app_with_navigation/features/person/application/service/person_service.dart';
import 'package:multi_screen_app_with_navigation/features/person/presentation/providers/person_provider.dart';

class SpecificPerson extends ConsumerWidget {
  final int personId;
  final PersonService? personService;
  const SpecificPerson({
    super.key,
    required this.personId,
    this.personService,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Provider pour charger les informations de la personne
    final personAsync = ref.watch(personByIdProvider(personId));

    // 2. Provider pour charger les crédits/participations de la personne
    final creditsAsync = ref.watch(creditsByPersonIdProvider(personId));

    return Scaffold(
      body: personAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Scaffold(
          appBar: AppBar(),
          body: Center(
            child: Text(
              'Erreur : $error',
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ),
        data: (person) {
          if (person == null) {
            return Scaffold(
              appBar: AppBar(),
              body: const Center(child: Text('Personne introuvable')),
            );
          }

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: [
                  SizedBox(
                    height: context.screenHeight,
                    width: context.screenWidth,
                  ),

                  // Carte inférieure avec informations et filmographie
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: context.screenHeight - 100,
                      width: context.screenWidth,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 60.0),
                        child: Column(
                          children: [
                            // Nom, date de naissance et genre
                            Column(
                              children: [
                                Text(
                                  person.name,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: const [
                                      Text(
                                        "Date de naissance",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        "Genre",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(person.birthday),
                                      Text(
                                        person.gender ? "Homme" : "Femme",
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Section filmographie (creditsAsync.when)
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      "Participation dans :",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: creditsAsync.when(
                                      loading: () => const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                      error: (error, _) => Center(
                                        child: Text(
                                          'Erreur crédits : $error',
                                        ),
                                      ),
                                      data: (credits) {
                                        if (credits.isEmpty) {
                                          return const Center(
                                            child: Text('Aucun film trouvé'),
                                          );
                                        }

                                        return ListView.separated(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: credits.length,
                                          separatorBuilder: (context, index) =>
                                              SizedBox(width: context.spacing),
                                          itemBuilder: (context, index) {
                                            final credit = credits[index];

                                            // Pour chaque crédit, on charge le film avec filmByIdProvider
                                            return Consumer(
                                              builder: (context, ref, child) {
                                                final filmAsync = ref.watch(
                                                  filmByIdProvider(
                                                    credit.filmId,
                                                  ),
                                                );

                                                return filmAsync.when(
                                                  loading: () => const Center(
                                                    child: SizedBox(
                                                      width: 40,
                                                      height: 40,
                                                      child:
                                                          CircularProgressIndicator(),
                                                    ),
                                                  ),
                                                  error: (err, _) => Center(
                                                    child: Text(
                                                      'Erreur : $err',
                                                    ),
                                                  ),
                                                  data: (film) {
                                                    if (film == null) {
                                                      return const SizedBox
                                                          .shrink();
                                                    }
                                                    return InkWell(
                                                      onTap: () => context.push(
                                                        "/film/${film.id}",
                                                      ),
                                                      child: CardFilmWidget(
                                                        film: film,
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Avatar profil en haut au centre
                  Align(
                    alignment: Alignment.topCenter,
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: person.face,
                        width: context.profileAvatarSize,
                        height: context.profileAvatarSize,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          width: context.profileAvatarSize,
                          height: context.profileAvatarSize,
                          color: Colors.purple,
                          child: const Center(
                            child: SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          width: context.profileAvatarSize,
                          height: context.profileAvatarSize,
                          color: Colors.purple,
                          child: const Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Bouton retour
                  Align(
                    alignment: Alignment.topLeft,
                    child: CircleAvatar(
                      backgroundColor: Colors.black26,
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                        onPressed: () => context.pop(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
