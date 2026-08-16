import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_screen_app_with_navigation/features/person/domain/person_model.dart';

class CardPerson extends StatelessWidget {
  final Person person;
  const CardPerson({super.key, required this.person});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.person),
      title: Text(person.name),
      onTap: () => context.push("person/${person.id}"),
    );
  }
}
