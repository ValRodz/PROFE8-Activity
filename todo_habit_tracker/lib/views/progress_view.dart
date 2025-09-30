import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/task.dart';
import '../models/habit.dart';
import '../services/storage_service.dart';

class ProgressView extends StatefulWidget {
  const ProgressView({super.key});

  @override
  State<ProgressView> createState() => _ProgressViewState();
}

class _ProgressViewState extends State<ProgressView> {
  List<Task> _tasks = [];
  List<Habit> _habits = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final tasks = await StorageService.getTasks();
    final habits = await StorageService.getHabits();
    setState(() {
      _tasks = tasks;
      _habits = habits;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Progress',
          style: GoogleFonts.preahvihear(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Progress Overview',
                    style: GoogleFonts.preahvihear(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFEBBCFC),
                    ),
                  ).animate().fadeIn().slideX(),
                  const SizedBox(height: 24),

                  // Stats Cards
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          'Total Tasks',
                          _tasks.length.toString(),
                          Icons.task_alt,
                          const Color(0xFFCADBFC),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatCard(
                          'Completed',
                          _tasks.where((t) => t.isCompleted).length.toString(),
                          Icons.check_circle,
                          const Color(0xFFFF0061),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          'Total Habits',
                          _habits.length.toString(),
                          Icons.track_changes,
                          const Color(0xFFEBBCFC),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatCard(
                          'Best Streak',
                          _getBestStreak().toString(),
                          Icons.local_fire_department,
                          const Color(0xFFF9EAFE),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Completion Rate Chart
                  Text(
                    'Task Completion Rate',
                    style: GoogleFonts.preahvihear(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 200,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          // ignore: deprecated_member_use
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: _buildCompletionChart(),
                  ).animate().fadeIn(delay: 400.ms).scale(),
                ],
              ),
            ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.preahvihear(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: GoogleFonts.preahvihear(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCompletionChart() {
    final completedTasks = _tasks.where((t) => t.isCompleted).length;
    final totalTasks = _tasks.length;

    if (totalTasks == 0) {
      return Center(
        child: Text(
          'No tasks to show',
          style: GoogleFonts.preahvihear(color: Colors.grey.shade600),
        ),
      );
    }

    final completionRate = completedTasks / totalTasks;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 120,
              height: 120,
              child: CircularProgressIndicator(
                value: completionRate,
                strokeWidth: 12,
                backgroundColor: const Color(0xFFCADBFC).withValues(alpha: 0.3),
                valueColor:
                    const AlwaysStoppedAnimation<Color>(Color(0xFFFF0061)),
              ),
            ),
            Column(
              children: [
                Text(
                  '${(completionRate * 100).toInt()}%',
                  style: GoogleFonts.preahvihear(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFFF0061),
                  ),
                ),
                Text(
                  'Complete',
                  style: GoogleFonts.preahvihear(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildLegendItem(
                'Completed', completedTasks, const Color(0xFFFF0061)),
            _buildLegendItem('Pending', totalTasks - completedTasks,
                const Color(0xFFCADBFC)),
          ],
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, int value, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '$label: $value',
          style: GoogleFonts.preahvihear(
            fontSize: 12,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }

  int _getBestStreak() {
    if (_habits.isEmpty) {
      return 0;
    }
    return _habits
        .map((habit) => habit.bestStreak)
        .reduce((a, b) => a > b ? a : b);
  }
}
