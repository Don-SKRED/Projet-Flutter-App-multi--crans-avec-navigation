import 'package:flutter/material.dart';
import 'package:multi_screen_app_with_navigation/features/person/domain/person_model.dart';
import 'package:multi_screen_app_with_navigation/features/person/presentation/widgets/search_card_person.dart';

class ResultSearchPerson extends StatefulWidget {
  final String query;
  final List<Person> listPerson;
  const ResultSearchPerson({
    super.key,
    required this.query,
    required this.listPerson,
  });

  @override
  State<ResultSearchPerson> createState() => _ResultSearchPersonState();
}

class _ResultSearchPersonState extends State<ResultSearchPerson> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(children: [Text("Personnalité"), Text(widget.query)]),
      ),
      body: ListView.builder(
        itemCount: widget.listPerson.length,
        itemBuilder: (context, index) {
          return CardPerson(person: widget.listPerson[index]);
        },
      ),
    );
  }
}
