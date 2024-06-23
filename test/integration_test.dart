import 'package:app_barbearia/Utils/Validacoes.dart';
import 'package:app_barbearia/api/ApointmentApi.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_barbearia/Model/Horario.dart';

void main() {
  test('Teste de integração', () async {
    Validacoes validacoes = new Validacoes();
    int quantHorarios = 0;
    int auxQuantHorarios = 0;

    AppointmentApi api = new AppointmentApi();
  
    Future<void> carregarHorariosDisponiveis() async {
      try {
        if(quantHorarios > 0){
          auxQuantHorarios = quantHorarios;
        }  
        List<Horario> availableTimes = await api.getHorariosDisponiveis();
        quantHorarios = availableTimes.length;
      } catch (e) {
        fail('Erro ao carregar horários disponíveis: $e');
      }
    }

    Future<void> insereHorario() async {
      try {
        await api.marcarHorario(horarioId: "12:00", data: "2024-07-01", servico: "Corte de cabelo", valor: 50.0, minuto: 30);
      } catch (e) {
        fail('Erro ao carregar horários disponíveis: $e');
      }
    }


    
    Future<void> desmarcarHorario() async {
      try {
        await api.desmarcarHorario("12:00");
      } catch (e) {
        fail('Erro ao carregar horários disponíveis: $e');
      }
    }

  
    //Teste1 : TC_INTEGRACAO_01
    await carregarHorariosDisponiveis(); 
    expect(quantHorarios > 0 , true);

    //Teste2 : TC_INTEGRACAO_02
    await insereHorario();
    await carregarHorariosDisponiveis(); 
    expect(quantHorarios, auxQuantHorarios - 1 ); 

    //Teste3 : TC_INTEGRACAO_03
    await desmarcarHorario();
    await carregarHorariosDisponiveis();
    expect(quantHorarios, auxQuantHorarios + 1); 


  });
}
