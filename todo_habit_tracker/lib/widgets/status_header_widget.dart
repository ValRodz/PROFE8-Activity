import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StatusHeaderWidget extends StatelessWidget {
  final int todayCount;
  final int upcomingCount;
  final int completedCount;
  final void Function(String) onStatusTap;
  final String selectedStatus;

  const StatusHeaderWidget({
    super.key,
    required this.todayCount,
    required this.upcomingCount,
    required this.completedCount,
    required this.onStatusTap,
    required this.selectedStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFEECF5), // Very light pink from palette
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: const Color(0xFFEBBCFC).withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: _buildStatusItem(
              'Today',
              todayCount,
              selectedStatus == 'Today',
              () => onStatusTap('Today'),
            ),
          ),
          Container(
            width: 1,
            height: 30,
            color: Colors.grey.shade300,
          ),
          Expanded(
            child: _buildStatusItem(
              'Upcoming',
              upcomingCount,
              selectedStatus == 'Upcoming',
              () => onStatusTap('Upcoming'),
            ),
          ),
          Container(
            width: 1,
            height: 30,
            color: Colors.grey.shade300,
          ),
          Expanded(
            child: _buildStatusItem(
              'Completed',
              completedCount,
              selectedStatus == 'Completed',
              () => onStatusTap('Completed'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusItem(
      String label, int count, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: GoogleFonts.preahvihear(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color:
                    isSelected ? const Color(0xFFFF0061) : Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFFF0061)
                    : const Color(0xFFCADBFC),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                count.toString(),
                style: GoogleFonts.preahvihear(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
