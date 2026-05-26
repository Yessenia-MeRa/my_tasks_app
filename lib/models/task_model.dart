class Task {
  String titulo;
  bool completada;

  Task({required this.titulo, this.completada = false});

  Map<String, dynamic> toJson() => {"titulo": titulo, "completada": completada};

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    titulo: json["titulo"] ?? "",
    completada: json["completada"] ?? false,
  );
}
