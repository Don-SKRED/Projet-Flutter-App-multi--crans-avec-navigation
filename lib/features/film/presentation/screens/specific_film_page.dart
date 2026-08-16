import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:multi_screen_app_with_navigation/features/credits/application/service/credits_service.dart';
import 'package:multi_screen_app_with_navigation/features/film/application/services/film_service.dart';
import 'package:multi_screen_app_with_navigation/features/person/application/service/person_service.dart';
import 'package:multi_screen_app_with_navigation/features/person/presentation/widgets/card_person_widget.dart';
import 'package:multi_screen_app_with_navigation/shared/utils/responsive.dart';

class SpecificFilmPage extends StatefulWidget {
  final int filmId;
  final FilmService filmService;
  const SpecificFilmPage({
    super.key,
    required this.filmId,
    required this.filmService,
  });

  @override
  State<SpecificFilmPage> createState() => _SpecificFilmPageState();
}

class _SpecificFilmPageState extends State<SpecificFilmPage> {
  CreditsService creditsService = CreditsService();
  PersonService personService = PersonService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: context.screenHeight,
          child: FutureBuilder(
            future: widget.filmService.findById(widget.filmId),
            builder: (context, asyncSnapshot) {
              if (asyncSnapshot.hasData) {
                var film = asyncSnapshot.data;
                return Stack(
                  children: [
                    Container(
                      height: context.filmPosterHeight,
                      width: context.screenWidth,
                      decoration: const BoxDecoration(color: Colors.purple),
                      child: CachedNetworkImage(
                        imageUrl: film!.poster,
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
                    Align(
                      alignment: AlignmentGeometry.bottomCenter,
                      child: Container(
                        height: context.filmInfoCardHeight,
                        width: context.screenWidth,
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
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
                                        "Date de sortie: ${film.release.toString()} ",
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
                              Expanded(
                                flex: 2,
                                child: FutureBuilder(
                                  future: creditsService.findByFilmId(
                                    widget.filmId,
                                  ),
                                  builder: (context, asyncSnapshot) {
                                    if (asyncSnapshot.hasError) {
                                      return Center(
                                        child: Text(
                                          'Erreur1 : ${asyncSnapshot.error}',
                                        ),
                                      );
                                    }
                                    if (asyncSnapshot.hasData) {
                                      var data = asyncSnapshot.data;
                                      return ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: data!.length,
                                        itemBuilder: (context, index) {
                                          return FutureBuilder(
                                            future: personService.findById(
                                              data[index].personId,
                                            ),
                                            builder: (context, snaphsot) {
                                              if (snaphsot.hasError) {
                                                return Center(
                                                  child: Text(
                                                    'Erreur2 : ${snaphsot.error}',
                                                  ),
                                                );
                                              }
                                              if (snaphsot.hasData) {
                                                var personData = snaphsot.data;
                                                return CardPersonWidget(
                                                  person: personData!,
                                                );
                                              } else {
                                                return const CircularProgressIndicator();
                                              }
                                            },
                                          );
                                        },
                                      );
                                    } else {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),

                          // FutureBuilder(
                          //   future: widget.filmService.findById(widget.filmId),
                          //   builder: (context, asyncSnapshot) {
                          //     if (asyncSnapshot.hasData) {
                          //       var data = asyncSnapshot.data;
                          //       return SizedBox(
                          //         // color: Colors.red,
                          //         height: 100,
                          //         width: MediaQuery.sizeOf(context).width,
                          //         child: Column(
                          //           crossAxisAlignment: CrossAxisAlignment.start,
                          //           children: [
                          //             Text(
                          //               data!.title,
                          //               style: TextStyle(
                          //                 fontSize: 30,
                          //                 fontWeight: FontWeight.bold,
                          //               ),
                          //             ),
                          //             Text(data.release.toString()),
                          //             Text(data.synopsis),
                          //             Text(data.poster),
                          //           ],
                          //         ),
                          //       );
                          //     } else {
                          //       return CircularProgressIndicator();
                          //     }
                          //   },
                          // ),
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return Center(child: Text('Erreur1 : ${asyncSnapshot.error}'));
              }
            },
          ),
        ),
      ),
    );
  }
}
