import 'package:flutter/material.dart';
import '../models/fruit.dart';

/// Scrollable fruit grid using your Fruit model.
class GridViewPage extends StatelessWidget {
  static const route = '/grid-view';
  const GridViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GridView')),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: .78,
        ),
        itemCount: fruits.length,
        itemBuilder: (_, i) => _FruitCard(fruits[i]),
      ),
    );
  }
}

class _FruitCard extends StatelessWidget {
  final Fruit fruit;
  const _FruitCard(this.fruit);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Ink.image(
              image: NetworkImage(fruit.imageUrl),
              fit: BoxFit.cover,
              child: InkWell(onTap: () {}),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
            child: Text(fruit.name,
                style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Row(
              children: [
                Text(fruit.price,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const Spacer(),
                FilledButton(onPressed: () {}, child: const Text('Add')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
