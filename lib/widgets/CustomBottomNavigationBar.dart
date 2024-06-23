import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final String userType;

  const CustomBottomNavigationBar({
    required this.currentIndex,
    required this.onTap,
    required this.userType,
  });

  @override
  Widget build(BuildContext context) {
    List<BottomNavigationBarItem> items = [
      const BottomNavigationBarItem(
        icon: Icon(Icons.exit_to_app),
        label: 'Logout',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
    ];

    if (userType == 'usuario1') {
      items.add(const BottomNavigationBarItem(
        icon: Icon(Icons.schedule), // Ícone para agendamento de cliente
        label: 'Agendamento Cliente',
      ));
    } else if (userType == 'usuario2') {
      items.add(const BottomNavigationBarItem(
        icon: Icon(Icons.schedule), // Ícone para agendamento de barbeiro
        label: 'Agendamento Barbeiro',
      ));
    }

    // Garantir que currentIndex está dentro dos limites válidos dos itens
    int adjustedIndex = currentIndex.clamp(0, items.length - 1);

    return BottomNavigationBar(
      currentIndex: adjustedIndex,
      onTap: onTap,
      items: items,
    );
  }
}
