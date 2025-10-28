import 'package:flutter/material.dart';
import 'pages/scroll_widgets_page.dart';
import 'pages/single_child_scroll_view_page.dart';
import 'pages/list_view_page.dart';
import 'pages/grid_view_page.dart';
import 'pages/page_view_page.dart';
import 'pages/list_wheel_scroll_view_page.dart';
import 'pages/draggable_scrollable_sheet_page.dart';

void main() {
  runApp(const FruitScrollDemosApp());
}

class FruitScrollDemosApp extends StatelessWidget {
  const FruitScrollDemosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Scroll Widgets',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2ECC71)),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(centerTitle: true),
        cardTheme: const CardTheme(surfaceTintColor: Colors.white),
      ),
      // Main screen title matches the spec exactly:
      home: const ScrollWidgetsPage(),
      // Routes for each scroll demo:
      routes: {
        SingleChildScrollViewPage.route: (_) =>
            const SingleChildScrollViewPage(),
        ListViewPage.route: (_) => const ListViewPage(),
        GridViewPage.route: (_) => const GridViewPage(),
        MyPageViewPage.route: (_) => const MyPageViewPage(),
        ListWheelScrollViewPage.route: (_) => const ListWheelScrollViewPage(),
        DraggableScrollableSheetPage.route: (_) =>
            const DraggableScrollableSheetPage(),
      },
    );
  }
}
