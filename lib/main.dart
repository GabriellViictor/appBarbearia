import 'package:flutter/material.dart';
import 'package:app_barbearia/Pages/LoginPage.dart';
import 'package:app_barbearia/Utils/DatabaseHelper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await showRegisteredUsers();
  runApp(const MyApp());
}


Future<void> showRegisteredUsers() async {
  final dbHelper = DatabaseHelper.instance;
  final users = await dbHelper.getUsers(); 
  print('Usuários cadastrados:');
  users.forEach((user) {
    print('ID: ${user['id']}, Username: ${user['username']}, Password: ${user['password']}, Type: ${user['type']}');
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: LoginPage(),
    );
  }
}
