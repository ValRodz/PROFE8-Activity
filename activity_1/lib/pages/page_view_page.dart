import 'package:flutter/material.dart';
import '../models/fruit.dart';

/// Horizontal fruit gallery (PageView).
class MyPageViewPage extends StatelessWidget {
  static const route = '/page-view';
  const MyPageViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PageView')),
      body: PageView.builder(
        itemCount: fruits.length,
        controller: PageController(viewportFraction: 0.92),
        itemBuilder: (_, i) => Padding(
          padding: const EdgeInsets.all(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(fruits[i].imageUrl, fit: BoxFit.cover),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    // ignore: deprecated_member_use
                    color: Colors.black.withOpacity(0.45),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${fruits[i].name} • ${fruits[i].price}',
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
