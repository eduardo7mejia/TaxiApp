import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lottie/lottie.dart';
import 'package:uber_clonsito/src/pages/home/home_controllers.dart';
import 'package:uber_clonsito/src/utils/Colors.dart' as utils;

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeController _con = new HomeController();

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
    //Inicializando nuesttro controlador
    // _con.init(context);
    //Esqueleto de todo la página (Scaffold)
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: HexColor("#516195"),
        title: Text(
          'Taxi App',
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [HexColor("#516195"), HexColor("#596899")])),
          child: Column(
            children: [
              _bannerApp(context),
              SizedBox(height: 15),
              _textSelectRol(),
              SizedBox(height: 25),
              _imageTypeUser(context, 'assets/img/Cliente.png', 'client'),
              SizedBox(height: 10),
              _textTypeUser('Cliente'),
              SizedBox(height: 30),
              _imageTypeUser(context, 'assets/img/User.png', 'driver'),
              SizedBox(height: 10),
              _textTypeUser('Conductor')
            ],
          ),
        ),
      ),
    );
  }

  Widget _bannerApp(BuildContext context) {
    return ClipPath(
      clipper: WaveClipperOne(),
      child: Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height * 0.30,
        child: Row(
          //Separar imagen con el texto
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
          Lottie.asset(
              'assets/json/car-ment.json',
              width: 200,
              height: 180,
              fit: BoxFit.fill,
            ),
            Text('"Rapido y Seguro"',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: utils.Colors.PrincipalUber))
          ],
        ),
      ),
    );
  }

  Widget _imageTypeUser(BuildContext context, String image, String typeUser) {
    return GestureDetector(
      onTap: () => _con.goToLoginPage(typeUser),
      child: CircleAvatar(
        backgroundImage: AssetImage(image),
        radius: 50,
        backgroundColor: Colors.transparent,
      ),
    );
  }

  Widget _textSelectRol() {
    return Text(
      'SELECCIONE SU ROL',
      style: TextStyle(
          color: Colors.white,
          fontSize: 23,
          fontWeight: FontWeight.bold,
          fontFamily: 'Roboto'),
    );
  }

  Widget _textTypeUser(String typeUser) {
    return Text(
      typeUser,
      style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'Roboto'),
    );
  }
}
