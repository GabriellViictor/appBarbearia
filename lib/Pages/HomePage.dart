import 'package:app_barbearia/Pages/Agendamento.dart';
import 'package:app_barbearia/Pages/AgendamentoBarbeiro.dart';
import 'package:app_barbearia/Pages/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_barbearia/widgets/CustomBottomNavigationBar.dart';
import 'package:app_barbearia/api/ApointmentApi.dart';
import 'package:app_barbearia/Model/Horario.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _username;
  String? _userType;
  late Future<List<Horario>> _agendamentos;

  @override
  void initState() {
    super.initState();
    _loadUser();
    _refreshHorarios();
  }

  Future<void> _loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('loggedInUser');
      _userType = prefs.getString('userType');
    });
  }

  Future<void> _refreshHorarios() async {
    setState(() {
      _agendamentos = AppointmentApi().getAgendamentos();
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
        userType: _userType ?? '',
      ),
    );
  }

  Widget _body() {
    return FutureBuilder<List<Horario>>(
      future: _agendamentos,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erro: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Nenhum horário agendado'));
        }

        List<Horario> agendamentos = snapshot.data!;
        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: agendamentos.length,
          itemBuilder: (context, index) {
            Horario agendamento = agendamentos[index];
            return _buildAppointmentCard(agendamento);
          },
        );
      },
    );
  }

  Widget _buildAppointmentCard(Horario agendamento) {
    String time = agendamento.horarioTexto ?? 'Hora inválida';
    String service = agendamento.servico ?? 'Serviço';
    String date = agendamento.data ?? 'Data';
    double? valor = agendamento.valor;
    int? minuto = agendamento.minuto;

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
                    Text('R\$ $valor', style: TextStyle(fontSize: 16.0, color: Colors.green)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.access_time, color: Colors.grey),
                SizedBox(width: 4.0),
                Text('$minuto min', style: TextStyle(fontSize: 16.0, color: Colors.grey)),
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
                    Text('Hora: $time', style: TextStyle(fontSize: 16.0)),
                    Text('Serviço: $service', style: TextStyle(fontSize: 16.0)),
                    Text('Data: $date', style: TextStyle(fontSize: 16.0)),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    _handleCancelAppointment(agendamento);
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
      _handleLogout();
    } else if (index == 1) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
    } else if (_userType == 'usuario1' && index == 2) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ScheduleServicePage()));
    } else if (_userType == 'usuario2' && index == 2) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BarberSchedulePage()));
    }
  }

  void _handleLogout() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.clear();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
    });
  }

  void _handleCancelAppointment(Horario agendamento) {
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
                AppointmentApi().desmarcarHorario(agendamento.horarioTexto).then((message) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
                  _refreshHorarios(); 
                  Navigator.of(context).pop(); 
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao cancelar: $error')));
                });
              },
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }
}
