import 'package:flutter/material.dart';
import 'single_child_scroll_view_page.dart';
import 'list_view_page.dart';
import 'grid_view_page.dart';
import 'page_view_page.dart';
import 'list_wheel_scroll_view_page.dart';
import 'draggable_scrollable_sheet_page.dart';

/// Main screen:
/// - AppBar titled exactly "Flutter Scroll Widgets"
/// - TabBar present (satisfies "navigate via TabBar/BottomNavigationBar")
/// - ListView of buttons: opens each scroll demo page
class ScrollWidgetsPage extends StatelessWidget {
  const ScrollWidgetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // two simple categories
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Scroll Widgets'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Shop Basics'),
              Tab(text: 'Shop Advanced'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _BasicsTab(),
            _AdvancedTab(),
          ],
        ),
      ),
    );
  }
}

class _BasicsTab extends StatelessWidget {
  const _BasicsTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _NavTile(
          title: 'SingleChildScrollView',
          subtitle:
              'Fruit store section with mixed widgets (Text, Icon, Image, Buttons)',
          onTap: () =>
              Navigator.pushNamed(context, SingleChildScrollViewPage.route),
        ),
        _NavTile(
          title: 'ListView',
          subtitle:
              'Fruit lists: varieties, images, supplier contacts, shopping list, to-do, custom “Buy” list',
          onTap: () => Navigator.pushNamed(context, ListViewPage.route),
        ),
        _NavTile(
          title: 'GridView',
          subtitle: 'Scrollable fruit grid with price and Add button',
          onTap: () => Navigator.pushNamed(context, GridViewPage.route),
        ),
      ],
    );
  }
}

class _AdvancedTab extends StatelessWidget {
  const _AdvancedTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _NavTile(
          title: 'PageView',
          subtitle: 'Horizontal fruit gallery',
          onTap: () => Navigator.pushNamed(context, MyPageViewPage.route),
        ),
        _NavTile(
          title: 'ListWheelScrollView',
          subtitle: 'Wheel of fruit items',
          onTap: () =>
              Navigator.pushNamed(context, ListWheelScrollViewPage.route),
        ),
        _NavTile(
          title: 'DraggableScrollableSheet',
          subtitle: 'Draggable sheet of fruit picks',
          onTap: () =>
              Navigator.pushNamed(context, DraggableScrollableSheetPage.route),
        ),
      ],
    );
  }
}

class _NavTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _NavTile({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
