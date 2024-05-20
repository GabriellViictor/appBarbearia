import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_barbearia/Pages/HomePage.dart';
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

  bool showProgress = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _tLogin.dispose();
    _tPassword.dispose();
    _focusPassword.dispose();
    super.dispose();
  }

  _background() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.blue[900], // Dark blue color
    );
  }

  _body() {
    return Container(
      padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _logo(),
          _form(),
          _resetPassword(),
        ],
      ),
    );
  }

  _logo() {
    return Image.asset("lib/assets/images/logo.png");
  }

  _form() {
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
            onPressed: _onLoginPressed,
          ),
        ],
      ),
    );
  }

  _resetPassword() {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, "/"),
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

  void _onLoginPressed() async {
    final username = _tLogin.text;
    final password = _tPassword.text;

    // Verifica se o formulário é válido
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        showProgress = true;
      });

      if ((username == 'user1' && password == '123') ||
          (username == 'user2' && password == '123')) {
        
        // Store the username in shared preferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('loggedInUser', username);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()), // Página do usuário
        );
      } else {
        setState(() {
          showProgress = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login ou senha inválidos')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _background(),
          _body(),
          if (showProgress)
            Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
