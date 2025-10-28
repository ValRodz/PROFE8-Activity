import 'package:flutter/material.dart';
import '../models/fruit.dart';

/// Fruit-themed SingleChildScrollView:
/// Adds multiple sections so the page is nicely scrollable and store-like.
class SingleChildScrollViewPage extends StatelessWidget {
  static const route = '/single-child';

  const SingleChildScrollViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    const banner =
        'https://images.unsplash.com/photo-1490818387583-1baba5e638af?w=1600';

    return Scaffold(
      appBar: AppBar(title: const Text('SingleChildScrollView')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== HERO / PROMO =====
            const Text(
              'Fresh Fruit Specials',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Discover sweet deals and quick delivery.'),
            const SizedBox(height: 8),
            const Icon(Icons.local_grocery_store, size: 42),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                banner,
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 160,
                  color: Colors.black12,
                  alignment: Alignment.center,
                  child: const Icon(Icons.broken_image),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Expanded(
                  child: Text('Try our tropical picks today!'),
                ),
                FilledButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Opening fruit catalog…'),
                        duration: Duration(milliseconds: 900),
                      ),
                    );
                  },
                  icon: const Icon(Icons.shopping_cart_outlined),
                  label: const Text('Shop Fruits'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ===== CATEGORIES (chips) =====
            const Text(
              'Shop by Category',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _ChipBtn(label: 'Citrus'),
                _ChipBtn(label: 'Tropical'),
                _ChipBtn(label: 'Berries'),
                _ChipBtn(label: 'Stone Fruits'),
                _ChipBtn(label: 'Bananas'),
                _ChipBtn(label: 'Grapes'),
              ],
            ),
            const SizedBox(height: 24),

            // ===== FEATURED FRUITS (horizontal) =====
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Featured',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                Text('See all'),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 210,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(right: 4),
                itemCount: fruits.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (_, i) => _FeaturedFruitCard(fruit: fruits[i]),
              ),
            ),
            const SizedBox(height: 24),

            // ===== BENEFITS GRID =====
            const Text('Why choose us?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            GridView.count(
              crossAxisCount: 2,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2.8,
              children: const [
                _BenefitTile(
                    icon: Icons.eco_outlined, title: 'Farm-fresh quality'),
                _BenefitTile(
                    icon: Icons.local_shipping_outlined,
                    title: 'Fast delivery'),
                _BenefitTile(icon: Icons.star_outline, title: '4.8★ rated'),
                _BenefitTile(
                    icon: Icons.receipt_long_outlined, title: 'Fair pricing'),
              ],
            ),
            const SizedBox(height: 24),

            // ===== BUNDLES & PROMOS =====
            const Text('Bundles & Promos',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            _PromoCard(
              title: 'Breakfast Bundle',
              desc: 'Banana • Strawberry • Orange — save 15%',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Added Breakfast Bundle to cart')),
                );
              },
            ),
            const SizedBox(height: 10),
            _PromoCard(
              title: 'Tropical Treat',
              desc: 'Mango • Pineapple • Banana — save 10%',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Added Tropical Treat to cart')),
                );
              },
            ),
            const SizedBox(height: 24),

            // ===== FAQ (ExpansionTile) =====
            const Text('FAQs',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            const _FaqItem(
              q: 'How fast is delivery?',
              a: 'Most Metro Manila locations receive same-day delivery for orders before 3 PM.',
            ),
            const _FaqItem(
              q: 'Where do the fruits come from?',
              a: 'We source from local partner farms and trusted importers to ensure freshness.',
            ),
            const _FaqItem(
              q: 'Is there a minimum order?',
              a: 'No minimum—order as little or as much as you like.',
            ),
            const SizedBox(height: 24),

            // ===== TESTIMONIALS =====
            const Text('What customers say',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            const _Testimonial(
              text: '“The mangoes were the sweetest I’ve had this year!”',
              author: '— Mara, Pasig',
            ),
            const SizedBox(height: 8),
            const _Testimonial(
              text: '“Delivered fast and well packed. Will order again.”',
              author: '— Ken, Quezon City',
            ),
            const SizedBox(height: 24),

            // ===== NEWSLETTER / SIGN-UP =====
            const Text('Get weekly deals',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Enter your email',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  height: 44,
                  child: FilledButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Subscribed!')),
                      );
                    },
                    child: const Text('Subscribe'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            // ===== FINAL CTA =====
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.shopping_basket_outlined),
                label: const Text('Shop now'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Chip-style quick filter (no state needed; just feedback).
class _ChipBtn extends StatelessWidget {
  final String label;
  const _ChipBtn({required this.label});

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(label),
      avatar: const Icon(Icons.local_offer_outlined, size: 18),
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Filtering: $label')),
        );
      },
    );
  }
}

class _FeaturedFruitCard extends StatelessWidget {
  final Fruit fruit;
  const _FeaturedFruitCard({required this.fruit});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            child: Image.network(
              fruit.imageUrl,
              height: 110,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 110,
                color: Colors.black12,
                alignment: Alignment.center,
                child: const Icon(Icons.broken_image),
              ),
            ),
          ),
          // info
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 0),
            child: Text(
              fruit.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 2, 10, 8),
            child: Row(
              children: [
                Text(
                  fruit.price,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                SizedBox(
                  height: 30,
                  child: FilledButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Added ${fruit.name}')),
                      );
                    },
                    child: const Text('Add'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BenefitTile extends StatelessWidget {
  final IconData icon;
  final String title;
  const _BenefitTile({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 10),
          Expanded(child: Text(title)),
        ],
      ),
    );
  }
}

class _PromoCard extends StatelessWidget {
  final String title;
  final String desc;
  final VoidCallback onTap;
  const _PromoCard(
      {required this.title, required this.desc, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.local_offer_outlined),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(desc),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

class _FaqItem extends StatelessWidget {
  final String q;
  final String a;
  const _FaqItem({required this.q, required this.a});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      tilePadding: const EdgeInsets.symmetric(horizontal: 0),
      childrenPadding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
      title: Text(q, style: const TextStyle(fontWeight: FontWeight.w600)),
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(a),
        )
      ],
    );
  }
}

class _Testimonial extends StatelessWidget {
  final String text;
  final String author;
  const _Testimonial({required this.text, required this.author});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.person)),
        title: Text(text),
        subtitle: Text(author),
      ),
    );
  }
}
