import 'package:flutter/material.dart';
import 'package:my_tasks_app/main.dart';
import 'package:my_tasks_app/services/tasks_service.dart';
import 'package:my_tasks_app/widgets/task_item.dart';
import 'package:my_tasks_app/widgets/filter_buttons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String filtro = "todas";
  List<Map<String, Object>> tasks = [];
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    TasksService.load().then((t) => setState(() => tasks = t));
  }

  void save() => TasksService.save(tasks);

  void deleteTask(Map<String, Object> task) {
    setState(() => tasks.remove(task));
    save();
  }

  void showDialogTask({int? i}) {
    if (i != null) controller.text = tasks[i]["titulo"].toString();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(i == null ? "Nueva Tarea" : "Editar"),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () {
              controller.clear();
              Navigator.pop(context);
            },
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () {
              final text = controller.text.trim();
              if (text.isEmpty) return;

              setState(() {
                i == null
                    ? tasks.add({"titulo": text, "completada": false})
                    : tasks[i]["titulo"] = text;
              });

              save();
              controller.clear();
              Navigator.pop(context);
            },
            child: const Text("Guardar"),
          ),
        ],
      ),
    );
  }

  List<Map<String, Object>> get lista {
    if (filtro == "pendientes") {
      return tasks.where((t) => !(t["completada"] as bool)).toList();
    }
    if (filtro == "completadas") {
      return tasks.where((t) => (t["completada"] as bool)).toList();
    }
    return tasks;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mis Tareas (${tasks.length})"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () => MyApp.of(context)?.toggleTheme(),
          ),
        ],
      ),
      body: Column(
        children: [
          FilterButtons(
            filtro: filtro,
            onChange: (v) => setState(() => filtro = v),
          ),
          Expanded(
            child: lista.isEmpty
                ? const Center(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.task_alt, size: 60, color: Colors.grey),
                          SizedBox(height: 10),
                          Text(
                            "No hay tareas",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  )
                : AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: ListView.builder(
                      key: ValueKey(lista.length),
                      itemCount: lista.length,
                      itemBuilder: (context, index) {
                        final task = lista[index];

                        return TaskItem(
                          task: task,
                          onDelete: () => deleteTask(task),
                          onEdit: () => showDialogTask(i: tasks.indexOf(task)),
                          onChanged: (value) {
                            setState(() {
                              task["completada"] = value!;
                            });
                            save();
                          },
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialogTask(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
