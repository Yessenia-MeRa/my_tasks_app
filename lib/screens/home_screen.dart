import 'package:flutter/material.dart';
import 'package:my_tasks_app/main.dart';
import 'package:my_tasks_app/services/tasks_service.dart';
import 'package:my_tasks_app/widgets/task_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, Object>> tasks = [];
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  void loadTasks() async {
    tasks = await TasksService.load();
    setState(() {});
  }

  void _showTaskDialog({int? index}) {
    if (index != null) {
      controller.text = tasks[index]["titulo"].toString();
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(index == null ? "Nueva Tarea" : "Editar tarea"),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: "Escribir tarea",
              border: OutlineInputBorder(),
            ),
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
                if (controller.text.trim().isEmpty) {
                  Navigator.pop(context);
                  return;
                }

                setState(() {
                  if (index == null) {
                    tasks.add({
                      "titulo": controller.text.trim(),
                      "completada": false,
                    });
                  } else {
                    tasks[index]["titulo"] = controller.text.trim();
                  }
                });

                TasksService.save(tasks);
                controller.clear();
                Navigator.pop(context);
              },
              child: const Text("Guardar"),
            ),
          ],
        );
      },
    );
  }

  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
    TasksService.save(tasks);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mis Tareas"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () {
              MyApp.of(context)?.toggleTheme();
            },
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(10), // 🔥 espacio general
        child: tasks.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.task_alt, size: 60, color: Colors.grey),
                    SizedBox(height: 10),
                    Text(
                      "No hay tareas",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return TaskItem(
                    task: tasks[index],
                    onDelete: () => deleteTask(index),
                    onEdit: () => _showTaskDialog(index: index),
                    onChanged: (value) {
                      setState(() {
                        tasks[index]["completada"] = value!;
                      });
                      TasksService.save(tasks);
                    },
                  );
                },
              ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTaskDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
