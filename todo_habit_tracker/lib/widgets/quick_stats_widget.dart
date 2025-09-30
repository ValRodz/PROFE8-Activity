import 'package:flutter/material.dart';
import '../models/task.dart';
import '../models/habit.dart';

class QuickStatsWidget extends StatelessWidget {
  final List<Task> tasks;
  final List<Habit> habits;

  const QuickStatsWidget({
    super.key,
    required this.tasks,
    required this.habits,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF6EC1E4), // lighter blue
            Color(0xFF4A90E2), // soft blue
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4A90E2).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            context,
            'Total Tasks',
            tasks.length.toString(),
            Icons.task_alt,
          ),
          Container(
            height: 40,
            width: 1,
            color: Colors.white.withValues(alpha: 0.3),
          ),
          _buildStatItem(
            context,
            'Active Habits',
            habits.length.toString(),
            Icons.track_changes,
          ),
          Container(
            height: 40,
            width: 1,
            color: Colors.white.withValues(alpha: 0.3),
          ),
          _buildStatItem(
            context,
            'Completed',
            tasks.where((Task task) => task.isCompleted).length.toString(),
            Icons.check_circle,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
      BuildContext context, String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.9),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
