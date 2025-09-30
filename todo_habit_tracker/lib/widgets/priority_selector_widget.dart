import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/task.dart';

class PrioritySelectorWidget extends StatelessWidget {
  final TaskPriority selectedPriority;
  final void Function(TaskPriority) onPrioritySelected;
  final bool isCompact;

  const PrioritySelectorWidget({
    super.key,
    required this.selectedPriority,
    required this.onPrioritySelected,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFEECF5).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: const Color(0xFFEBBCFC).withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isCompact) ...[
            Text(
              'Priority Level',
              style: GoogleFonts.preahvihear(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFFF0061),
              ),
            ),
            const SizedBox(height: 12),
          ],
          Column(
            children: [
              // First row: High and Medium
              Row(
                children: [
                  Expanded(
                    child: _buildPriorityItem(
                      TaskPriority.high,
                      'High',
                      Icons.keyboard_arrow_up,
                      const Color(0xFFFF5722),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildPriorityItem(
                      TaskPriority.medium,
                      'Medium',
                      Icons.remove,
                      const Color(0xFFFF9800),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Second row: Urgent and Low
              Row(
                children: [
                  Expanded(
                    child: _buildPriorityItem(
                      TaskPriority.urgent,
                      'Urgent',
                      Icons.priority_high,
                      const Color(0xFFF44336),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildPriorityItem(
                      TaskPriority.low,
                      'Low',
                      Icons.keyboard_arrow_down,
                      const Color(0xFF4CAF50),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityItem(
    TaskPriority priority,
    String label,
    IconData icon,
    Color color,
  ) {
    final isSelected = selectedPriority == priority;

    return GestureDetector(
      onTap: () => onPrioritySelected(priority),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: color,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.3),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : color,
              size: isCompact ? 20 : 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.preahvihear(
                fontSize: isCompact ? 12 : 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
