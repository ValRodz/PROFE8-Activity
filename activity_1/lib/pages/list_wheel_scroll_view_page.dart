import 'package:flutter/material.dart';
import '../models/fruit.dart';

/// Spinning wheel of fruit items.
class ListWheelScrollViewPage extends StatelessWidget {
  static const route = '/list-wheel';
  const ListWheelScrollViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ListWheelScrollView')),
      body: Center(
        child: ListWheelScrollView.useDelegate(
          itemExtent: 72,
          perspective: 0.0025,
          diameterRatio: 2.0,
          physics: const FixedExtentScrollPhysics(),
          childDelegate: ListWheelChildBuilderDelegate(
            childCount: fruits.length,
            builder: (_, i) => Card(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(fruits[i].imageUrl),
                ),
                title: Text(fruits[i].name),
                trailing: Text(fruits[i].price,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
