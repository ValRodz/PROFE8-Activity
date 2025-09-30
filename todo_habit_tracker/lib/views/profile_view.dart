import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/user_profile.dart';
import '../models/task.dart';
import '../models/habit.dart';
import '../services/storage_service.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  UserProfile _userProfile = UserProfile.defaultProfile();
  List<Task> _tasks = [];
  List<Habit> _habits = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final List<Task> tasks = await StorageService.getTasks();
    final List<Habit> habits = await StorageService.getHabits();
    // TODO: Load user profile from storage service

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
          'Profile',
          style: GoogleFonts.preahvihear(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _showEditProfileDialog,
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildProfileHeader(),
                  const SizedBox(height: 24),
                  _buildStatsSection(),
                  const SizedBox(height: 24),
                  _buildPreferencesSection(),
                  const SizedBox(height: 24),
                  _buildActivitySection(),
                ],
              ),
            ),
    );
  }

  Widget _buildProfileHeader() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFEBBCFC).withValues(alpha: 0.8),
              const Color(0xFFCADBFC).withValues(alpha: 0.8),
            ],
          ),
        ),
        child: Column(
          children: [
            // Profile picture and name row
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: _userProfile.profileImagePath != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: Image.asset(
                            _userProfile.profileImagePath!,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        )
                      : const Icon(
                          Icons.person,
                          size: 40,
                          color: Color(0xFFFF0061),
                        ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _userProfile.name,
                        style: GoogleFonts.preahvihear(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _userProfile.email,
                        style: GoogleFonts.preahvihear(
                          fontSize: 14,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Member since ${_formatDate(_userProfile.createdAt)}',
                        style: GoogleFonts.preahvihear(
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // User details in column
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildDetailRow('Total Tasks', '${_tasks.length}'),
                  const SizedBox(height: 8),
                  _buildDetailRow('Total Habits', '${_habits.length}'),
                  const SizedBox(height: 8),
                  _buildDetailRow(
                      'Completed Tasks', '${_getCompletedTasksCount()}'),
                  const SizedBox(height: 8),
                  _buildDetailRow(
                      'Active Streaks', '${_getActiveStreaksCount()}'),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2, end: 0);
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.preahvihear(
            fontSize: 14,
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.preahvihear(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Statistics',
              style: GoogleFonts.preahvihear(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFFF0061),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Completion Rate',
                    '${_getCompletionRate()}%',
                    Icons.check_circle,
                    const Color(0xFFCADBFC),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Best Streak',
                    '${_getBestStreak()} days',
                    Icons.local_fire_department,
                    const Color(0xFFEBBCFC),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 600.ms);
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, size: 24, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.preahvihear(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
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

  Widget _buildPreferencesSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Preferences',
              style: GoogleFonts.preahvihear(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFFF0061),
              ),
            ),
            const SizedBox(height: 16),
            _buildPreferenceItem('Notifications',
                (_userProfile.preferences['notifications'] as bool?) ?? true),
            _buildPreferenceItem('Daily Reminder',
                (_userProfile.preferences['dailyReminder'] as bool?) ?? true),
            _buildPreferenceItem(
                'Dark Theme', _userProfile.preferences['theme'] == 'dark'),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 400.ms, duration: 600.ms);
  }

  Widget _buildPreferenceItem(String title, bool value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.preahvihear(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          Switch(
            value: value,
            onChanged: (newValue) {
              // TODO: Update preferences
            },
            activeColor: const Color(0xFFFF0061),
          ),
        ],
      ),
    );
  }

  Widget _buildActivitySection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Activity',
              style: GoogleFonts.preahvihear(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFFF0061),
              ),
            ),
            const SizedBox(height: 16),
            _buildActivityItem('Completed "Morning Exercise"', '2 hours ago'),
            _buildActivityItem('Added new task "Buy groceries"', '5 hours ago'),
            _buildActivityItem('Completed habit streak: 7 days', '1 day ago'),
            _buildActivityItem('Updated profile information', '3 days ago'),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 600.ms, duration: 600.ms);
  }

  Widget _buildActivityItem(String activity, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Color(0xFFCADBFC),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity,
                  style: GoogleFonts.preahvihear(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  time,
                  style: GoogleFonts.preahvihear(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showEditProfileDialog() {
    final nameController = TextEditingController(text: _userProfile.name);
    final emailController = TextEditingController(text: _userProfile.email);

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _userProfile = _userProfile.copyWith(
                  name: nameController.text,
                  email: emailController.text,
                );
              });
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  int _getCompletedTasksCount() {
    return _tasks.where((task) => task.isCompleted).length;
  }

  int _getActiveStreaksCount() {
    return _habits.where((habit) => habit.currentStreak > 0).length;
  }

  int _getCompletionRate() {
    if (_tasks.isEmpty) {
      return 0;
    }
    final completed = _getCompletedTasksCount();
    return ((completed / _tasks.length) * 100).round();
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
