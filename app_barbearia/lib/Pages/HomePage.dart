import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
    );
  }

 _body() {
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
    margin: EdgeInsets.symmetric(vertical: 8.0),
    child: Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.person, color: Colors.blue),
              SizedBox(width: 8.0),
              Text('Nome do Cliente', style: TextStyle(fontSize: 18.0)),
            ],
          ),
          const SizedBox(height: 8.0),
          const Text('Data: 13/05/2024', style: TextStyle(fontSize: 16.0)),
          const SizedBox(height: 4.0),
          const Text('Hora: 10:00', style: TextStyle(fontSize: 16.0)),
          const SizedBox(height: 16.0),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.attach_money, color: Colors.green),
                  SizedBox(width: 4.0),
                  Text('R\$ 30,00', style: TextStyle(fontSize: 16.0, color: Colors.green)),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.access_time, color: Colors.grey),
                  SizedBox(width: 4.0),
                  Text('30 min', style: TextStyle(fontSize: 16.0, color: Colors.grey)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Adicione a lógica para cancelar o agendamento aqui
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                ),
                child: const Text('Cancelar Agendamento'),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}


}
