import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryNavigationWidget extends StatelessWidget {
  final String selectedCategory;
  final void Function(String) onCategorySelected;
  final Map<String, int> categoryCounts;

  const CategoryNavigationWidget({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
    required this.categoryCounts,
  });

  @override
  Widget build(BuildContext context) {
    final categories = ['All', 'Work', 'Personal', 'Health', 'Learning'];

    return Container(
      height: 60,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: categories.map((category) {
          final isSelected = selectedCategory == category;
          final count = categoryCounts[category] ?? 0;

          return Expanded(
            child: GestureDetector(
              onTap: () => onCategorySelected(category),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFFFF0061)
                      : const Color(0xFFFEECF5),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFFFF0061)
                        : const Color(0xFFEBBCFC).withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _getCategoryIcon(category),
                          size: 16,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFFFF0061),
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            category,
                            style: GoogleFonts.preahvihear(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFFFF0061),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    if (count > 0) ...[
                      const SizedBox(height: 2),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.white.withValues(alpha: 0.3)
                              : const Color(0xFFCADBFC),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          count.toString(),
                          style: GoogleFonts.preahvihear(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Work':
        return Icons.work;
      case 'Personal':
        return Icons.person;
      case 'Health':
        return Icons.favorite;
      case 'Learning':
        return Icons.school;
      default:
        return Icons.apps;
    }
  }
}
