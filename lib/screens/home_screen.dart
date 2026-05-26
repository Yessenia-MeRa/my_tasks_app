import 'package:flutter/material.dart';
import 'package:my_tasks_app/main.dart';
import 'package:my_tasks_app/modesl/task_model.dart';
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
  List<Task> tasks = [];
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    TasksService.load().then((t) => setState(() => tasks = t));
  }

  void save() => TasksService.save(tasks);

  void deleteTask(Task task) {
    setState(() => tasks.remove(task));
    save();
  }

  void showDialogTask({Task? taskToEdit}) {
    if (taskToEdit != null) {
      controller.text = taskToEdit.titulo;
    } else {
      controller.clear();
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(taskToEdit == null ? "Nueva Tarea" : "Editar Tarea"),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: "Escribe tu tarea..."),
        ),
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
                if (taskToEdit == null) {
                  tasks.add(Task(titulo: text));
                } else {
                  taskToEdit.titulo = text;
                }
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

  List<Task> get lista {
    if (filtro == "pendientes") {
      return tasks.where((t) => !t.completada).toList();
    }
    if (filtro == "completadas") {
      return tasks.where((t) => t.completada).toList();
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
          const SizedBox(height: 8),
          Expanded(
            child: lista.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.task_alt, size: 60, color: Colors.grey[400]),
                        const SizedBox(height: 10),
                        Text(
                          "No hay tareas en esta sección",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: lista.length,
                    itemBuilder: (context, index) {
                      final task = lista[index];

                      return TaskItem(
                        key: ObjectKey(task),
                        task: task,
                        onDelete: () => deleteTask(task),
                        onEdit: () => showDialogTask(taskToEdit: task),
                        onChanged: (value) {
                          setState(() {
                            task.completada = value!;
                          });
                          save();
                        },
                      );
                    },
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
