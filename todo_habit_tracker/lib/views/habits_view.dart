import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/habit.dart';
import '../services/storage_service.dart';

class HabitsView extends StatefulWidget {
  const HabitsView({super.key});

  @override
  State<HabitsView> createState() => _HabitsViewState();
}

class _HabitsViewState extends State<HabitsView> {
  List<Habit> _habits = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHabits();
  }

  Future<void> _loadHabits() async {
    final habits = await StorageService.getHabits();
    setState(() {
      _habits = habits;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Habits',
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
          : _habits.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.track_changes,
                        size: 64,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No habits yet',
                        style: GoogleFonts.preahvihear(
                          fontSize: 18,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tap the + button to create your first habit',
                        style: GoogleFonts.preahvihear(
                          fontSize: 14,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _habits.length,
                  itemBuilder: (context, index) {
                    final habit = _habits[index];
                    final isCompletedToday = habit.isCompletedToday();

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: isCompletedToday
                              ? const Color(0xFFFF0061)
                              : Colors.grey.shade300,
                          child: Icon(
                            isCompletedToday
                                ? Icons.check
                                : Icons.track_changes,
                            color: isCompletedToday
                                ? Colors.white
                                : Colors.grey.shade600,
                          ),
                        ),
                        title: Text(habit.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (habit.description.isNotEmpty)
                              Text(habit.description),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.local_fire_department,
                                    size: 16, color: Colors.orange),
                                const SizedBox(width: 4),
                                Flexible(
                                  child:
                                      Text('${habit.currentStreak} day streak'),
                                ),
                                const SizedBox(width: 16),
                                const Icon(Icons.star,
                                    size: 16, color: Colors.amber),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text('Best: ${habit.bestStreak}'),
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: ElevatedButton(
                          onPressed: isCompletedToday
                              ? null
                              : () async {
                                  final updatedHabit = habit.markCompleted();
                                  _habits[index] = updatedHabit;
                                  await StorageService.saveHabits(_habits);
                                  setState(() {});
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isCompletedToday
                                ? Colors.grey.shade300
                                : const Color(0xFFEBBCFC),
                            foregroundColor: isCompletedToday
                                ? Colors.grey.shade600
                                : Colors.black,
                          ),
                          child: Text(isCompletedToday ? 'Done' : 'Mark Done'),
                        ),
                      ),
                    ).animate().fadeIn(delay: (index * 100).ms).slideX();
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddHabitDialog(),
        backgroundColor: const Color(0xFFEBBCFC),
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }

  void _showAddHabitDialog() {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add New Habit', style: GoogleFonts.preahvihear()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Habit Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty) {
                final navigator = Navigator.of(context);
                final newHabit = Habit(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: nameController.text,
                  description: descriptionController.text,
                  createdAt: DateTime.now(),
                );
                _habits.add(newHabit);
                await StorageService.saveHabits(_habits);
                setState(() {});
                navigator.pop();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEBBCFC),
              foregroundColor: Colors.black,
            ),
            child: const Text('Add Habit'),
          ),
        ],
      ),
    );
  }
}
