import 'package:app_barbearia/Utils/Validacoes.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_barbearia/Model/Horario.dart';

void main() {
  test('Teste unitario', () {
    Validacoes validacoes = new Validacoes();
    const cliente = "usuario1";
    const barbeiro = "usuario2";

    //Teste 1 : TC_DISPONIBILIZAR_01
    Horario horarioTeste1 = Horario(
      id: "1",
      horarioId: "09:00",
      horarioTexto: "09:00",
      disponivel: false,
    );
    expect(validacoes.verificaInserirHorarioDisponivel(horarioTeste1, barbeiro), true);

    //Teste 2 : TC_DISPONIBILIZAR_02
    Horario horarioTeste2 = Horario(
      id: "2",
      horarioId: "09:00",
      horarioTexto: "09:00",
      disponivel: true,
    );
    expect(validacoes.verificaInserirHorarioDisponivel(horarioTeste2, barbeiro), false);

    // Teste 3: TC_DISPONIBILIZAR_03 
    Horario horarioTeste3 = Horario(
      id: "3",
      horarioId: "10:00",
      horarioTexto: "10:00",
      disponivel: false,
    );
    expect(validacoes.verificaInserirHorarioDisponivel(horarioTeste3, cliente), false);


    // Teste 4: TC_AGENDAR_01
    Horario horarioTeste4 = Horario(
      id: "4",
      horarioId: "10:00",
      horarioTexto: "10:00",
      disponivel: true,
    );
    expect(validacoes.verificaMarcarHorario(horarioTeste4, cliente), true);

    // Teste 5: TC_AGENDAR_02
    Horario horarioTeste5 = Horario(
      id: "5",
      horarioId: "10:00",
      horarioTexto: "10:00",
      disponivel: false,
    );
    expect(validacoes.verificaMarcarHorario(horarioTeste5, cliente), false);


    // Teste 6: TC_AGENDAR_03
    Horario horarioTeste6 = Horario(
      id: "6",
      horarioId: "10:00",
      horarioTexto: "10:00",
      disponivel: false,
    );
    expect(validacoes.verificaMarcarHorario(horarioTeste6, cliente), false);
    
    // Teste 7: TC_DESMARCAR_01
    Horario horarioTeste7 = Horario(
      id: "7",
      horarioId: "10:00",
      horarioTexto: "10:00",
      disponivel: false,
    );
    expect(validacoes.verificarDesmarcarHorario(horarioTeste7, cliente), true);

    // Teste 8: TC_DESMARCAR_02
    Horario horarioTeste8 = Horario(
      id: "8",
      horarioId: "10:00",
      horarioTexto: "10:00",
      disponivel: false,
    );
    expect(validacoes.verificarDesmarcarHorario(horarioTeste8, barbeiro), true);

    // Teste 9: TC_DESMARCAR_03
    Horario horarioTeste9 = Horario(
      id: "9",
      horarioId: "10:00",
      horarioTexto: "10:00",
      disponivel: true,
    );
    expect(validacoes.verificarDesmarcarHorario(horarioTeste9, cliente), false);
  
   
  });
}
