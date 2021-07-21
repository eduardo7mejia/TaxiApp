import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:uber_clonsito/src/pages/login/login_controller.dart';
import 'package:uber_clonsito/src/utils/Colors.dart' as utils;
import 'package:uber_clonsito/src/widgets/button_app.dart';
import 'package:lottie/lottie.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginController _con = new LoginController();

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    print('Init State');
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      print('Metodo Scheduler');
      _con.init(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    print('Metodo Build');
    return Scaffold(
        key: _con.key,
        // resizeToAvoidBottomInset: false,
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Column(children: [
            _bannerApp(),
            _textSesion(),
            SizedBox(height: MediaQuery.of(context).size.height * 0.10),
            _textFieldEmail(),
            _textFieldPassword(),
            _buttonLogin(),
            _textNoTienesCuenta()
          ]),
        ));
  }

  //Widget del banner de al App
  Widget _bannerApp() {
    return ClipPath(
      clipper: OvalBottomBorderClipper(),
      child: Container(
        color: utils.Colors.PrincipalUber,
        height: MediaQuery.of(context).size.height * 0.20,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          //Separar imagen con el texto
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Image.asset(
            //   'assets/img/Login.png',
            //   width: 200,
            //   height: 300,
            // ),
            Lottie.asset(
              'assets/json/user-ingresar.json',
              width: 160,
              height: 200,
              fit: BoxFit.fill,
            ),
            Text('Bienvenido',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white))
          ],
        ),
      ),
    );
  }

  Widget _textSesion() {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Text(
        'Ingresa a tu cuenta',
        style: TextStyle(
            color: utils.Colors.PrincipalUber,
            fontWeight: FontWeight.bold,
            fontSize: 30),
      ),
    );
  }

  Widget _textFieldEmail() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: TextField(
        controller: _con.emailController,
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: utils.Colors.PrincipalUber),
              borderRadius: BorderRadius.circular(25.0),
            ),
            hintText: 'correo electronico',
            suffixIcon:
                Icon(Icons.email_outlined, color: utils.Colors.PrincipalUber)),
      ),
    );
  }

  Widget _textFieldPassword() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: TextField(
        controller: _con.passwordController,
        obscureText: true,
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: utils.Colors.PrincipalUber),
              borderRadius: BorderRadius.circular(25.0),
            ),
            hintText: 'contraseña',
            suffixIcon: Icon(Icons.lock_open_outlined,
                color: utils.Colors.PrincipalUber)),
      ),
    );
  }

  Widget _buttonLogin() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: ButtonApp(onPressed: _con.login, text: 'Iniciar sesión'),
    );
  }

  Widget _textNoTienesCuenta() {
    return GestureDetector(
      onTap: _con.goToRegisterPage,
      child: Container(
        margin: EdgeInsets.only(bottom: 50),
        child: Text(
          '¿No tienes cuenta?',
          style: TextStyle(fontSize: 17, color: utils.Colors.SecundarioUber),
        ),
      ),
    );
  }
}
