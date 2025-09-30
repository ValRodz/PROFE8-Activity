import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/task.dart';
import '../models/habit.dart';
import '../widgets/bottom_navigation_widget.dart';
import '../widgets/progress_card_widget.dart';
import '../widgets/quick_stats_widget.dart';
import '../widgets/status_header_widget.dart';
import '../widgets/welcome_page_widget.dart';
import '../widgets/stack_layout_widget.dart';
import '../views/tasks_view.dart';
import '../views/habits_view.dart';
import '../views/progress_view.dart';
import '../views/profile_view.dart';
import '../views/notes_view.dart';
import '../services/storage_service.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 0;
  List<Task> _tasks = [];
  List<Habit> _habits = [];
  bool _isLoading = true;
  String _selectedStatus = 'Today';
  bool _showWelcomePage = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  List<Widget> get _screens => [
        _buildHomeScreen(),
        const TasksView(),
        const HabitsView(),
        const ProgressView(),
        const NotesView(),
        const ProfileView(),
      ];

  Future<void> _loadData() async {
    final tasks = await StorageService.getTasks();
    final habits = await StorageService.getHabits();

    setState(() {
      _tasks = tasks;
      _habits = habits;
      _isLoading = false;
      _showWelcomePage = tasks.isEmpty && habits.isEmpty;
    });
  }

  void _handleFabAction(String action) {
    switch (action) {
      case 'add_task':
        setState(() {
          _currentIndex = 1; // Navigate to Tasks view
        });
        break;
      case 'add_habit':
        setState(() {
          _currentIndex = 2; // Navigate to Habits view
        });
        break;
      case 'add_note':
        setState(() {
          _currentIndex = 4; // Navigate to Notes view
        });
        break;
      case 'filter_tasks':
        _showFilterDialog();
        break;
      case 'view_stats':
        setState(() {
          _currentIndex = 3; // Navigate to Progress view
        });
        break;
      case 'refresh_progress':
        _loadData();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Progress refreshed!')),
        );
        break;
      case 'share_progress':
        _shareProgress();
        break;
      case 'search_notes':
        _showSearchDialog();
        break;
      case 'edit_profile':
        _showEditProfileDialog();
        break;
      case 'settings':
        _showSettingsDialog();
        break;
    }
  }

  void _showFilterDialog() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Tasks'),
        content: const Text('Filter functionality coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _shareProgress() {
    final completedTasks = _tasks.where((task) => task.isCompleted).length;
    final totalTasks = _tasks.length;
    final completedHabits = _getHabitsCompletedToday();
    final totalHabits = _habits.length;

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Share Progress'),
        content: Text(
          'My productivity today:\n'
          '✅ Tasks: $completedTasks/$totalTasks completed\n'
          '🎯 Habits: $completedHabits/$totalHabits completed\n'
          '🔥 Best streak: ${_getBestStreak()} days',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Progress shared!')),
              );
            },
            child: const Text('Share'),
          ),
        ],
      ),
    );
  }

  void _showSearchDialog() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Notes'),
        content: const TextField(
          decoration: InputDecoration(
            hintText: 'Search your notes...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  void _showEditProfileDialog() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: const Text('Profile editing functionality coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSettingsDialog() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Notifications'),
              trailing: Switch(
                value: true,
                onChanged: (value) {},
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dark_mode),
              title: const Text('Dark Mode'),
              trailing: Switch(
                value: false,
                onChanged: (value) {},
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StackLayoutWidget(
        currentIndex: _currentIndex,
        onFabAction: _handleFabAction,
        child: _screens[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationWidget(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildHomeScreen() {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Todo Habit Tracker',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFFEECF5),
        elevation: 0,
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(
              child: Shimmer.fromColors(
                baseColor: const Color(0xFFCADBFC),
                highlightColor: const Color(0xFFF9EAFE),
                child: const CircularProgressIndicator(),
              ),
            )
          : _showWelcomePage
              ? WelcomePageWidget(
                  userName: 'User',
                  onAddTask: () {
                    setState(() {
                      _currentIndex = 1;
                      _showWelcomePage = false;
                    });
                  },
                  onClearAll: () {
                    _showClearAllDialog();
                  },
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StatusHeaderWidget(
                        todayCount: _getTodayTasksCount(),
                        upcomingCount: _getUpcomingTasksCount(),
                        completedCount: _getCompletedTasksCount(),
                        selectedStatus: _selectedStatus,
                        onStatusTap: (status) {
                          setState(() {
                            _selectedStatus = status;
                          });
                        },
                      ),
                      SizedBox(
                        height: 120,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  _currentIndex = 1;
                                });
                              },
                              icon: const Icon(Icons.add_task),
                              label: const Text('Add New Task'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFCADBFC),
                                foregroundColor: Colors.black87,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  _currentIndex = 2;
                                });
                              },
                              icon: const Icon(Icons.track_changes),
                              label: const Text('Add New Habit'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFEBBCFC),
                                foregroundColor: Colors.black87,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                          .animate()
                          .fadeIn(delay: 300.ms, duration: 600.ms)
                          .slideY(begin: 0.3, end: 0),
                      const SizedBox(height: 24),
                      QuickStatsWidget(tasks: _tasks, habits: _habits)
                          .animate()
                          .fadeIn(delay: 400.ms, duration: 600.ms)
                          .slideY(begin: 0.2, end: 0),
                      const SizedBox(height: 24),
                      StaggeredGrid.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        children: [
                          StaggeredGridTile.count(
                            crossAxisCellCount: 1,
                            mainAxisCellCount: 1,
                            child: ProgressCardWidget(
                              title: 'Tasks Today',
                              value: _getTasksCompletedToday(),
                              total: _getTasksDueToday(),
                              color: const Color(0xFFCADBFC),
                              icon: Icons.task_alt,
                            )
                                .animate()
                                .fadeIn(delay: 600.ms, duration: 600.ms)
                                .scale(),
                          ),
                          StaggeredGridTile.count(
                            crossAxisCellCount: 1,
                            mainAxisCellCount: 1,
                            child: ProgressCardWidget(
                              title: 'Habits',
                              value: _getHabitsCompletedToday(),
                              total: _habits.length,
                              color: const Color(0xFFEBBCFC),
                              icon: Icons.track_changes,
                            )
                                .animate()
                                .fadeIn(delay: 700.ms, duration: 600.ms)
                                .scale(),
                          ),
                          StaggeredGridTile.count(
                            crossAxisCellCount: 1,
                            mainAxisCellCount: 1,
                            child: ProgressCardWidget(
                              title: 'Streak',
                              value: _getBestStreak(),
                              total: null,
                              color: const Color(0xFFFF0061),
                              icon: Icons.local_fire_department,
                            )
                                .animate()
                                .fadeIn(delay: 800.ms, duration: 600.ms)
                                .scale(),
                          ),
                          StaggeredGridTile.count(
                            crossAxisCellCount: 1,
                            mainAxisCellCount: 1,
                            child: ProgressCardWidget(
                              title: 'Productivity',
                              value: _getProductivityScore(),
                              total: 100,
                              color: const Color(0xFFF9EAFE),
                              icon: Icons.trending_up,
                            )
                                .animate()
                                .fadeIn(delay: 900.ms, duration: 600.ms)
                                .scale(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
    );
  }

  int _getTodayTasksCount() {
    final today = DateTime.now();
    return _tasks
        .where((task) =>
            !task.isCompleted &&
            task.dueDate != null &&
            task.dueDate!.day == today.day &&
            task.dueDate!.month == today.month &&
            task.dueDate!.year == today.year)
        .length;
  }

  int _getUpcomingTasksCount() {
    final today = DateTime.now();
    return _tasks
        .where((task) =>
            !task.isCompleted &&
            task.dueDate != null &&
            task.dueDate!.isAfter(today))
        .length;
  }

  int _getCompletedTasksCount() {
    return _tasks.where((task) => task.isCompleted).length;
  }

  void _showClearAllDialog() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Clear All Tasks'),
          content: const Text(
              'Are you sure you want to clear all tasks and habits? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final navigator = Navigator.of(context);
                await StorageService.clearAllTasks();
                await StorageService.clearAllHabits();
                navigator.pop();
                if (mounted) {
                  await _loadData();
                }
              },
              child:
                  const Text('Clear All', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  int _getTasksCompletedToday() {
    final today = DateTime.now();
    return _tasks
        .where((task) =>
            task.isCompleted &&
            task.createdAt.day == today.day &&
            task.createdAt.month == today.month &&
            task.createdAt.year == today.year)
        .length;
  }

  int _getTasksDueToday() {
    final today = DateTime.now();
    return _tasks
        .where((task) =>
            task.dueDate != null &&
            task.dueDate!.day == today.day &&
            task.dueDate!.month == today.month &&
            task.dueDate!.year == today.year)
        .length;
  }

  int _getHabitsCompletedToday() {
    return _habits.where((habit) => habit.isCompletedToday()).length;
  }

  int _getBestStreak() {
    if (_habits.isEmpty) {
      return 0;
    }
    return _habits
        .map((habit) => habit.bestStreak)
        .reduce((a, b) => a > b ? a : b);
  }

  int _getProductivityScore() {
    if (_tasks.isEmpty && _habits.isEmpty) {
      return 0;
    }

    final completedTasks = _tasks.where((task) => task.isCompleted).length;
    final completedHabits = _getHabitsCompletedToday();
    final totalItems = _tasks.length + _habits.length;

    if (totalItems == 0) {
      return 0;
    }
    return ((completedTasks + completedHabits) / totalItems * 100).round();
  }
}
