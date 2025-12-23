import 'package:flutter/material.dart';

import 'browse_products_screen.dart';
import 'product_management_screen.dart';
import 'seller_orders_screen.dart';
import 'buyer_orders_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        children: [
          _AdminTile(
            icon: Icons.inventory_2,
            label: 'All Products',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProductManagementScreen(showAll: true)),
            ),
          ),
          _AdminTile(
            icon: Icons.receipt_long,
            label: 'All Orders',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SellerOrdersScreen(showAll: true)),
            ),
          ),
          _AdminTile(
            icon: Icons.storefront,
            label: 'Browse Storefront',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const BrowseProductsScreen()),
            ),
          ),
          _AdminTile(
            icon: Icons.people,
            label: 'Buyer Orders',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const BuyerOrdersScreen()),
            ),
          ),
        ],
      ),
    );
  }
}

class _AdminTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _AdminTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 40, color: Colors.blue),
              const SizedBox(height: 12),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

