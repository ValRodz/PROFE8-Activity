import 'package:flutter/material.dart';

void main() {
  runApp(const FruitStoreApp());
}

class FruitStoreApp extends StatelessWidget {
  const FruitStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fruit Store Ordering System',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      home: const FruitStoreForm(),
    );
  }
}

class FruitStoreForm extends StatefulWidget {
  const FruitStoreForm({super.key});

  @override
  State<FruitStoreForm> createState() => _FruitStoreFormState();
}

class Order {
  final String name;
  final String email;
  final String fruit;
  final int quantity;
  final bool honeyDip;
  final bool ecoBag;
  final bool chocolateCoating;
  final bool icePack;
  final bool expressDelivery;
  final bool cashOnDelivery;
  final bool organicOnly;
  final String deliveryDate;
  final String deliveryTime;
  final double totalAmount;

  Order({
    required this.name,
    required this.email,
    required this.fruit,
    required this.quantity,
    required this.honeyDip,
    required this.ecoBag,
    required this.chocolateCoating,
    required this.icePack,
    required this.expressDelivery,
    required this.cashOnDelivery,
    required this.organicOnly,
    required this.deliveryDate,
    required this.deliveryTime,
    required this.totalAmount,
  });
}

class _FruitStoreFormState extends State<FruitStoreForm> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _quantityController = TextEditingController(text: '1');

  String? _selectedFruit;
  final List<Map<String, dynamic>> _fruits = [
    {'name': 'Apple', 'price': 50},
    {'name': 'Banana', 'price': 30},
    {'name': 'Mango', 'price': 80},
    {'name': 'Orange', 'price': 60},
    {'name': 'Grapes', 'price': 120},
  ];

  bool _honeyDip = false;
  bool _ecoBag = false;
  bool _chocolateCoating = false;
  bool _icePack = false;

  bool _expressDelivery = false;
  bool _cashOnDelivery = false;
  bool _organicOnly = false;

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  final List<Order> _submittedOrders = [];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  double _calculateTotal() {
    if (_selectedFruit == null) return 0;

    // Get fruit price
    final fruitData =
        _fruits.firstWhere((fruit) => fruit['name'] == _selectedFruit);
    double basePrice = (fruitData['price'] as int).toDouble();
    int quantity = int.tryParse(_quantityController.text) ?? 1;
    double subtotal = basePrice * quantity;

    // Add checkbox add-ons with updated prices
    if (_honeyDip) subtotal += 20;
    if (_ecoBag) subtotal += 10;
    if (_chocolateCoating) subtotal += 30;
    if (_icePack) subtotal += 15;

    // Add express delivery fee (reduced to ₱50)
    if (_expressDelivery) subtotal += 50;

    // Add organic fee (₱10 per item instead of discount)
    if (_organicOnly) {
      subtotal += (10 * quantity);
    }

    return subtotal;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_selectedFruit == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a fruit')),
        );
        return;
      }

      if (_selectedDate == null || _selectedTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select delivery date and time')),
        );
        return;
      }

      final order = Order(
        name: _nameController.text,
        email: _emailController.text,
        fruit: _selectedFruit!,
        quantity: int.parse(_quantityController.text),
        honeyDip: _honeyDip,
        ecoBag: _ecoBag,
        chocolateCoating: _chocolateCoating,
        icePack: _icePack,
        expressDelivery: _expressDelivery,
        cashOnDelivery: _cashOnDelivery,
        organicOnly: _organicOnly,
        deliveryDate:
            '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
        deliveryTime: _selectedTime!.format(context),
        totalAmount: _calculateTotal(),
      );

      setState(() {
        _submittedOrders.add(order);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Order submitted successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      _formKey.currentState!.reset();
      _nameController.clear();
      _emailController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();
      _quantityController.text = '1';
      setState(() {
        _selectedFruit = null;
        _honeyDip = false;
        _ecoBag = false;
        _chocolateCoating = false;
        _icePack = false;
        _expressDelivery = false;
        _cashOnDelivery = false;
        _organicOnly = false;
        _selectedDate = null;
        _selectedTime = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🍉 Fruit Store Ordering & Payment System'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Customer Information',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Email must contain @';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password cannot be empty';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              const Text(
                'Fruit Selection',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedFruit,
                decoration: const InputDecoration(
                  labelText: 'Select Fruit',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.apple),
                ),
                items: _fruits.map((fruit) {
                  return DropdownMenuItem<String>(
                    value: fruit['name'],
                    child: Text('${fruit['name']} - ₱${fruit['price']}'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedFruit = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.numbers),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter quantity';
                  }
                  final quantity = int.tryParse(value);
                  if (quantity == null || quantity < 1) {
                    return 'Quantity must be at least 1';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              const Text(
                '📦 Customer Add-ons',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              CheckboxListTile(
                title: const Text('🍯 Add Honey Dip (₱20)'),
                value: _honeyDip,
                onChanged: (value) {
                  setState(() {
                    _honeyDip = value ?? false;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('🧺 Eco Bag (₱10)'),
                value: _ecoBag,
                onChanged: (value) {
                  setState(() {
                    _ecoBag = value ?? false;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('🍫 Add Chocolate Coating (₱30)'),
                value: _chocolateCoating,
                onChanged: (value) {
                  setState(() {
                    _chocolateCoating = value ?? false;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('❄️ Add Ice Pack (₱15)'),
                value: _icePack,
                onChanged: (value) {
                  setState(() {
                    _icePack = value ?? false;
                  });
                },
              ),
              const SizedBox(height: 24),
              const Text(
                '⚡ Service Options',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                title: const Text('🚚 Express Delivery (+₱50)'),
                subtitle: const Text('Get your order faster'),
                value: _expressDelivery,
                onChanged: (value) {
                  setState(() {
                    _expressDelivery = value;
                  });
                },
              ),
              SwitchListTile(
                title: const Text('💳 Cash on Delivery (COD)'),
                subtitle: const Text('Pay when you receive'),
                value: _cashOnDelivery,
                onChanged: (value) {
                  setState(() {
                    _cashOnDelivery = value;
                  });
                },
              ),
              SwitchListTile(
                title: const Text('🌱 Organic Only (+₱10 per item)'),
                subtitle: const Text('Premium organic fruits'),
                value: _organicOnly,
                onChanged: (value) {
                  setState(() {
                    _organicOnly = value;
                  });
                },
              ),
              const SizedBox(height: 24),
              const Text(
                'Delivery Schedule',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ListTile(
                title: Text(
                  _selectedDate == null
                      ? 'Select Delivery Date'
                      : 'Date: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                ),
                leading: const Icon(Icons.calendar_today),
                tileColor: Colors.grey[100],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                onTap: () => _selectDate(context),
              ),
              const SizedBox(height: 16),
              ListTile(
                title: Text(
                  _selectedTime == null
                      ? 'Select Delivery Time'
                      : 'Time: ${_selectedTime!.format(context)}',
                ),
                leading: const Icon(Icons.access_time),
                tileColor: Colors.grey[100],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                onTap: () => _selectTime(context),
              ),
              const SizedBox(height: 24),
              if (_selectedFruit != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Amount:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '₱${_calculateTotal().toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    'Submit Order',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              if (_submittedOrders.isNotEmpty) ...[
                const Divider(thickness: 2),
                const SizedBox(height: 16),
                const Text(
                  'Submitted Orders',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _submittedOrders.length,
                  itemBuilder: (context, index) {
                    final order = _submittedOrders[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Order #${index + 1}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            const Divider(),
                            _buildOrderDetail('Customer', order.name),
                            _buildOrderDetail('Email', order.email),
                            _buildOrderDetail('Fruit', order.fruit),
                            _buildOrderDetail('Quantity', '${order.quantity}'),
                            const SizedBox(height: 8),
                            if (order.honeyDip ||
                                order.ecoBag ||
                                order.chocolateCoating ||
                                order.icePack) ...[
                              const Text(
                                'Add-ons:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              if (order.honeyDip)
                                const Text('  • 🍯 Honey Dip (+₱20)'),
                              if (order.ecoBag)
                                const Text('  • 🧺 Eco Bag (+₱10)'),
                              if (order.chocolateCoating)
                                const Text('  • 🍫 Chocolate Coating (+₱30)'),
                              if (order.icePack)
                                const Text('  • ❄️ Ice Pack (+₱15)'),
                              const SizedBox(height: 8),
                            ],
                            if (order.expressDelivery ||
                                order.cashOnDelivery ||
                                order.organicOnly) ...[
                              const Text(
                                'Service Options:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              if (order.expressDelivery)
                                const Text('  • 🚚 Express Delivery (+₱50)'),
                              if (order.cashOnDelivery)
                                const Text('  • 💳 Cash on Delivery'),
                              if (order.organicOnly)
                                const Text(
                                    '  • 🌱 Organic Only (+₱10 per item)'),
                              const SizedBox(height: 8),
                            ],
                            _buildOrderDetail(
                                'Delivery Date', order.deliveryDate),
                            _buildOrderDetail(
                                'Delivery Time', order.deliveryTime),
                            _buildOrderDetail(
                                'Payment Method',
                                order.cashOnDelivery
                                    ? 'Cash on Delivery'
                                    : 'Pay Online'),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Total Amount:',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '₱${order.totalAmount.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
