import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_screen_app_with_navigation/core/utils/responsive.dart';
import 'package:multi_screen_app_with_navigation/features/credits/presentation/providers/credit_provider.dart';
import 'package:multi_screen_app_with_navigation/features/film/presentation/providers/film_provider.dart';
import 'package:multi_screen_app_with_navigation/features/person/presentation/providers/person_provider.dart';
import 'package:multi_screen_app_with_navigation/features/person/presentation/widgets/card_person_widget.dart';
import 'package:multi_screen_app_with_navigation/core/widgets/offline_banner_widget.dart';

class SpecificFilmPage extends ConsumerWidget {
  final int filmId;
  const SpecificFilmPage({super.key, required this.filmId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Provider pour récupérer les détails du film
    final filmAsync = ref.watch(filmByIdProvider(filmId));

    // 2. Provider pour récupérer les crédits/casting du film
    final creditsAsync = ref.watch(creditsByFilmIdProvider(filmId));

    return Scaffold(
      // On utilise .when sur filmAsync pour gérer loading, error et data
      body: filmAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text(
            'Erreur : $error',
            style: const TextStyle(color: Colors.red),
          ),
        ),
        data: (film) {
          if (film == null) {
            return const Center(child: Text('Film introuvable'));
          }

          // Quand le film est chargé, on affiche le Stack avec ses données
          return Stack(
            children: [
              // Affiche du film
              Container(
                height: context.filmPosterHeight,
                width: context.screenWidth,
                decoration: const BoxDecoration(color: Colors.purple),
                child: CachedNetworkImage(
                  imageUrl: film.poster,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  placeholder: (context, url) => Container(
                    color: Colors.red,
                    child: const Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.red,
                    child: const Icon(
                      Icons.movie,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
              ),

              // Bouton retour en haut à gauche
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.black45,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => context.pop(),
                    ),
                  ),
                ),
              ),

              // Carte inférieure avec informations du film et casting
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: context.filmInfoCardHeight,
                  width: context.screenWidth,
                  decoration: const BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        // Titre, date de sortie, synopsis et genre du film
                        Flexible(
                          flex: 3,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Text(
                                  film.title,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Date de sortie: ${film.release}",
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  film.synopsis,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  film.genre,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Section casting utilisant creditsAsync.when
                        Expanded(
                          flex: 2,
                          child: creditsAsync.when(
                            loading: () => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            error: (error, _) =>
                                Center(child: Text('Erreur crédits : $error')),
                            data: (credits) {
                              print("credits: $credits");
                              if (credits.isEmpty) {
                                return const Center(
                                  child: Text('Aucun crédit disponible'),
                                );
                              }

                              return ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: credits.length,
                                itemBuilder: (context, index) {
                                  final credit = credits[index];

                                  // Pour chaque crédit, on charge la personne correspondante
                                  return Consumer(
                                    builder: (context, ref, child) {
                                      final personAsync = ref.watch(
                                        personByIdProvider(credit.personId),
                                      );

                                      return personAsync.when(
                                        loading: () => const Center(
                                          child: SizedBox(
                                            width: 40,
                                            height: 40,
                                            child: CircularProgressIndicator(),
                                          ),
                                        ),
                                        error: (err, _) => Center(
                                          child: Text('Erreur : $err'),
                                        ),
                                        data: (person) {
                                          if (person == null) {
                                            return const SizedBox.shrink();
                                          }
                                          return CardPersonWidget(
                                            person: person,
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
                ),
              ),
              const SafeArea(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: OfflineBannerWidget(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}


// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:multi_screen_app_with_navigation/features/credits/application/service/credits_service.dart';
// import 'package:multi_screen_app_with_navigation/features/film/application/services/film_service.dart';
// import 'package:multi_screen_app_with_navigation/features/person/application/service/person_service.dart';
// import 'package:multi_screen_app_with_navigation/features/person/presentation/widgets/card_person_widget.dart';
// import 'package:multi_screen_app_with_navigation/core/utils/responsive.dart';

// class SpecificFilmPage extends StatefulWidget {
//   final int filmId;
//   final FilmService filmService;
//   const SpecificFilmPage({
//     super.key,
//     required this.filmId,
//     required this.filmService,
//   });

//   @override
//   State<SpecificFilmPage> createState() => _SpecificFilmPageState();
// }

// class _SpecificFilmPageState extends State<SpecificFilmPage> {
//   CreditsService creditsService = CreditsService();
//   PersonService personService = PersonService();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: SizedBox(
//           height: context.screenHeight,
//           child: FutureBuilder(
//             future: widget.filmService.findById(widget.filmId),
//             builder: (context, asyncSnapshot) {
//               if (asyncSnapshot.hasData) {
//                 var film = asyncSnapshot.data;
//                 return Stack(
//                   children: [
//                     Container(
//                       height: context.filmPosterHeight,
//                       width: context.screenWidth,
//                       decoration: const BoxDecoration(color: Colors.purple),
//                       child: CachedNetworkImage(
//                         imageUrl: film!.poster,
//                         fit: BoxFit.cover,
//                         width: double.infinity,
//                         height: double.infinity,
//                         placeholder: (context, url) => Container(
//                           color: Colors.red,
//                           child: const Center(
//                             child: SizedBox(
//                               width: 20,
//                               height: 20,
//                               child: CircularProgressIndicator(
//                                 strokeWidth: 2,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ),
//                         errorWidget: (context, url, error) => Container(
//                           color: Colors.red,
//                           child: const Icon(
//                             Icons.movie,
//                             color: Colors.white,
//                             size: 40,
//                           ),
//                         ),
//                       ),
//                     ),
//                     Align(
//                       alignment: AlignmentGeometry.bottomCenter,
//                       child: Container(
//                         height: context.filmInfoCardHeight,
//                         width: context.screenWidth,
//                         decoration: BoxDecoration(
//                           color: Colors.orange,
//                           borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(30),
//                           ),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(20.0),
//                           child: Column(
//                             children: [
//                               Flexible(
//                                 flex: 3,
//                                 child: SingleChildScrollView(
//                                   child: Column(
//                                     children: [
//                                       Text(
//                                         film.title,
//                                         textAlign: TextAlign.center,
//                                         style: const TextStyle(
//                                           fontSize: 25,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                       const SizedBox(height: 4),
//                                       Text(
//                                         "Date de sortie: ${film.release.toString()} ",
//                                         textAlign: TextAlign.center,
//                                       ),
//                                       const SizedBox(height: 8),
//                                       Text(
//                                         film.synopsis,
//                                         textAlign: TextAlign.center,
//                                       ),
//                                       const SizedBox(height: 8),
//                                       Text(
//                                         film.genre,
//                                         textAlign: TextAlign.center,
//                                         style: const TextStyle(
//                                           fontStyle: FontStyle.italic,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                               Expanded(
//                                 flex: 2,
//                                 child: FutureBuilder(
//                                   future: creditsService.findByFilmId(
//                                     widget.filmId,
//                                   ),
//                                   builder: (context, asyncSnapshot) {
//                                     if (asyncSnapshot.hasError) {
//                                       return Center(
//                                         child: Text(
//                                           'Erreur1 : ${asyncSnapshot.error}',
//                                         ),
//                                       );
//                                     }
//                                     if (asyncSnapshot.hasData) {
//                                       var data = asyncSnapshot.data;
//                                       return ListView.builder(
//                                         scrollDirection: Axis.horizontal,
//                                         itemCount: data!.length,
//                                         itemBuilder: (context, index) {
//                                           return FutureBuilder(
//                                             future: personService.findById(
//                                               data[index].personId,
//                                             ),
//                                             builder: (context, snaphsot) {
//                                               if (snaphsot.hasError) {
//                                                 return Center(
//                                                   child: Text(
//                                                     'Erreur2 : ${snaphsot.error}',
//                                                   ),
//                                                 );
//                                               }
//                                               if (snaphsot.hasData) {
//                                                 var personData = snaphsot.data;
//                                                 return CardPersonWidget(
//                                                   person: personData!,
//                                                 );
//                                               } else {
//                                                 return const CircularProgressIndicator();
//                                               }
//                                             },
//                                           );
//                                         },
//                                       );
//                                     } else {
//                                       return const Center(
//                                         child: CircularProgressIndicator(),
//                                       );
//                                     }
//                                   },
//                                 ),
//                               ),
//                             ],
//                           ),

//                           // FutureBuilder(
//                           //   future: widget.filmService.findById(widget.filmId),
//                           //   builder: (context, asyncSnapshot) {
//                           //     if (asyncSnapshot.hasData) {
//                           //       var data = asyncSnapshot.data;
//                           //       return SizedBox(
//                           //         // color: Colors.red,
//                           //         height: 100,
//                           //         width: MediaQuery.sizeOf(context).width,
//                           //         child: Column(
//                           //           crossAxisAlignment: CrossAxisAlignment.start,
//                           //           children: [
//                           //             Text(
//                           //               data!.title,
//                           //               style: TextStyle(
//                           //                 fontSize: 30,
//                           //                 fontWeight: FontWeight.bold,
//                           //               ),
//                           //             ),
//                           //             Text(data.release.toString()),
//                           //             Text(data.synopsis),
//                           //             Text(data.poster),
//                           //           ],
//                           //         ),
//                           //       );
//                           //     } else {
//                           //       return CircularProgressIndicator();
//                           //     }
//                           //   },
//                           // ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 );
//               } else {
//                 return Center(child: Text('Erreur1 : ${asyncSnapshot.error}'));
//               }
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }