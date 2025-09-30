import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/task.dart';

class PriorityFilterWidget extends StatelessWidget {
  final TaskPriority? selectedPriority;
  final void Function(TaskPriority?) onPrioritySelected;
  final Map<TaskPriority, int> priorityCounts;

  const PriorityFilterWidget({
    super.key,
    required this.selectedPriority,
    required this.onPrioritySelected,
    required this.priorityCounts,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // All priorities option
          Expanded(
            child: _buildFilterChip(
              'All',
              selectedPriority == null,
              priorityCounts.values.fold(0, (sum, count) => sum + count),
              const Color(0xFF607D8B),
              () => onPrioritySelected(null),
            ),
          ),
          const SizedBox(width: 8),
          ...TaskPriority.values.map((priority) {
            return Expanded(
              child: _buildFilterChip(
                priority.name.toUpperCase(),
                selectedPriority == priority,
                priorityCounts[priority] ?? 0,
                _getPriorityColor(priority),
                () => onPrioritySelected(priority),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    String label,
    bool isSelected,
    int count,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: GoogleFonts.preahvihear(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : color,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
            if (count > 0) ...[
              const SizedBox(height: 2),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withValues(alpha: 0.3)
                      : color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  count.toString(),
                  style: GoogleFonts.preahvihear(
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : color,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return const Color(0xFF4CAF50);
      case TaskPriority.medium:
        return const Color(0xFFFF9800);
      case TaskPriority.high:
        return const Color(0xFFFF5722);
      case TaskPriority.urgent:
        return const Color(0xFFF44336);
    }
  }
}
