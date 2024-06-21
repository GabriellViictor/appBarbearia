import 'package:app_barbearia/Pages/Agendamento.dart';
import 'package:app_barbearia/Pages/AgendamentoBarbeiro.dart';
import 'package:app_barbearia/Pages/ProgilePage.dart';
import 'package:app_barbearia/api/ApointmentApi.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_barbearia/widgets/CustomBottomNavigationBar.dart';
import 'package:app_barbearia/Model/Horario.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _username;
  String? _userType;
  late Future<List<Horario>> _horariosIndisponiveis;

  @override
  void initState() {
    super.initState();
    _loadUser();
    _horariosIndisponiveis = AppointmentApi().getHorariosIndisponiveis();
  }

  Future<void> _loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('loggedInUser');
      _userType = prefs.getString('userType');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agendamentos'),
      ),
      body: _body(),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 1,
        onTap: _handleNavigationTap,
      ),
    );
  }

  Widget _body() {
    return FutureBuilder<List<Horario>>(
      future: _horariosIndisponiveis,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erro: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Nenhum horário agendado'));
        }

        List<Horario> horarios = snapshot.data!;
        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: horarios.length,
          itemBuilder: (context, index) {
            Horario horario = horarios[index];
            return _buildAppointmentCard(horario);
          },
        );
      },
    );
  }

  Widget _buildAppointmentCard(Horario horario) {
    String? date, time;

    try {
      date = horario.horario.substring(0, 10);
      time = horario.horario.substring(11);
    } catch (e) {
      date = 'Data inválida';
      time = 'Hora inválida';
    }

    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.person, color: Colors.blue),
                    SizedBox(width: 8.0),
                    Text('Nome do Cliente', style: TextStyle(fontSize: 18.0)),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.attach_money, color: Colors.green),
                    SizedBox(width: 4.0),
                    Text('R\$ 30,00', style: TextStyle(fontSize: 16.0, color: Colors.green)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.access_time, color: Colors.grey),
                SizedBox(width: 4.0),
                Text('30 min', style: TextStyle(fontSize: 16.0, color: Colors.grey)),
              ],
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 4.0),
                    Text('Data: $date', style: TextStyle(fontSize: 16.0)),
                    SizedBox(height: 4.0),
                    Text('Hora: $time', style: TextStyle(fontSize: 16.0)),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    _handleCancelAppointment(horario);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                  ),
                  child: const Text('Cancelar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _handleNavigationTap(int index) {
    if (index == 0) {
      _handleProfileButton();
    } else if (index == 1) {
      _handleScheduleButton();
    }else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ScheduleServicePage()));
    }
  }

  void _handleScheduleButton() {
    if (_username == 'usuario1') {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ScheduleServicePage()));
    } else if (_username == 'usuario2') {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const BarberSchedulePage()));
    }
  }

  void _handleCancelAppointment(Horario horario) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cancelar Agendamento'),
          content: Text('Deseja realmente cancelar este agendamento?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                // Implementar lógica para cancelamento usando a API
                AppointmentApi().desmarcarHorario(horario.horario).then((message) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
                  setState(() {
                    _horariosIndisponiveis = AppointmentApi().getHorariosIndisponiveis();
                  });
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao cancelar: $error')));
                });
                Navigator.of(context).pop();
              },
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }

  void _handleProfileButton() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProfilePage()));
  }
}
