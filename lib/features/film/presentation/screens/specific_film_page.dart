import 'package:flutter/material.dart';
import 'package:multi_screen_app_with_navigation/features/credits/application/service/credits_service.dart';
import 'package:multi_screen_app_with_navigation/features/film/application/services/film_service.dart';
import 'package:multi_screen_app_with_navigation/features/person/application/service/person_service.dart';
import 'package:multi_screen_app_with_navigation/features/person/presentation/widgets/card_person_widget.dart';

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
          height: MediaQuery.sizeOf(context).height,
          child: Stack(
            children: [
              Container(
                height: 400,
                width: MediaQuery.sizeOf(context).width,
                decoration: BoxDecoration(color: Colors.purple),
              ),
              Align(
                alignment: AlignmentGeometry.bottomCenter,
                child: Container(
                  height: 350,
                  width: MediaQuery.sizeOf(context).width,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ListView(
                      children: [
                        Flexible(
                          flex: 3,
                          child: Container(
                            child: Column(
                              children: [
                                Text(
                                  "Titre film",
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text("Date de sortie: "),
                                Text("""synopsis"""),
                                Text("genre"),
                              ],
                            ),
                          ),
                        ),

                        FutureBuilder(
                          future: creditsService.findByFilmId(widget.filmId),
                          builder: (context, asyncSnapshot) {
                            if (asyncSnapshot.hasError) {
                              return Center(
                                child: Text('Erreur1 : ${asyncSnapshot.error}'),
                              );
                            }
                            if (asyncSnapshot.hasData) {
                              var data = asyncSnapshot.data;
                              return Expanded(
                                flex: 2,
                                child: ListView.builder(
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
                                          return CircularProgressIndicator();
                                        }
                                      },
                                    );
                                  },
                                ),
                              );
                            } else {
                              return CircularProgressIndicator();
                            }
                          },
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
          ),
        ),
      ),
    );
  }
}
