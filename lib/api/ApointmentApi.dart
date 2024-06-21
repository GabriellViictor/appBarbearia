import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app_barbearia/Model/Horario.dart';

class AppointmentApi {
  static const String baseUrl = 'http://54.234.198.193:3333';

  Future<List<Horario>> getHorariosDisponiveis() async {
    final response = await http.get(Uri.parse('$baseUrl/horarios-disponiveis'));

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      List<Horario> horarios = body.map((dynamic item) => Horario.fromJson(item)).toList();
      return horarios;
    } else {
      throw Exception('Erro ao buscar horários disponíveis');
    }
  }

Future<List<Horario>> getHorariosIndisponiveis() async {
  final response = await http.get(Uri.parse('$baseUrl/horarios-indisponiveis'));

  if (response.statusCode == 200) {
    List<dynamic> body = json.decode(response.body);
    List<Horario> horarios = body.map((dynamic item) => Horario.fromJson(item)).toList();
    print("HORARIOS ${horarios}");
    return horarios;
  } else {
    throw Exception('Erro ao buscar horários indisponíveis');
  }
}



  Future<void> marcarHorario(String horario) async {
    String endpoint = '/marcar-horario';
    Uri uri = Uri.parse('$baseUrl$endpoint');
    Map<String, String> headers = {'Content-Type': 'application/json'};
    String body = jsonEncode({'horario': horario});

    try {
      final response = await http.post(uri, headers: headers, body: body);
      if (response.statusCode == 200) {
        // Horário marcado com sucesso
      } else {
        throw Exception('Erro ao marcar horário: ${response.body}');
      }
    } catch (e) {
      throw Exception('Erro ao conectar ao servidor: $e');
    }
  }

  Future<String> desmarcarHorario(String horario) async {
    String endpoint = '/desmarcar-horario';
    Uri uri = Uri.parse('$baseUrl$endpoint');
    Map<String, String> headers = {'Content-Type': 'application/json'};
    String body = jsonEncode({'horario': horario});

    try {
      final response = await http.post(uri, headers: headers, body: body);
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
