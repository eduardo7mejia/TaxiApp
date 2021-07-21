import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:uber_clonsito/src/pages/client/map/client_map_page.dart';
import 'package:uber_clonsito/src/pages/client/travel_info/client_travel_info_page.dart';
import 'package:uber_clonsito/src/pages/client/travel_request/client_travel_request_page.dart';
import 'package:uber_clonsito/src/pages/driver/map/driver_map_page.dart';
import 'package:uber_clonsito/src/pages/driver/register/driver_register_page.dart';
import 'package:uber_clonsito/src/pages/home/home_page.dart';
import 'package:uber_clonsito/src/pages/login/login_page.dart';
import 'package:uber_clonsito/src/pages/client/register/client_register_page.dart';
import 'package:uber_clonsito/src/utils/Colors.dart' as utils;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
//Clase con la que interactuan las pantallas 
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ment', 
      initialRoute: 'home',
      theme: ThemeData(
        fontFamily: 'Nunito',
        appBarTheme: AppBarTheme(
          elevation: 0
        ),
        primaryColor: utils.Colors.PrincipalUber
      ),
      routes: {
        'home' : (BuildContext context) => HomePage(),
        'login': (BuildContext context) => LoginPage(),
        'client/register': (BuildContext context) => ClientRegisterPage(),
        'driver/register': (BuildContext context) => DriverRegisterPage(),
        'driver/map': (BuildContext context) => DriverMapPage(),
        'client/map': (BuildContext context) => ClientMapPage(),
        'client/travel/info': (BuildContext context) => ClientTravelInfoPage(),
        'client/travel/request': (BuildContext context) => ClientTravelRequestPage(),
      },
    );
  }
}