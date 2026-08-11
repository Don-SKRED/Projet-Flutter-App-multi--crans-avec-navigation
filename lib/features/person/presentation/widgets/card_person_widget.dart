import 'package:flutter/material.dart';
import 'package:multi_screen_app_with_navigation/features/person/domain/person_model.dart';

class CardPersonWidget extends StatelessWidget {
  final Person person;
  const CardPersonWidget({super.key, required this.person});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        width: 300,
        child: Row(
          spacing: 20,
          children: [
            Container(
              height: 65,
              width: 65,
              decoration: BoxDecoration(
                color: Colors.purple,
                borderRadius: BorderRadius.circular(60),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text(person.name)],
            ),
          ],
        ),
      ),
    );
  }
}
