import 'package:flutter/material.dart';
// TODO: Add 'percent_indicator' package for beautiful progress indicators
// TODO: Add 'flutter_animate' for card entrance animations

class ProgressCardWidget extends StatelessWidget {
  final String title;
  final int value;
  final int? total;
  final Color color;
  final IconData icon;

  const ProgressCardWidget({
    super.key,
    required this.title,
    required this.value,
    this.total,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    final withOpacity = color.withOpacity(0.1);
    return Card(
      // TODO: Use 'glassmorphism' package for frosted glass effect
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              // ignore: deprecated_member_use
              withOpacity,
              // ignore: deprecated_member_use
              color.withOpacity(0.05),
            ],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize
              .min, // Added mainAxisSize.min to prevent unbounded height issues
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
                // TODO: Add 'percent_indicator' circular progress here
              ],
            ),
            const SizedBox(
                height: 16), // Replaced Spacer with SizedBox for fixed spacing
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              total != null ? '$value/$total' : '$value',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            if (total != null) ...[
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: total! > 0 ? value / total! : 0,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(color),
                // TODO: Replace with percent_indicator for better styling
              ),
            ],
          ],
        ),
      ),
    );
  }
}
