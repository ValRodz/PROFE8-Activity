import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/order_model.dart';
import '../services/api_service.dart';

class SellerOrdersScreen extends StatefulWidget {
  final bool showAll;
  const SellerOrdersScreen({super.key, this.showAll = false});

  @override
  State<SellerOrdersScreen> createState() => _SellerOrdersScreenState();
}

class _SellerOrdersScreenState extends State<SellerOrdersScreen> {
  late Future<List<Order>> _orders;
  int? _sellerId;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    final prefs = await SharedPreferences.getInstance();
    _sellerId = prefs.getInt('user_id');

    setState(() {
      _orders = _fetchOrders();
    });
  }

  Future<List<Order>> _fetchOrders() async {
    if (!widget.showAll && _sellerId == null) return [];

    final result = widget.showAll
        ? await ApiService.getOrders()
        : await ApiService.getOrders(sellerId: _sellerId!);

    if (result['success']) {
      final List<dynamic> ordersJson = result['orders'] as List<dynamic>;
      return ordersJson
          .map((o) => Order.fromJson(o as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception(result['message'] ?? 'Failed to load orders');
    }
  }

  Future<void> _updateOrderStatus(int orderId, String newStatus) async {
    final result = await ApiService.updateOrderStatus(
      orderId: orderId,
      status: newStatus,
    );

    if (!mounted) return;

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order status updated to $newStatus')),
      );
      _loadOrders();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'])),
      );
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'shipped':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Incoming Orders'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Order>>(
        future: _orders,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadOrders,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final orders = snapshot.data ?? [];

          if (orders.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long_outlined,
                      size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No orders yet'),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ExpansionTile(
                  title: Text('Order #${order.id}'),
                  subtitle: Text(
                      'Total: ₱${order.total.toStringAsFixed(2)} | Status: ${order.status}'),
                  leading: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _getStatusColor(order.status),
                    ),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order Date: ${order.createdAt.toString().split('.')[0]}',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Status:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            children: [
                              'pending',
                              'shipped',
                              'completed',
                              'cancelled'
                            ]
                                .map((status) => ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: order.status == status
                                            ? _getStatusColor(status)
                                            : Colors.grey[300],
                                        foregroundColor: order.status == status
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                      onPressed: () {
                                        if (order.status != status) {
                                          _updateOrderStatus(order.id, status);
                                        }
                                      },
                                      child: Text(status.toUpperCase()),
                                    ))
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
