import 'package:app_barbearia/Pages/Agendamento.dart';
import 'package:app_barbearia/Pages/ProgilePage.dart';
import 'package:app_barbearia/Utils/Validacoes.dart';
import 'package:app_barbearia/api/ApointmentApi.dart';
import 'package:flutter/material.dart';
import 'package:app_barbearia/widgets/CustomBottomNavigationBar.dart';
import 'package:app_barbearia/Model/Horario.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'HomePage.dart';

class BarberSchedulePage extends StatefulWidget {
  const BarberSchedulePage({Key? key}) : super(key: key);

  @override
  State<BarberSchedulePage> createState() => _BarberSchedulePageState();
}

class _BarberSchedulePageState extends State<BarberSchedulePage> {
  late Future<List<Horario>> _availableTimesFuture;
  late Future<List<Horario>> _unavailableTimesFuture;
  List<Horario> _selectedUnavailableTimes = [];
  String? _userType;


  Future<void> _loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userType = prefs.getString('userType');
    });
  }

  @override
  void initState() {
    super.initState();
    _availableTimesFuture = AppointmentApi().getHorariosDisponiveis();
    _unavailableTimesFuture = AppointmentApi().getHorariosIndisponiveis();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agendar Horários'),
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveSelectedTimes,
        child: Icon(Icons.save),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 1,
        onTap: _handleNavigationTap,
        userType: '',
      ),
    );
  }

  Widget _buildBody() {
    Validacoes validacoes = new Validacoes();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16.0),
        Text(
          'Horários Disponíveis',
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: FutureBuilder<List<Horario>>(
            future: _availableTimesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Erro: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('Nenhum horário disponível'));
              }

              List<Horario> availableTimes = snapshot.data!;
              return ListView.builder(
                itemCount: availableTimes.length,
                itemBuilder: (context, index) {
                  final horario = availableTimes[index];
                  final isUnavailable = _selectedUnavailableTimes.contains(horario);
                  return ListTile(
                    title: Text(horario.horarioTexto),
                    trailing: isUnavailable ? Icon(Icons.check, color: Colors.red) : null,
                    onTap: () {
                      setState(() {
                        if (isUnavailable) {
                          _selectedUnavailableTimes.remove(horario);
                        } else {
                          _selectedUnavailableTimes.add(horario);
                        }
                      });
                    },
                  );
                },
              );
            },
          ),
        ),
        const SizedBox(height: 16.0),
        Text(
          'Horários Indisponíveis',
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: FutureBuilder<List<Horario>>(
            future: _unavailableTimesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Erro: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('Nenhum horário indisponível'));
              }

              List<Horario> unavailableTimes = snapshot.data!;
              return ListView.builder(
                itemCount: unavailableTimes.length,
                itemBuilder: (context, index) {
                  final horario = unavailableTimes[index];
                  return ListTile(
                    title: Text(horario.horarioTexto),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () async {
                        try {
                          if(validacoes.verificarDesmarcarHorario(horario,_userType)){
                            await AppointmentApi().desmarcarHorario(horario.id);
                            setState(() {
                              _selectedUnavailableTimes.remove(horario); 
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Horário desmarcado com sucesso')),
                            );
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Erro ao desmarcar horário')),
                          );
                        }
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  void _saveSelectedTimes() async {
    try {
      for (Horario horario in _selectedUnavailableTimes) {
        await AppointmentApi().marcarHorario(
          horarioId: horario.horarioTexto,
          data: '',
          servico: 'Cancelado',
          valor: 0,
          minuto: 0,
        );
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Horários indisponíveis salvos')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar horários indisponíveis')),
      );
    }
  }

  void _handleNavigationTap(int index) {
    if (index == 0) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProfilePage()));
    } else if (index == 1) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ScheduleServicePage()));
    }
  }
}
