import 'package:flutter/material.dart';
import 'package:app_barbearia/Utils/DataBaseHelper.dart';

class BarberSchedulePage extends StatefulWidget {
  const BarberSchedulePage({Key? key}) : super(key: key);

  @override
  State<BarberSchedulePage> createState() => _BarberSchedulePageState();
}

class _BarberSchedulePageState extends State<BarberSchedulePage> {
  final List<String> _availableTimes = [
    '09:00', '10:00', '11:00', '12:00',
    '13:00', '14:00', '15:00', '16:00',
    '17:00', '18:00'
  ];
  List<String> _selectedUnavailableTimes = [];

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
    );
  }

  Widget _buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16.0),
        Text(
          'Horários Disponíveis',
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _availableTimes.length,
            itemBuilder: (context, index) {
              final time = _availableTimes[index];
              final isUnavailable = _selectedUnavailableTimes.contains(time);
              return ListTile(
                title: Text(time),
                trailing: isUnavailable ? Icon(Icons.check, color: Colors.red) : null,
                onTap: () {
                  setState(() {
                    if (isUnavailable) {
                      _selectedUnavailableTimes.remove(time);
                    } else {
                      _selectedUnavailableTimes.add(time);
                    }
                  });
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
          child: ListView.builder(
            itemCount: _selectedUnavailableTimes.length,
            itemBuilder: (context, index) {
              final time = _selectedUnavailableTimes[index];
              return ListTile(
                title: Text(time),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      _selectedUnavailableTimes.removeAt(index);
                    });
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _saveSelectedTimes() async {
    final DatabaseHelper dbHelper = DatabaseHelper.instance;
    await dbHelper.deleteAllUnavailableTimes();
    for (String time in _selectedUnavailableTimes) {
      await dbHelper.insertUnavailableTime(time);
    }
    print('Horários indisponíveis salvos no banco de dados: $_selectedUnavailableTimes');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Horários indisponíveis salvos no banco de dados')),
    );
  }

  
}
