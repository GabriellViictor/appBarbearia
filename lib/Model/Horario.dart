class Horario {
  String id;
  String horarioId;
  String horarioTexto;
  bool disponivel;
  String? data;
  String? servico;
  double? valor;
  int? minuto;

  Horario({
    required this.id,
    required this.horarioId,
    required this.horarioTexto,
    required this.disponivel,
    this.data,
    this.servico,
    this.valor,
    this.minuto,
  });

  factory Horario.fromJson(Map<String, dynamic> json) {
    return Horario(
      id: json['_id'] ?? '',
      horarioId: json['horario']['_id'] ?? '',
      horarioTexto: json['horario']['horario'] ?? '',
      disponivel: json['horario']['disponivel'] ?? false,
      data: json['data'],
      servico: json['servico'],
      valor: json['valor']?.toDouble(),
      minuto: json['minuto'],
    );
  }

  factory Horario.fromJsonDisponivel(Map<String, dynamic> json) {
    return Horario(
      id: '',
      horarioId: '',
      horarioTexto: json['horario'] ?? '',
      disponivel: json['disponivel'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'horario': {
        '_id': horarioId,
        'horario': horarioTexto,
        'disponivel': disponivel,
      },
      'horarioTexto': horarioTexto,
      'data': data,
      'servico': servico,
      'valor': valor,
      'minuto': minuto,
    };
  }
}
