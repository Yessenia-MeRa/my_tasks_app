import 'package:flutter/material.dart';

class FilterButtons extends StatelessWidget {
  final String filtro;
  final Function(String) onChange;

  const FilterButtons({
    super.key,
    required this.filtro,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildButton(context, "todas", "Todas"),
        _buildButton(context, "pendientes", "Pendientes"),
        _buildButton(context, "completadas", "Completadas"),
      ],
    );
  }

  Widget _buildButton(BuildContext context, String value, String text) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: filtro == value
            ? const Color(0xFF8490D5)
            : Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[850]
                : Colors.grey[200],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      onPressed: () => onChange(value),
      child: Text(
        text,
        style: TextStyle(
          color: filtro == value
              ? Colors.white
              : Theme.of(context).brightness == Brightness.dark
                  ? Colors.white70
                  : Colors.black87,
        ),
      ),
    );
  }
}