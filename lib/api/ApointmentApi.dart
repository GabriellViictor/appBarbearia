import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app_barbearia/Model/Horario.dart';

class AppointmentApi {
  static const String baseUrl = 'http://54.234.198.193:3333';
  final http.Client client;

  // Construtor padrão
  AppointmentApi({http.Client? client}) : client = client ?? http.Client();

  Future<List<Horario>> getHorariosDisponiveis() async {
    final response = await client.get(Uri.parse('$baseUrl/horarios-disponiveis'));

    if (response.statusCode == 200) {
      List<dynamic> responseData = jsonDecode(response.body);

      List<Horario> horarios = responseData.map((json) => Horario.fromJsonDisponivel({
        'horario': json['horario'],
        'disponivel': json['disponivel'],
      })).toList();

      return horarios;
    } else {
      throw Exception('Erro ao buscar horários disponíveis: ${response.statusCode}');
    }
  }

  Future<List<Horario>> getHorariosIndisponiveis() async {
    try {
      final response = await client.get(Uri.parse('$baseUrl/horarios-indisponiveis'));

      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body);
        List<Horario> horarios = body.map((dynamic item) => Horario.fromJsonDisponivel(item)).toList();
        return horarios;
      } else {
        throw Exception('Erro ao buscar horários indisponíveis: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro na requisição getHorariosIndisponiveis: $e');
      throw Exception('Erro ao buscar horários indisponíveis: $e');
    }
  }

  Future<List<Horario>> getAgendamentos() async {
    try {
      final response = await client.get(Uri.parse('$baseUrl/agendamentos'));

      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body);
        List<Horario> agendamentos = body.map((dynamic item) => Horario.fromJson(item)).toList();
        return agendamentos;
      } else {
        throw Exception('Erro ao buscar agendamentos: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro na requisição getAgendamentos: $e');
      throw Exception('Erro ao buscar agendamentos: $e');
    }
  }

  Future<void> marcarHorario({
    required String horarioId,
    required String data,
    required String servico,
    required double valor,
    required int minuto,
  }) async {
    String endpoint = '/marcar-horario';
    Uri uri = Uri.parse('$baseUrl$endpoint');
    Map<String, String> headers = {'Content-Type': 'application/json'};
    String body = jsonEncode({
      'horario': {
        '_id': horarioId,
        'horarioTexto': '',
        'disponivel': true,
      },
      'data': data,
      'servico': servico,
      'valor': valor,
      'minuto': minuto,
    });

    try {
      final response = await client.post(uri, headers: headers, body: body);
      if (response.statusCode == 200) {
        print('Horário marcado com sucesso');
      } else {
        throw Exception('Erro ao marcar horário: ${response.body}');
      }
    } catch (e) {
      throw Exception('Erro ao conectar ao servidor: $e');
    }
  }

  Future<String> desmarcarHorario(String horarioId) async {
    String endpoint = '/desmarcar-horario';
    Uri uri = Uri.parse('$baseUrl$endpoint');
    Map<String, String> headers = {'Content-Type': 'application/json'};
    String body = jsonEncode({'horario': {'_id': horarioId}});

    try {
      final response = await client.post(uri, headers: headers, body: body);
      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = json.decode(response.body);
        return responseBody['message'];
      } else {
        throw Exception('Erro ao desmarcar horário: ${response.body}');
      }
    } catch (e) {
      throw Exception('Erro ao conectar ao servidor: $e');
    }
  }
}
