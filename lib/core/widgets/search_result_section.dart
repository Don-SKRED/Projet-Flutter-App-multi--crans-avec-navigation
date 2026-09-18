import 'package:flutter/material.dart';

class SearchResultSection<T> extends StatelessWidget {
  final String titre;
  final List<T> items;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final VoidCallback? onVoirTout;
  final int limiteAffichee;

  const SearchResultSection({
    super.key,
    required this.titre,
    required this.items,
    required this.itemBuilder,
    this.onVoirTout,
    this.limiteAffichee = 4,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    final depasseLimite = items.length > limiteAffichee;
    final itemsAffiches = depasseLimite
        ? items.sublist(0, limiteAffichee)
        : items;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 30.0, bottom: 5),
          child: Text(
            '$titre(${items.length})',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 9.0, bottom: 25),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              children: [
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: itemsAffiches.length,
                  itemBuilder: (context, index) =>
                      itemBuilder(context, itemsAffiches[index]),
                ),
                if (depasseLimite) const Divider(),
                if (depasseLimite)
                  TextButton(
                    onPressed: onVoirTout,
                    child: const Text("Tout afficher"),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
