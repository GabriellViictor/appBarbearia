import 'package:app_barbearia/Pages/HomePage.dart';
import 'package:app_barbearia/widgets/Button.dart';
import 'package:app_barbearia/widgets/Field.dart';
import 'package:app_barbearia/widgets/FieldPassword.dart';
import 'package:flutter/material.dart';

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

  @override
  void dispose() {
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
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()), // Replace HomePage() with your actual home page widget
            );
          },
        )


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

}