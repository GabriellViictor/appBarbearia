import 'package:app_barbearia/Pages/ProgilePage.dart';
import 'package:app_barbearia/Utils/DataBaseHelper.dart';
import 'package:flutter/material.dart';
import 'package:app_barbearia/widgets/CustomBottomNavigationBar.dart';
import 'package:app_barbearia/Pages/HomePage.dart';

class ScheduleServicePage extends StatefulWidget {
  const ScheduleServicePage({Key? key}) : super(key: key);

  @override
  State<ScheduleServicePage> createState() => _ScheduleServicePageState();
}

class _ScheduleServicePageState extends State<ScheduleServicePage> {
  DateTime _selectedDay = DateTime.now();
  Set<String> _selectedServices = {};
  String? _selectedTime;

  final List<Map<String, dynamic>> services = [
    {'name': 'Corte de Cabelo', 'price': 30.0, 'duration': '30 min'},
    {'name': 'Barba', 'price': 20.0, 'duration': '20 min'}
  ];

  final List<String> times = [
    '09:00', '10:00', '11:00', '12:00',
    '13:00', '14:00', '15:00', '16:00',
    '17:00', '18:00', '19:00', '20:00'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agendar Serviços'),
      ),
      body: _buildBody(),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 2,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomePage()));
          } else if (index == 0) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => ProfilePage()));
          }
        },
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Selecione o serviço desejado', style: TextStyle(fontSize: 18.0)),
          const SizedBox(height: 8.0),
          _buildServiceSelection(),
          const SizedBox(height: 16.0),
          _buildDateSelection(),
          const SizedBox(height: 16.0),
          const Text('Horários de trabalho disponíveis', style: TextStyle(fontSize: 18.0)),
          const SizedBox(height: 8.0),
          _buildTimeSelection(),
          const SizedBox(height: 16.0),
          _buildTotalAndSaveButton(),
        ],
      ),
    );
  }

  Widget _buildServiceSelection() {
    return Column(
      children: services.map((service) {
        final isSelected = _selectedServices.contains(service['name']);
        return Card(
          elevation: 4.0,
          margin: const EdgeInsets.symmetric(vertical: 6.0),
          color: isSelected ? Colors.blue.withOpacity(0.2) : null,
          child: ListTile(
            onTap: () {
              setState(() {
                if (isSelected) {
                  _selectedServices.remove(service['name']);
                } else {
                  _selectedServices.add(service['name']);
                }
              });
            },
            title: Text(service['name']),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.attach_money, color: Colors.green),
                    SizedBox(width: 4.0),
                    Text('R\$ ${service['price']}', style: TextStyle(fontSize: 16.0, color: Colors.green)),
                  ],
                ),
                const SizedBox(height: 4.0),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.access_time, color: Colors.grey),
                    SizedBox(width: 4.0),
                    Text(service['duration'], style: TextStyle(fontSize: 16.0, color: Colors.grey)),
                  ],
                ),
              ],
            ),
            selected: isSelected,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDateSelection() {
    return TextField(
      readOnly: true,
      decoration: InputDecoration(
        labelText: 'Selecione a data',
        suffixIcon: Icon(Icons.calendar_today),
        border: OutlineInputBorder(),
      ),
      controller: TextEditingController(
        text: '${_selectedDay.toLocal()}'.split(' ')[0],
      ),
      onTap: _selectDate,
    );
  }
Widget _buildTimeSelection() {
  return FutureBuilder<List<String>>(
    future: DatabaseHelper.instance.getAvailableTimes(_selectedDay),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return CircularProgressIndicator();
      } else if (snapshot.hasError) {
        return Text('Erro ao carregar horários disponíveis');
      } else {
        List<String> availableTimes = snapshot.data ?? [];
        if (availableTimes.isNotEmpty) {
          return Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 2.5,
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
              ),
              itemCount: availableTimes.length,
              itemBuilder: (context, index) {
                final time = availableTimes[index];
                return ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedTime = time;
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      _selectedTime == time ? Colors.blue : Colors.grey[300],
                    ),
                    foregroundColor: MaterialStateProperty.all(
                      _selectedTime == time ? Colors.white : Colors.black,
                    ),
                  ),
                  child: Text(time),
                );
              },
            ),
          );
        } else {
          return Text('Não há horários disponíveis para esta data');
        }
      }
    },
  );
}

  Widget _buildTotalAndSaveButton() {
    double totalPrice = _selectedServices.fold(
        0.0, (sum, service) => sum + services.firstWhere((item) => item['name'] == service)['price']);

    return Center(
      child: Column(
        children: [
          Text('Total: R\$ $totalPrice', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
          ElevatedButton(
            onPressed: () {
              if (_selectedServices.isNotEmpty && _selectedTime != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Serviço agendado para ${_selectedDay.toLocal().toString().split(' ')[0]} às $_selectedTime')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Por favor, selecione um serviço e um horário')),
                );
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDay,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (picked != null && picked != _selectedDay) {
      setState(() {
        _selectedDay = picked;
      });
    }
  }
}
