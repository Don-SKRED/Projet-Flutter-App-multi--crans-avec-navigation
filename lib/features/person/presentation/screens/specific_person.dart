import 'package:flutter/material.dart';
import 'package:multi_screen_app_with_navigation/features/credits/application/service/credits_service.dart';
import 'package:multi_screen_app_with_navigation/features/film/application/services/film_service.dart';
import 'package:multi_screen_app_with_navigation/features/film/presentation/widget/card_film_widget.dart';
import 'package:multi_screen_app_with_navigation/features/person/application/service/person_service.dart';

class SpecificPerson extends StatefulWidget {
  final int personId;
  final PersonService personService;
  const SpecificPerson({
    super.key,
    required this.personId,
    required this.personService,
  });

  @override
  State<SpecificPerson> createState() => _SpecificPersonState();
}

class _SpecificPersonState extends State<SpecificPerson> {
  FilmService filmService = FilmService();
  CreditsService creditsService = CreditsService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            // color: Colors.amber,
            height: MediaQuery.sizeOf(context).height,
            width: MediaQuery.sizeOf(context).width,
          ),
          Align(
            alignment: AlignmentGeometry.bottomCenter,
            child: Container(
              height: MediaQuery.sizeOf(context).height - 100,
              width: MediaQuery.sizeOf(context).width,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 237, 237, 237),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 60.0),
                child: FutureBuilder(
                  future: creditsService.findByPersonId(widget.personId),
                  builder: (context, asyncSnapshot) {
                    if (asyncSnapshot.hasError) {
                      return Center(
                        child: Text('Erreur1 : ${asyncSnapshot.error}'),
                      );
                    }
                    if (asyncSnapshot.hasData) {
                      var data = asyncSnapshot.data;
                      return Column(
                        children: [
                          Expanded(
                            child: Column(
                              // mainAxisAlignment:
                              //       MainAxisAlignment.spaceAround,
                              spacing: 8,
                              children: [
                                Text("Nom acteur"),

                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 8.0,
                                    right: 8.0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Role"),
                                      Text("Birthday"),
                                      Text("Gender"),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 8.0,
                                    right: 8.0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("value"),
                                      Text("value"),
                                      Text("value"),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Participation dans:",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: data!.length,
                                    itemBuilder: (context, index) {
                                      return FutureBuilder(
                                        future: filmService.findById(
                                          data[index].filmId,
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
                                            var filmData = snaphsot.data;
                                            return CardFilmWidget(
                                              film: filmData!,
                                            );
                                          } else {
                                            return CircularProgressIndicator();
                                          }
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                ),
              ),
            ),
          ),
          Align(
            alignment: AlignmentGeometry.topCenter,
            child: Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(80),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
