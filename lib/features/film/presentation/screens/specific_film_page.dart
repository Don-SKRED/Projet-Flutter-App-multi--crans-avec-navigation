import 'package:flutter/material.dart';
import 'package:multi_screen_app_with_navigation/features/film/application/services/film_service.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
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
                    height: 300,
                    width: MediaQuery.sizeOf(context).width,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: FutureBuilder(
                        future: widget.filmService.findById(widget.filmId),
                        builder: (context, asyncSnapshot) {
                          if (asyncSnapshot.hasData) {
                            var data = asyncSnapshot.data;
                            return SizedBox(
                              // color: Colors.red,
                              height: 100,
                              width: MediaQuery.sizeOf(context).width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data!.title,
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(data.release.toString()),
                                  Text(data.synopsis),
                                  Text(data.poster),
                                ],
                              ),
                            );
                          } else {
                            return CircularProgressIndicator();
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
