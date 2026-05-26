import 'dart:convert';
import 'package:my_tasks_app/modesl/task_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TasksService {
  static const String _storageKey = "tasks_json";

  static Future<void> save(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();

    final String encodedData = jsonEncode(
      tasks.map((t) => t.toJson()).toList(),
    );
    await prefs.setString(_storageKey, encodedData);
  }

  static Future<List<Task>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedTasks = prefs.getString(_storageKey);

    if (savedTasks == null) return [];

    try {
      final List<dynamic> decodedData = jsonDecode(savedTasks);
      return decodedData.map((item) => Task.fromJson(item)).toList();
    } catch (e) {
      return [];
    }
  }
}
