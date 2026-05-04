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

      background: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      secondaryBackground: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),

      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Eliminar Tarea"),
            content: const Text("¿Estás seguro?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Cancelar"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text("Borrar"),
              ),
            ],
          ),
        );
      },

      onDismissed: (_) => onDelete(),

      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),

        child: Padding(
          padding: EdgeInsets.all(screenWidth < 350 ? 8 : 12),

          child: CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            activeColor: const Color(0xFF8490D5),

            title: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text("Tarea"),
                    content: Text(task["titulo"].toString()),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cerrar"),
                      ),
                    ],
                  ),
                );
              },

              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                style: TextStyle(
                  fontSize: screenWidth < 350 ? 14 : 16,
                  fontWeight: FontWeight.w500,
                  color: (task["completada"] as bool? ?? false)
                      ? Colors.grey
                      : Theme.of(context).textTheme.bodyMedium?.color,
                  decoration: (task["completada"] as bool? ?? false)
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
                child: Text(
                  task["titulo"].toString(),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),

            value: task["completada"] as bool? ?? false,
            onChanged: onChanged,

            secondary: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: onEdit,
            ),
          ),
        ),
      ),
    );
  }
}