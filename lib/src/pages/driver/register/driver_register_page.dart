import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:uber_clonsito/src/pages/driver/register/driver_register_controller.dart';
import 'package:uber_clonsito/src/utils/Colors.dart' as utils;
import 'package:uber_clonsito/src/utils/otp_widget.dart';
import 'package:uber_clonsito/src/widgets/button_app.dart';

class DriverRegisterPage extends StatefulWidget {
  @override
  _DriverRegisterPageState createState() => _DriverRegisterPageState();
}

class _DriverRegisterPageState extends State<DriverRegisterPage> {
  DriverRegisterController _con = new DriverRegisterController();

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
            _textLicencePlate(),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 25),
              child: OTPFields(
                pin1: _con.pin1Controller,
                pin2: _con.pin2Controller,
                pin3: _con.pin3Controller,
                pin4: _con.pin4Controller,
                pin5: _con.pin5Controller,
                pin6: _con.pin6Controller,
                pin7: _con.pin7Controller,
              ),
            ),
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
            Image.asset(
              'assets/img/register2.png',
              width: 150,
              height: 200,
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
        'Registro',
        style: TextStyle(
            color: utils.Colors.PrincipalUber,
            fontWeight: FontWeight.bold,
            fontSize: 35),
      ),
    );
  }

  Widget _textLicencePlate() {
    return Container(
      child: Text(
        'Placa del vehículo',
        style: TextStyle(color: utils.Colors.SecundarioUber, fontSize: 17),
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

  Widget _textSiTienesCuenta() {
    return GestureDetector(
      onTap: _con.goToLoginPage,
      child: Container(
        margin: EdgeInsets.only(bottom: 50),
        child: Text(
          '¿Ya tienes una cuenta?, inicia sesión',
          style: TextStyle(fontSize: 17, color: utils.Colors.SecundarioUber),
        ),
      ),
    );
  }
}
