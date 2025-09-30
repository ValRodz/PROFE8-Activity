import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
// TODO: Add 'hive' or 'sqflite' package for better local database storage
import '../models/task.dart';
import '../models/habit.dart';
import '../models/user_profile.dart'; // added import for UserProfile

class StorageService {
  static const String _tasksKey = 'tasks';
  static const String _habitsKey = 'habits';
  static const String _userProfileKey =
      'user_profile'; // added user profile key

  // Task operations
  static Future<List<Task>> getTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = prefs.getString(_tasksKey);
    if (tasksJson == null) {
      return <Task>[];
    }

    final dynamic decodedData = json.decode(tasksJson);
    if (decodedData is! List) {
      return <Task>[];
    }

    final List<dynamic> tasksList = decodedData;
    return tasksList
        .map((taskJson) => Task.fromJson(taskJson as Map<String, dynamic>))
        .toList();
  }

  static Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = json.encode(tasks.map((task) => task.toJson()).toList());
    await prefs.setString(_tasksKey, tasksJson);
  }

  static Future<void> addTask(Task task) async {
    final tasks = await getTasks();
    tasks.add(task);
    await saveTasks(tasks);
  }

  static Future<void> updateTask(Task updatedTask) async {
    final tasks = await getTasks();
    final index = tasks.indexWhere((task) => task.id == updatedTask.id);
    if (index != -1) {
      tasks[index] = updatedTask;
      await saveTasks(tasks);
    }
  }

  static Future<void> deleteTask(String taskId) async {
    final tasks = await getTasks();
    tasks.removeWhere((task) => task.id == taskId);
    await saveTasks(tasks);
  }

  static Future<void> clearAllTasks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tasksKey);
  }

  // Habit operations
  static Future<List<Habit>> getHabits() async {
    final prefs = await SharedPreferences.getInstance();
    final habitsJson = prefs.getString(_habitsKey);
    if (habitsJson == null) {
      return <Habit>[];
    }

    final dynamic decodedData = json.decode(habitsJson);
    if (decodedData is! List) {
      return <Habit>[];
    }

    final List<dynamic> habitsList = decodedData;
    return habitsList
        .map((habitJson) => Habit.fromJson(habitJson as Map<String, dynamic>))
        .toList();
  }

  static Future<void> saveHabits(List<Habit> habits) async {
    final prefs = await SharedPreferences.getInstance();
    final habitsJson =
        json.encode(habits.map((habit) => habit.toJson()).toList());
    await prefs.setString(_habitsKey, habitsJson);
  }

  static Future<void> addHabit(Habit habit) async {
    final habits = await getHabits();
    habits.add(habit);
    await saveHabits(habits);
  }

  static Future<void> updateHabit(Habit updatedHabit) async {
    final habits = await getHabits();
    final index = habits.indexWhere((habit) => habit.id == updatedHabit.id);
    if (index != -1) {
      habits[index] = updatedHabit;
      await saveHabits(habits);
    }
  }

  static Future<void> deleteHabit(String habitId) async {
    final habits = await getHabits();
    habits.removeWhere((habit) => habit.id == habitId);
    await saveHabits(habits);
  }

  static Future<void> clearAllHabits() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_habitsKey);
  }

  static Future<UserProfile> getUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final userProfileJson = prefs.getString(_userProfileKey);
    if (userProfileJson == null) {
      return UserProfile.defaultProfile();
    }

    final dynamic decodedData = json.decode(userProfileJson);
    if (decodedData is! Map<String, dynamic>) {
      return UserProfile.defaultProfile();
    }

    return UserProfile.fromJson(decodedData);
  }

  static Future<void> saveUserProfile(UserProfile userProfile) async {
    final prefs = await SharedPreferences.getInstance();
    final userProfileJson = json.encode(userProfile.toJson());
    await prefs.setString(_userProfileKey, userProfileJson);
  }

  static Future<Map<String, dynamic>> getStats() async {
    final tasks = await getTasks();
    final habits = await getHabits();

    final completedTasks = tasks.where((task) => task.isCompleted).length;
    final totalTasks = tasks.length;
    final completedHabits =
        habits.where((habit) => habit.isCompletedToday()).length;
    final totalHabits = habits.length;

    return {
      'tasks': tasks,
      'habits': habits,
      'completedTasks': completedTasks,
      'totalTasks': totalTasks,
      'completedHabits': completedHabits,
      'totalHabits': totalHabits,
    };
  }

  static Future<void> clearAll() async {
    await clearAllTasks();
    await clearAllHabits();
  }

  static bool validateTaskData(dynamic data) {
    return data != null && data is List;
  }

  static bool validateHabitData(dynamic data) {
    return data != null && data is List;
  }
}
