import 'package:flutter/material.dart';
import '../models/fruit.dart';
import '../widgets/net_image.dart';

/// One page demonstrating multiple ListView patterns, all fruit-themed:
/// - Fruit varieties (vertical list)
/// - Internet images (Image.network inside ListView, now via NetImage)
/// - Supplier contacts (name, email, phone) as cards
/// - Shopping list with checkboxes (NEW)
/// - To-do list (TextField + add button)
/// - Custom product list with prices & “Buy” (overflow-free)
class ListViewPage extends StatefulWidget {
  static const route = '/list-view';
  const ListViewPage({super.key});

  @override
  State<ListViewPage> createState() => _ListViewPageState();
}

class _ListViewPageState extends State<ListViewPage>
    with TickerProviderStateMixin {
  late final TabController _tab;
  final _todoCtrl = TextEditingController();
  final List<String> _todos = ['Restock bananas', 'Update mango pricing'];

  // NEW: track which shopping items are checked
  late List<bool> _shoppingChecked;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 6, vsync: this);
    _shoppingChecked =
        List<bool>.filled(_shopping.length, false, growable: true);
  }

  @override
  void dispose() {
    _tab.dispose();
    _todoCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fruitPhotos = fruits.map((f) => f.imageUrl).toList();

    return Scaffold(
      appBar: AppBar(
        // Optional progress indicator in title (X/Y done)
        title: Text(
          'ListView Demos (${_shoppingChecked.where((c) => c).length}/${_shoppingChecked.length} done)',
        ),
        bottom: TabBar(
          controller: _tab,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Varieties'),
            Tab(text: 'Net Images'),
            Tab(text: 'Suppliers'),
            Tab(text: 'Shopping'),
            Tab(text: 'To-Do'),
            Tab(text: 'Buy List'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: [
          // ===== Varieties (uses NetImage inside a clipped avatar)
          ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: fruits.length,
            itemBuilder: (_, i) => ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: NetImage(
                  fruits[i].imageUrl,
                  width: 40,
                  height: 40,
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

          // ===== Net Images (pure images in a vertical list) — now robust
          ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: fruitPhotos.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (_, i) => NetImage(
              fruitPhotos[i],
              height: 160,
              borderRadius: BorderRadius.circular(12),
            ),
          ),

          // ===== Supplier contacts
          ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: _suppliers.length,
            itemBuilder: (_, i) => Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: CircleAvatar(child: Text(_suppliers[i].name[0])),
                title: Text(_suppliers[i].name),
                subtitle: Text(
                  'Email: ${_suppliers[i].email}\nPhone: ${_suppliers[i].phone}',
                ),
                isThreeLine: true,
              ),
            ),
          ),

          // ===== Shopping list with CHECKBOXES (NEW)
          ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: _shopping.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (_, i) {
              return CheckboxListTile(
                title: Text(
                  _shopping[i],
                  style: TextStyle(
                    decoration: _shoppingChecked[i]
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                value: _shoppingChecked[i],
                onChanged: (bool? value) {
                  setState(() {
                    _shoppingChecked[i] = value ?? false;
                  });
                },
                activeColor: Theme.of(context).colorScheme.primary,
                controlAffinity: ListTileControlAffinity.trailing,
              );
            },
          ),

          // ===== To-do list (TextField + add)
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _todoCtrl,
                        decoration: const InputDecoration(
                          hintText:
                              'Add a task (e.g., “Post strawberry promo”)',
                          border: OutlineInputBorder(),
                        ),
                        onSubmitted: (_) => _addTodo(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      height: 40,
                      child: FilledButton.icon(
                        onPressed: _addTodo,
                        icon: const Icon(Icons.add),
                        label: const Text('Add'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _todos.length,
                  itemBuilder: (_, i) => Dismissible(
                    key: ValueKey(_todos[i] + i.toString()),
                    onDismissed: (_) => setState(() => _todos.removeAt(i)),
                    background: Container(color: Colors.redAccent),
                    child: Card(
                      child: ListTile(
                        title: Text(_todos[i]),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => setState(() => _todos.removeAt(i)),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // ===== Buy List (custom Row layout — no more overflow)
          ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: fruits.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (_, i) => Card(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: NetImage(
                        fruits[i].imageUrl,
                        width: 56,
                        height: 56,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            fruits[i].name,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            fruits[i].description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 88,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            fruits[i].price,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 6),
                          SizedBox(
                            height: 32,
                            width: double.infinity,
                            child: FilledButton(
                              onPressed: () {},
                              child: const Text('Buy'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addTodo() {
    final text = _todoCtrl.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _todos.add(text);
      _todoCtrl.clear();
    });
  }
}

// Demo data for suppliers & shopping list (fruit-shop–themed)
class _Supplier {
  final String name;
  final String email;
  final String phone;
  const _Supplier(this.name, this.email, this.phone);
}

final _suppliers = <_Supplier>[
  const _Supplier('FarmCo Manila', 'hello@farmco.ph', '+63 912 345 6789'),
  const _Supplier(
      'Tropical Harvest', 'contact@tropicalharvest.ph', '+63 923 111 2222'),
  const _Supplier('Highland Orchards', 'sales@orchards.ph', '+63 934 333 4444'),
  const _Supplier(
      'FreshPoint Davao', 'orders@freshpoint.ph', '+63 915 555 7890'),
  const _Supplier(
      'Sunshine Produce', 'info@sunshineproduce.ph', '+63 927 888 1234'),
  const _Supplier(
      'Luzon Fruit Supply', 'support@luzonfruit.ph', '+63 919 222 5678'),
  const _Supplier(
      'Visayas Farmers Coop', 'coop@visfarmers.ph', '+63 920 333 8765'),
  const _Supplier(
      'Mindanao Organic Farms', 'organic@mindafarms.ph', '+63 917 444 6789'),
  const _Supplier(
      'MetroFruit Distributors', 'sales@metrofruit.ph', '+63 913 999 2222'),
  const _Supplier(
      'Pinoy Fresh Exports', 'exports@pinoyfresh.ph', '+63 926 101 3030'),
];

// Bigger shopping list so the tab is nicely scrollable
final _shopping = <String>[
  // Fresh stock
  'Restock apples',
  'Restock bananas',
  'Restock oranges',
  'Restock strawberries',
  'Restock mangoes',
  'Restock grapes',
  'Restock pineapples',
  'Restock blueberries',
  'Restock lemons',
  'Restock avocados',

  // Packaging & operations
  'Order mango crates',
  'Order berry clamshells',
  'Packaging boxes (medium)',
  'Packaging boxes (large)',
  'Paper bags',
  'Biodegradable liners',
  'Ice packs',
  'Banana ripening bags',
  'Price tags & stickers',
  'Label printer rolls',

  // Store supplies
  'Sanitizing wipes',
  'Hand gloves',
  'Twine & zip ties',
  'Shelf talkers',
  'Scotch tape',
  'Marker pens',
  'Thank-you cards',
];
