// import 'package:flutter/material.dart';
// import 'package:multi_screen_app_with_navigation/features/person/domain/person_model.dart';

// class CardPersonWidget extends StatelessWidget {
//   final Person person;
//   const CardPersonWidget({super.key, required this.person});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: SizedBox(
//         width: 300,
//         child: Row(
//           spacing: 20,
//           children: [
//             Container(
//               height: 65,
//               width: 65,
//               decoration: BoxDecoration(
//                 color: Colors.purple,
//                 borderRadius: BorderRadius.circular(60),
//               ),
//             ),
//             Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [Text(person.name)],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:multi_screen_app_with_navigation/features/person/domain/person_model.dart';
import 'package:multi_screen_app_with_navigation/shared/utils/responsive.dart';

class CardPersonWidget extends StatelessWidget {
  final Person person;
  const CardPersonWidget({super.key, required this.person});

  @override
  Widget build(BuildContext context) {
    final cardWidth = context.personCardWidth;
    final cardHeight = context.personCardHeight;
    final avatarSize = cardHeight * 0.7; // ~63 on mobile, ~77 on tablet

    return Card(
      child: SizedBox(
        width: cardWidth,
        height: cardHeight,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.paddingH),
          child: Row(
            children: [
              ClipOval(
                child: CachedNetworkImage(
                  imageUrl: person.face,
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
                    child: const Icon(Icons.person, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(width: context.spacing),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      person.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
