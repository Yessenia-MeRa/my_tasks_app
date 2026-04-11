import 'package:shared_preferences/shared_preferences.dart';

class TasksService {

  static Future<void> save(List<Map<String, Object>> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final tasksString = tasks.map(_encodeTask).toList();

    await prefs.setStringList("tasks", tasksString);
  }

  static Future<List<Map<String, Object>>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTasks = prefs.getStringList("tasks");

    if (savedTasks == null) return [];

    return savedTasks.map(_decodeTask).toList();
  }

  static String _encodeTask(Map<String, Object> task) {
    return "${task["titulo"]}|${task["completada"]}";
  }

  static Map<String, Object> _decodeTask(String taskString) {
    final parts = taskString.split("|");

    return {"titulo": parts[0], "completada": parts[1] == "true"};
  }
}
