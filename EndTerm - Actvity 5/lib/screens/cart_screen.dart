import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/api_service.dart';
import '../services/cart_service.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Map<String, dynamic>> _items = [];
  bool _isPlacingOrder = false;
  int? _buyerId;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final buyerId = prefs.getInt('user_id');
    final items = await CartService.loadCart();
    setState(() {
      _buyerId = buyerId;
      _items = items;
    });
  }

  double get _total => _items.fold(
      0.0,
      (sum, item) =>
          sum + (item['price'] as double) * (item['quantity'] as int));

  Future<void> _updateQty(int productId, int qty) async {
    if (qty < 1) return;
    await CartService.updateQuantity(productId, qty);
    await _load();
  }

  Future<void> _remove(int productId) async {
    await CartService.removeItem(productId);
    await _load();
  }

  Future<void> _showCheckoutDialog() async {
    if (_buyerId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please login again')),
      );
      return;
    }
    if (_items.isEmpty) return;

    // Reset date and time
    setState(() {
      _selectedDate = null;
      _selectedTime = null;
    });

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Order Details'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Please select delivery date and time:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                // Date Picker
                TextFormField(
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Delivery Date *',
                    prefixIcon: const Icon(Icons.calendar_today),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    hintText: _selectedDate != null
                        ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
                        : 'Select delivery date',
                  ),
                  onTap: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (pickedDate != null) {
                      setState(() => _selectedDate = pickedDate);
                      setDialogState(() {});
                    }
                  },
                ),
                const SizedBox(height: 16),
                // Time Picker
                TextFormField(
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Delivery Time *',
                    prefixIcon: const Icon(Icons.access_time),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    hintText: _selectedTime != null
                        ? _selectedTime!.format(context)
                        : 'Select delivery time',
                  ),
                  onTap: () async {
                    final pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (pickedTime != null) {
                      setState(() => _selectedTime = pickedTime);
                      setDialogState(() {});
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: _selectedDate != null && _selectedTime != null
                  ? () => Navigator.pop(context, true)
                  : null,
              child: const Text('Place Order'),
            ),
          ],
        ),
      ),
    );

    if (result == true) {
      await _checkout();
    }
  }

  Future<void> _checkout() async {
    if (_buyerId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please login again')),
      );
      return;
    }
    if (_items.isEmpty) return;
    if (_selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select delivery date and time')),
      );
      return;
    }

    setState(() => _isPlacingOrder = true);

    final payloadItems = _items
        .map((it) => {
              'product_id': it['product_id'],
              'quantity': it['quantity'],
              'price': it['price'],
            })
        .toList();

    final result =
        await ApiService.createOrder(buyerId: _buyerId!, items: payloadItems);

    if (!mounted) return;

    if (result['success']) {
      await CartService.clearCart();
      await _load();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Order placed successfully! Delivery: ${DateFormat('yyyy-MM-dd').format(_selectedDate!)} at ${_selectedTime!.format(context)}',
          ),
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Failed to place order')),
      );
    }

    if (mounted) setState(() => _isPlacingOrder = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: _items.isEmpty
          ? const Center(
              child: Text('Your cart is empty'),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _items.length,
                    itemBuilder: (context, index) {
                      final item = _items[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        child: ListTile(
                          leading: item['image_url'] != null
                              ? Image.network(
                                  item['image_url'],
                                  width: 56,
                                  height: 56,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      const Icon(Icons.image_not_supported),
                                )
                              : const Icon(Icons.shopping_bag),
                          title: Text(item['name']),
                          subtitle: Text(
                              '₱${(item['price'] as double).toStringAsFixed(2)}'),
                          trailing: SizedBox(
                            width: 150,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline),
                                  onPressed: () => _updateQty(
                                      item['product_id'], item['quantity'] - 1),
                                ),
                                Text('${item['quantity']}'),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline),
                                  onPressed:
                                      item['quantity'] < (item['stock'] ?? 9999)
                                          ? () => _updateQty(item['product_id'],
                                              item['quantity'] + 1)
                                          : null,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () => _remove(item['product_id']),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    border: const Border(top: BorderSide(color: Colors.grey)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          Text('₱${_total.toStringAsFixed(2)}',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: _isPlacingOrder ? null : _showCheckoutDialog,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        icon: _isPlacingOrder
                            ? const SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white),
                              )
                            : const Icon(Icons.payment),
                        label: const Text('Checkout'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
