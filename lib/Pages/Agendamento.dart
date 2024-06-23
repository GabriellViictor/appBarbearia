import 'dart:convert';
import 'package:app_barbearia/Pages/ProgilePage.dart';
import 'package:app_barbearia/Utils/Validacoes.dart';
import 'package:app_barbearia/api/ApointmentApi.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:app_barbearia/Pages/HomePage.dart';
import 'package:app_barbearia/widgets/CustomBottomNavigationBar.dart';
import 'package:app_barbearia/Model/Horario.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScheduleServicePage extends StatefulWidget {
  const ScheduleServicePage({Key? key}) : super(key: key);

  @override
  State<ScheduleServicePage> createState() => _ScheduleServicePageState();
}

class _ScheduleServicePageState extends State<ScheduleServicePage> {
  DateTime _selectedDay = DateTime.now();
  Set<String> _selectedServices = {};
  String? _selectedTime;
    String? _userType;

  Future<void> _loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userType = prefs.getString('userType');
    });
  }

  final List<Map<String, dynamic>> services = [
    {'name': 'Corte de Cabelo', 'price': 30.0, 'duration': '30 min'},
    {'name': 'Barba', 'price': 20.0, 'duration': '20 min'}
  ];

  List<String> _availableTimes = []; 

  final AppointmentApi _api = AppointmentApi();

  @override
  void initState() {
    super.initState();
    _loadAvailableTimes();
  }

Future<void> _loadAvailableTimes() async {
  try {
    print('Carregando horários disponíveis para $_selectedDay');
    List<Horario> availableTimes = await _api.getHorariosDisponiveis();
    
    setState(() {
      _availableTimes = availableTimes
          .where((horario) => horario.disponivel) 
          .map((horario) => horario.horarioTexto)
          .toList();
      
      print('Horários carregados: $_availableTimes');
    });
  } catch (e) {
    print('Erro ao carregar horários disponíveis: $e');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agendar Serviços'),
      ),
      body: _buildBody(),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 2,
        onTap: _handleNavigationTap, userType: '',
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
    if (_availableTimes.isEmpty) {
      return Text('Não há horários disponíveis para esta data');
    }

    return Expanded(
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 2.5,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
        ),
        itemCount: _availableTimes.length,
        itemBuilder: (context, index) {
          final time = _availableTimes[index];
          bool isTimeSelected = _selectedTime == time;
          bool isTimeAvailable = !_isTimeAlreadySelected(time);

          return ElevatedButton(
            onPressed: isTimeAvailable ? () => _selectTime(time) : null,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                isTimeSelected ? Colors.blue : (isTimeAvailable ? Colors.grey[300] : Colors.red),
              ),
              foregroundColor: MaterialStateProperty.all(
                isTimeSelected ? Colors.white : Colors.black,
              ),
            ),
            child: Text(time),
          );
        },
      ),
    );
  }

  bool _isTimeAlreadySelected(String time) {
    // Implemente a lógica para verificar se o horário já foi selecionado
    // Esta implementação depende da lógica de negócio da sua aplicação
    return false;
  }

  void _selectTime(String time) {
    setState(() {
      _selectedTime = time;
    });
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
                _saveAppointment();
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

void _saveAppointment() async {
  Validacoes validacoes = new Validacoes();

  try {
    if (_selectedServices.isEmpty || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecione um serviço e um horário')),
      );
      return;
    }

    Horario horarioTeste= Horario(
      id: "",
      horarioId: _selectedTime as String,
      horarioTexto: _selectedTime as String,
      disponivel: true,
    );
    if(!validacoes.verificaMarcarHorario(horarioTeste,_userType)){
      return;
    }

    final selectedService = services.firstWhere((service) => _selectedServices.contains(service['name']));
    final String servico = selectedService['name'];
    final double valor = selectedService['price'];
    final int minuto = int.parse(selectedService['duration'].split(' ')[0]); // Extrai minutos do tempo

    String data = '${_selectedDay.year}-${_selectedDay.month.toString().padLeft(2, '0')}-${_selectedDay.day.toString().padLeft(2, '0')}';

    await _api.marcarHorario(
      horarioId: _selectedTime!, 
      data: data,
      servico: servico,
      valor: valor,
      minuto: minuto,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Serviço agendado para $_selectedDay às $_selectedTime')),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  } catch (e) {
    print('Erro ao marcar horário: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Erro ao marcar horário')),
    );
  }
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
        _loadAvailableTimes();
      });
    }
  }

  void _handleNavigationTap(int index) {
    if (index == 0) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProfilePage()));
    } else if (index == 1) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
    }
  }
}
