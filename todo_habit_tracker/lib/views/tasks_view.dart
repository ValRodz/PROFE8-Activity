import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/task.dart';
import '../services/storage_service.dart';
import '../widgets/category_navigation_widget.dart';
import '../widgets/priority_filter_widget.dart';
import '../widgets/priority_selector_widget.dart';

class TasksView extends StatefulWidget {
  const TasksView({super.key});

  @override
  State<TasksView> createState() => _TasksViewState();
}

class _TasksViewState extends State<TasksView> {
  List<Task> _tasks = [];
  bool _isLoading = true;
  String _selectedCategory = 'All';
  TaskPriority? _selectedPriority; // Added priority filtering

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final List<Task> tasks = await StorageService.getTasks();
    setState(() {
      _tasks = tasks;
      _isLoading = false;
    });
  }

  List<Task> get _filteredTasks {
    var filtered = _tasks;

    // Filter by category
    if (_selectedCategory != 'All') {
      filtered =
          filtered.where((task) => task.category == _selectedCategory).toList();
    }

    // Filter by priority
    if (_selectedPriority != null) {
      filtered =
          filtered.where((task) => task.priority == _selectedPriority).toList();
    }

    // Sort by priority (urgent first, then high, medium, low)
    filtered.sort((a, b) {
      final priorityOrder = {
        TaskPriority.urgent: 0,
        TaskPriority.high: 1,
        TaskPriority.medium: 2,
        TaskPriority.low: 3,
      };
      return priorityOrder[a.priority]!.compareTo(priorityOrder[b.priority]!);
    });

    return filtered;
  }

  Map<String, int> get _categoryCounts {
    final counts = <String, int>{};
    counts['All'] = _tasks.length;

    for (final task in _tasks) {
      counts[task.category] = (counts[task.category] ?? 0) + 1;
    }

    return counts;
  }

  Map<TaskPriority, int> get _priorityCounts {
    final counts = <TaskPriority, int>{};

    for (final task in _tasks) {
      counts[task.priority] = (counts[task.priority] ?? 0) + 1;
    }

    return counts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tasks',
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
          : Column(
              children: [
                CategoryNavigationWidget(
                  selectedCategory: _selectedCategory,
                  onCategorySelected: (category) {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                  categoryCounts: _categoryCounts,
                ),
                PriorityFilterWidget(
                  selectedPriority: _selectedPriority,
                  onPrioritySelected: (priority) {
                    setState(() {
                      _selectedPriority = priority;
                    });
                  },
                  priorityCounts: _priorityCounts,
                ),
                Expanded(
                  child: _filteredTasks.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.task_alt,
                                size: 64,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _getEmptyMessage(),
                                style: GoogleFonts.preahvihear(
                                  fontSize: 18,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Tap the + button to create your first task',
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
                          itemCount: _filteredTasks.length,
                          itemBuilder: (context, index) {
                            final task = _filteredTasks[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: ListTile(
                                leading: Checkbox(
                                  value: task.isCompleted,
                                  onChanged: (value) async {
                                    final taskIndex = _tasks
                                        .indexWhere((t) => t.id == task.id);
                                    if (taskIndex != -1) {
                                      final updatedTask = task.copyWith(
                                          isCompleted: value ?? false);
                                      _tasks[taskIndex] = updatedTask;
                                      await StorageService.saveTasks(_tasks);
                                      setState(() {});
                                    }
                                  },
                                  activeColor: const Color(0xFFFF0061),
                                ),
                                title: Text(
                                  task.title,
                                  style: TextStyle(
                                    decoration: task.isCompleted
                                        ? TextDecoration.lineThrough
                                        : null,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (task.description.isNotEmpty)
                                      Text(task.description),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: _getCategoryColor(
                                                task.category),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            task.category,
                                            style: const TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: _getPriorityColor(
                                                task.priority),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            task.priority.name.toUpperCase(),
                                            style: const TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                trailing: task.dueDate != null
                                    ? Chip(
                                        label: Text(
                                          '${task.dueDate!.day}/${task.dueDate!.month}',
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                        backgroundColor:
                                            const Color(0xFFCADBFC),
                                      )
                                    : null,
                              ),
                            )
                                .animate()
                                .fadeIn(delay: (index * 100).ms)
                                .slideX();
                          },
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(),
        backgroundColor: const Color(0xFFFF0061),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  String _getEmptyMessage() {
    if (_selectedCategory != 'All' && _selectedPriority != null) {
      return 'No $_selectedCategory ${_selectedPriority!.name} priority tasks';
    } else if (_selectedCategory != 'All') {
      return 'No $_selectedCategory tasks';
    } else if (_selectedPriority != null) {
      return 'No ${_selectedPriority!.name} priority tasks';
    } else {
      return 'No tasks yet';
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Work':
        return const Color(0xFF2196F3);
      case 'Personal':
        return const Color(0xFF4CAF50);
      case 'Health':
        return const Color(0xFFE91E63);
      case 'Learning':
        return const Color(0xFF9C27B0);
      default:
        return const Color(0xFF607D8B);
    }
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

  void _showAddTaskDialog() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    DateTime? selectedDate;
    String selectedCategory =
        _selectedCategory == 'All' ? 'Personal' : _selectedCategory;
    TaskPriority selectedPriority = TaskPriority.medium;

    showDialog<void>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Add New Task', style: GoogleFonts.preahvihear()),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Task Title',
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
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  items: ['Work', 'Personal', 'Health', 'Learning']
                      .map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setDialogState(() {
                      selectedCategory = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                PrioritySelectorWidget(
                  selectedPriority: selectedPriority,
                  onPrioritySelected: (priority) {
                    setDialogState(() {
                      selectedPriority = priority;
                    });
                  },
                  isCompact: true,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        selectedDate == null
                            ? 'No due date'
                            : 'Due: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate:
                              DateTime.now().add(const Duration(days: 365)),
                        );
                        if (date != null) {
                          setDialogState(() {
                            selectedDate = date;
                          });
                        }
                      },
                      child: const Text('Pick Date'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (titleController.text.isNotEmpty) {
                  final navigator = Navigator.of(context);
                  final newTask = Task(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    title: titleController.text,
                    description: descriptionController.text,
                    isCompleted: false,
                    createdAt: DateTime.now(),
                    dueDate: selectedDate,
                    category: selectedCategory,
                    priority: selectedPriority,
                  );
                  _tasks.add(newTask);
                  await StorageService.saveTasks(_tasks);
                  setState(() {});
                  if (context.mounted) {
                    navigator.pop();
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF0061),
                foregroundColor: Colors.white,
              ),
              child: const Text('Add Task'),
            ),
          ],
        ),
      ),
    );
  }
}
