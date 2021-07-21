import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:lottie/lottie.dart';
import 'package:uber_clonsito/src/pages/client/register/client_register_controller.dart';
import 'package:uber_clonsito/src/utils/Colors.dart' as utils;
import 'package:uber_clonsito/src/widgets/button_app.dart';

class ClientRegisterPage extends StatefulWidget {
  @override
  _ClientRegisterPageState createState() => _ClientRegisterPageState();
}

class _ClientRegisterPageState extends State<ClientRegisterPage> {
  
  ClientRegisterController _con = new ClientRegisterController();

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
        // resizeToAvoidBottomInset: false,
        key: _con.key,
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Column(children: [
            _bannerApp(),
            _textSesion(),
            _textFieldUsername(),
            _textFieldEmail(),
            _textFieldPassword(),
            _textFieldConfirmPassword(),
            _buttonRegister(),
            _textSiTienesCuenta()
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
          Lottie.asset(
              'assets/json/registrar2.json',
              width: 200,
              height: 300,
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
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Text(
        'Registrate',
        style: TextStyle(
            color: utils.Colors.PrincipalUber,
            fontWeight: FontWeight.bold,
            fontSize: 35),
      ),
    );
  }

  Widget _textFieldEmail() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
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
            hintText: 'Correo electronico',
            suffixIcon:
                Icon(Icons.email_outlined, color: utils.Colors.PrincipalUber)),
      ),
    );
  }

  Widget _textFieldUsername() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: TextField(
        controller: _con.userController,
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
             enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: utils.Colors.PrincipalUber),
              borderRadius: BorderRadius.circular(25.0),
            ),
            hintText: 'Ingresa tu nombre',
            suffixIcon:
                Icon(Icons.person_outline, color: utils.Colors.PrincipalUber)),
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
            hintText: 'Contraseña',
            suffixIcon: Icon(Icons.lock_open_outlined,
                color: utils.Colors.PrincipalUber)),
      ),
    );
  }

  Widget _textFieldConfirmPassword() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: TextField(
        controller: _con.confirmPasswordController,
        obscureText: true,
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: utils.Colors.PrincipalUber),
              borderRadius: BorderRadius.circular(25.0),
            ),
            hintText: 'Repite contraseña',
            suffixIcon: Icon(Icons.lock_open_outlined,
                color: utils.Colors.PrincipalUber)),
      ),
    );
  }

  Widget _buttonRegister() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: ButtonApp(onPressed: _con.register, text: 'Registrar ahora'),
    );
  }

  Widget _textSiTienesCuenta(){
    return GestureDetector(
      onTap: _con.goToLoginPage,
          child: Container(
        margin: EdgeInsets.only(bottom: 50),
        child: Text(
          '¿Ya tienes una cuenta?, inicia sesión',
          style: TextStyle(
            fontSize: 17,
            color: utils.Colors.SecundarioUber
          ),
        ),
      ),
    );
  }
}
