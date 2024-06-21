import 'package:app_barbearia/Pages/Agendamento.dart';
import 'package:flutter/material.dart';
import 'package:app_barbearia/api/AuthApi.dart';
import 'package:app_barbearia/Pages/HomePage.dart';  // Certifique-se de importar a HomePage corretamente
import 'package:app_barbearia/widgets/Button.dart';
import 'package:app_barbearia/widgets/Field.dart';
import 'package:app_barbearia/widgets/FieldPassword.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _focusPassword = FocusNode();
  final _tLogin = TextEditingController();
  final _tPassword = TextEditingController();
  bool _showProgress = false;

  final LoginService _loginService = LoginService(baseUrl: 'http://54.234.198.193:3333');

  @override
  void dispose() {
    _tLogin.dispose();
    _tPassword.dispose();
    _focusPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _background(),
          _body(),
        ],
      ),
    );
  }

  Widget _background() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.blue[900],
    );
  }

  Widget _body() {
    return Container(
      padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _logo(),
          _form(),
          _resetPassword(),
          if (_showProgress) CircularProgressIndicator(), 
        ],
      ),
    );
  }

  Widget _logo() {
    return Image.asset("lib/assets/images/logo.png");
  }

  Widget _form() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Field(
            label: "Login",
            hint: "Digite seu login",
            controller: _tLogin,
            textInputAction: TextInputAction.next,
            nextFocus: _focusPassword,
          ),
          const SizedBox(height: 10),
          FieldPassword(
            label: "Senha",
            hint: "Digite sua senha",
            textInputAction: TextInputAction.go,
            textCapitalization: TextCapitalization.none,
            controller: _tPassword,
            focusNode: _focusPassword,
          ),
          const SizedBox(height: 10),
          Button(
            label: "Entrar",
            onPressed: _login,
          ),
        ],
      ),
    );
  }

  Widget _resetPassword() {
    return InkWell(
      onTap: () {
        // Implemente aqui a lógica para redefinir a senha
      },
      child: Text(
        "Esqueci minha senha",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  void _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _showProgress = true;
    });

    final login = _tLogin.text;
    final senha = _tPassword.text;

    print('Login: $login');

    try {
      final response = await _loginService.login(login, senha);

      if (response.ok) {
        // Login bem-sucedido
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),  
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text('Error'),
            content: Text(response.msg),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Error'),
          content: Text('Falha ao realizar login. Tente novamente!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } finally {
      setState(() {
        _showProgress = false;
      });
    }
  }
}
