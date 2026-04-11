import 'package:flutter/material.dart';

class TaskItem extends StatelessWidget {
  final Map<String, Object> task;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final Function(bool?) onChanged;

  const TaskItem({
    super.key,
    required this.task,
    required this.onDelete,
    required this.onEdit,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Dismissible(
      key: ValueKey(task["titulo"].toString()),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Elimiar Tarea"),
              content: Text("Estas segura"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text("Cacelar"),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text("Borrar"),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (direction) {
        onDelete();
      },
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),

        child: Padding(
          padding: EdgeInsets.all(screenWidth < 350 ? 6 : 10),
          child: CheckboxListTile(
            title: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("Tarea"),
                      content: Text(task["titulo"].toString()),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text("Cerrar"),
                        ),
                      ],
                    );
                  },
                );
              },

              child: Text(
                task["titulo"].toString(),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: screenWidth < 350 ? 14 : 16,
                  decoration: (task["completada"] as bool? ?? false)
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
            ),
            value: task["completada"] as bool? ?? false,
            onChanged: onChanged,
            secondary: IconButton(icon: Icon(Icons.edit), onPressed: onEdit),
          ),
        ),
      ),
    );
  }
}
