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
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/about': (context) => const AboutScreen(),
        '/contact': (context) => const ContactScreen(),
      },
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _usePushReplacement = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      // Demonstrate push() vs pushReplacement()
      if (_usePushReplacement) {
        // User cannot go back to login screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        // User can go back to login screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🍉 Fruit Store Login'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.shopping_basket,
                  size: 100,
                  color: Colors.green,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Welcome to Fruit Store',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 32),
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
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                SwitchListTile(
                  title: const Text('Use pushReplacement()'),
                  subtitle: const Text(
                    'ON: Cannot go back to login\nOFF: Can go back to login',
                  ),
                  value: _usePushReplacement,
                  onChanged: (value) {
                    setState(() {
                      _usePushReplacement = value;
                    });
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const WelcomeScreen(),
    const ShopScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🍉 Fruit Store'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.shopping_basket,
                    size: 60,
                    color: Colors.white,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Fruit Store',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/home');
              },
            ),
            ListTile(
              leading: const Icon(Icons.receipt_long),
              title: const Text('Orders'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const OrdersScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.contact_mail),
              title: const Text('Contact Us'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/contact');
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/about');
              },
            ),
          ],
        ),
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.shopping_basket,
              size: 120,
              color: Colors.green,
            ),
            const SizedBox(height: 24),
            const Text(
              'Welcome to Fruit Store!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'Fresh fruits delivered to your doorstep',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                children: [
                  Text(
                    '🎉 Special Promotions',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text('🍎 Apples - Buy 2 Get 1 Free'),
                  Text('🍌 Bananas - 20% Off'),
                  Text('🥭 Mangoes - Fresh Harvest'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
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

    final fruitData =
        _fruits.firstWhere((fruit) => fruit['name'] == _selectedFruit);
    double basePrice = (fruitData['price'] as int).toDouble();
    int quantity = int.tryParse(_quantityController.text) ?? 1;
    double subtotal = basePrice * quantity;

    if (_honeyDip) subtotal += 20;
    if (_ecoBag) subtotal += 10;
    if (_chocolateCoating) subtotal += 30;
    if (_icePack) subtotal += 15;

    if (_expressDelivery) subtotal += 50;

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
        status: 'Current',
      );

      OrderStorage.addOrder(order);

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
    return SingleChildScrollView(
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
          ],
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.chat), text: 'Chats'),
              Tab(icon: Icon(Icons.circle), text: 'Status'),
              Tab(icon: Icon(Icons.call), text: 'Calls'),
            ],
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
          ),
        ),
        body: const TabBarView(
          children: [
            ChatsTab(),
            StatusTab(),
            CallsTab(),
          ],
        ),
      ),
    );
  }
}

class ChatsTab extends StatelessWidget {
  const ChatsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.green,
            child: Icon(Icons.support_agent, color: Colors.white),
          ),
          title: Text('Customer Support'),
          subtitle: Text('How can we help you today?'),
          trailing: Text('10:30 AM'),
        ),
        Divider(),
        ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.orange,
            child: Icon(Icons.local_shipping, color: Colors.white),
          ),
          title: Text('Delivery Updates'),
          subtitle: Text('Your order is on the way!'),
          trailing: Text('Yesterday'),
        ),
      ],
    );
  }
}

class StatusTab extends StatelessWidget {
  const StatusTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Order Status Updates',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildStatusItem(
                    'Order Confirmed', '2 hours ago', Colors.green),
                _buildStatusItem('Preparing Order', '1 hour ago', Colors.blue),
                _buildStatusItem(
                    'Out for Delivery', '30 mins ago', Colors.orange),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusItem(String title, String time, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  time,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CallsTab extends StatelessWidget {
  const CallsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.phone,
              size: 80,
              color: Colors.green,
            ),
            const SizedBox(height: 24),
            const Text(
              'Store Hotline',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '📞 1-800-FRUITS',
              style: TextStyle(
                fontSize: 20,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Available 24/7',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.call),
              label: const Text('Call Now'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Orders'),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Current Orders'),
              Tab(text: 'Completed Orders'),
            ],
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
          ),
        ),
        body: TabBarView(
          children: [
            OrderListView(
              orders: OrderStorage.orders
                  .where((order) => order.status == 'Current')
                  .toList(),
              emptyMessage: 'No current orders',
            ),
            OrderListView(
              orders: OrderStorage.orders
                  .where((order) => order.status == 'Completed')
                  .toList(),
              emptyMessage: 'No completed orders',
            ),
          ],
        ),
      ),
    );
  }
}

class OrderListView extends StatelessWidget {
  final List<Order> orders;
  final String emptyMessage;

  const OrderListView({
    super.key,
    required this.orders,
    required this.emptyMessage,
  });

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return Center(
        child: Text(
          emptyMessage,
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
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
                  if (order.honeyDip) const Text('  • 🍯 Honey Dip (+₱20)'),
                  if (order.ecoBag) const Text('  • 🧺 Eco Bag (+₱10)'),
                  if (order.chocolateCoating)
                    const Text('  • 🍫 Chocolate Coating (+₱30)'),
                  if (order.icePack) const Text('  • ❄️ Ice Pack (+₱15)'),
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
                    const Text('  • 🌱 Organic Only (+₱10 per item)'),
                  const SizedBox(height: 8),
                ],
                _buildOrderDetail('Delivery Date', order.deliveryDate),
                _buildOrderDetail('Delivery Time', order.deliveryTime),
                _buildOrderDetail('Payment Method',
                    order.cashOnDelivery ? 'Cash on Delivery' : 'Pay Online'),
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

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Message sent successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      _formKey.currentState!.reset();
      _nameController.clear();
      _emailController.clear();
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Us'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Get in Touch',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'We\'d love to hear from you!',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
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
                controller: _messageController,
                decoration: const InputDecoration(
                  labelText: 'Message',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.message),
                  alignLabelWithHint: true,
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your message';
                  }
                  return null;
                },
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
                    'Send Message',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const Divider(),
              const SizedBox(height: 16),
              const Text(
                'Other Ways to Reach Us',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const ListTile(
                leading: Icon(Icons.phone, color: Colors.green),
                title: Text('Phone'),
                subtitle: Text('1-800-FRUITS'),
              ),
              const ListTile(
                leading: Icon(Icons.email, color: Colors.green),
                title: Text('Email'),
                subtitle: Text('support@fruitstore.com'),
              ),
              const ListTile(
                leading: Icon(Icons.location_on, color: Colors.green),
                title: Text('Address'),
                subtitle: Text('123 Fruit Street, Fresh City, FC 12345'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Icon(
                Icons.shopping_basket,
                size: 100,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'About Fruit Store',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            const Text(
              'Welcome to Fruit Store, your trusted source for fresh, high-quality fruits delivered right to your doorstep!',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              'Our Mission',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'We are committed to providing the freshest fruits sourced directly from local farms. Our goal is to make healthy eating convenient and accessible for everyone.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              'Why Choose Us?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildFeature(
                '🍎 Fresh Quality', 'Handpicked fruits from trusted farms'),
            _buildFeature('🚚 Fast Delivery', 'Same-day delivery available'),
            _buildFeature(
                '💚 Organic Options', 'Premium organic fruits available'),
            _buildFeature('💰 Best Prices',
                'Competitive pricing with regular promotions'),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                children: [
                  Text(
                    'Serving the community since 2020',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '10,000+ Happy Customers',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeature(String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  description,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
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
  final String status;

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
    required this.status,
  });
}

class OrderStorage {
  static final List<Order> orders = [];

  static void addOrder(Order order) {
    orders.add(order);
  }
}
