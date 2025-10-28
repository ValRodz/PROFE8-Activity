import 'package:flutter/material.dart';
import '../models/fruit.dart';

/// Draggable sheet listing fruit picks.
class DraggableScrollableSheetPage extends StatelessWidget {
  static const route = '/draggable-sheet';
  const DraggableScrollableSheetPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Use one of your fruit images as background to avoid decode errors
    final bg = fruits.first.imageUrl;

    return Scaffold(
      appBar: AppBar(title: const Text('DraggableScrollableSheet')),
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.network(
              bg,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: Colors.black12,
                alignment: Alignment.center,
                child: const Text('Background image failed to load'),
              ),
            ),
          ),
          // Draggable sheet with fruits
          DraggableScrollableSheet(
            initialChildSize: 0.2,
            minChildSize: 0.15,
            maxChildSize: 0.75,
            builder: (context, controller) {
              return Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      // ignore: deprecated_member_use
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 16,
                      offset: const Offset(0, -6),
                    ),
                  ],
                ),
                child: ListView.builder(
                  controller: controller,
                  itemCount: fruits.length,
                  itemBuilder: (_, i) => ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        fruits[i].imageUrl,
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 48,
                          height: 48,
                          color: Colors.black12,
                          alignment: Alignment.center,
                          child: const Icon(Icons.broken_image),
                        ),
                      ),
                    ),
                    title: Text(fruits[i].name),
                    subtitle: Text(fruits[i].description),
                    trailing: Text(
                      fruits[i].price,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
