import 'package:app_barbearia/Pages/AgendamentoBarbeiro.dart';
import 'package:app_barbearia/Pages/ProgilePage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_barbearia/widgets/CustomBottomNavigationBar.dart';
import 'package:app_barbearia/Pages/Agendamento.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _username;
  String? _userType;

  @override
  void initState() {
    super.initState();
    _loadUser();
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
        title: const Text('Agendamentos'), // Adicionando o título "Agendamentos" na barra de navegação
      ),
      body: Stack(
        children: [
          _body(),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 1,
        onTap: (index) {
          if (index == 2) {
            // Verifica o tipo de usuário e redireciona para a página apropriada
            if (_username == 'user1') {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ScheduleServicePage()));
            } else if (_username == 'user2') {
              Navigator.push(context, MaterialPageRoute(builder: (context) => BarberSchedulePage()));
            }
          } else {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
          }
        },
      ),
    );
  }

  Widget _body() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildAppointmentCard(),
        _buildAppointmentCard(),
      ],
    );
  }

  Widget _buildAppointmentCard() {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Primeira linha com ícone, nome do cliente e valor
            const Row(
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
            // Segunda linha com duração, alinhada à direita
            const Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.access_time, color: Colors.grey),
                SizedBox(width: 4.0),
                Text('30 min', style: TextStyle(fontSize: 16.0, color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 8.0),
            // Terceira linha com data e hora à esquerda e botão de cancelamento à direita
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Data: 13/05/2024', style: TextStyle(fontSize: 16.0)),
                    SizedBox(height: 4.0),
                    Text('Hora: 10:00', style: TextStyle(fontSize: 16.0)),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    // Adicione a lógica para cancelar o agendamento aqui
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
}
