class Horario {
  String id;
  String horario;
  bool disponivel;

  Horario({
    required this.id,
    required this.horario,
    required this.disponivel,
  });

  factory Horario.fromJson(Map<String, dynamic> json) {
    return Horario(
      id: json['_id'],
      horario: json['horario'],
      disponivel: json['disponivel'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'horario': horario,
      'disponivel': disponivel,
    };
  }
}
