import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:multi_screen_app_with_navigation/features/credits/application/service/credits_service.dart';
import 'package:multi_screen_app_with_navigation/features/film/application/services/film_service.dart';
import 'package:multi_screen_app_with_navigation/features/film/presentation/widget/card_film_widget.dart';
import 'package:multi_screen_app_with_navigation/features/person/application/service/person_service.dart';
import 'package:multi_screen_app_with_navigation/shared/utils/responsive.dart';

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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              SizedBox(
                height: context.screenHeight,
                width: context.screenWidth,
              ),
              Align(
                alignment: AlignmentGeometry.bottomCenter,
                child: Container(
                  height: context.screenHeight - 100,
                  width: context.screenWidth,
                  decoration: BoxDecoration(
                    // color: const Color.fromARGB(255, 237, 237, 237),
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
                          var creditData = asyncSnapshot.data;
                          return Column(
                            children: [
                              FutureBuilder(
                                future: widget.personService.findById(
                                  widget.personId,
                                ),
                                builder: (context, asyncSnapshot) {
                                  if (asyncSnapshot.hasError) {
                                    return Center(
                                      child: Text(
                                        'Erreur3 : ${asyncSnapshot.error}',
                                      ),
                                    );
                                  }
                                  if (asyncSnapshot.hasData) {
                                    var personData = asyncSnapshot.data;
                                    return Column(
                                      // mainAxisAlignment:
                                      //       MainAxisAlignment.spaceAround,
                                      spacing: 8,
                                      children: [
                                        Text(
                                          personData!.name,
                                          style: TextStyle(fontSize: 20),
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
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 8.0,
                                            right: 8.0,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(personData.birthday),
                                              Text(
                                                personData.gender
                                                    ? "Homme"
                                                    : "Femme",
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                  return CircularProgressIndicator();
                                },
                              ),
                              Expanded(
                                flex: 2,
                                child: Column(
                                  spacing: 10,
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
                                        itemCount: creditData!.length,
                                        itemBuilder: (context, index) {
                                          return FutureBuilder(
                                            future: filmService.findById(
                                              creditData[index].filmId,
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
                child: FutureBuilder(
                  future: widget.personService.findById(widget.personId),
                  builder: (context, asyncSnapshot) {
                    if (asyncSnapshot.hasData) {
                      var person = asyncSnapshot.data;
                      final avatarSize = context.profileAvatarSize;
                      return ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: person!.face,
                          width: avatarSize,
                          height: avatarSize,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            width: avatarSize,
                            height: avatarSize,
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
                            width: avatarSize,
                            height: avatarSize,
                            color: Colors.purple,
                            child: const Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
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
