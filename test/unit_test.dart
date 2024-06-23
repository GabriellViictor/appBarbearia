import 'dart:convert';
import 'package:app_barbearia/api/ApointmentApi.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:app_barbearia/Model/Horario.dart';

// Classe mock para http.Client
class MockClient extends Mock implements http.Client {}

void main() {
  group('AppointmentApi', () {
    MockClient? client;
    AppointmentApi? api;

    setUp(() {
      client = MockClient();
      api = AppointmentApi();
    });

    test('getHorariosDisponiveis retorna uma lista de horários disponíveis se a resposta for 200', () async {
      final responseJson = jsonEncode([
        {'horario': '08:00', 'disponivel': true},
        {'horario': '09:00', 'disponivel': true}
      ]);

      // Simula a resposta HTTP
      when(client!.get(Uri.parse('http://54.234.198.193:3333/horarios-disponiveis')))
        .thenAnswer((_) async => http.Response(responseJson, 200));

      List<Horario> horarios = await api!.getHorariosDisponiveis();

      expect(horarios.length, 2);
      expect(horarios[0].horarioTexto, '08:00');
      expect(horarios[0].disponivel, true);
      expect(horarios[1].horarioTexto, '09:00');
      expect(horarios[1].disponivel, true);
    });

    test('getHorariosDisponiveis lança uma exceção se a resposta não for 200', () {
      // Simula a resposta HTTP
      when(client!.get(Uri.parse('http://54.234.198.193:3333/horarios-disponiveis')))
        .thenAnswer((_) async => http.Response('Erro', 404));

      expect(api!.getHorariosDisponiveis(), throwsException);
    });
  });
}
