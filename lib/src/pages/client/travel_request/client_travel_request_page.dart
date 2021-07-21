import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:lottie/lottie.dart';
import 'package:uber_clonsito/src/utils/Colors.dart' as utils;
import 'package:uber_clonsito/src/pages/client/travel_request/client_travel_request_controller.dart';
import 'package:uber_clonsito/src/widgets/button_app.dart';

class ClientTravelRequestPage extends StatefulWidget {
  @override
  _ClientTravelRequestPageState createState() =>
      _ClientTravelRequestPageState();
}

class _ClientTravelRequestPageState extends State<ClientTravelRequestPage> {
  ClientTravelRequestController _con = new ClientTravelRequestController();
  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        _driverInfo(),
        _lottieAnimation(),
        _textLookingFor(),
        _textCounter(),
        
      ],
    ),
    bottomNavigationBar: _buttonCancel(),);
  }

  Widget _lottieAnimation() {
    return Lottie.asset('assets/json/car-control.json',
        width: MediaQuery.of(context).size.width * 0.7,
        height: MediaQuery.of(context).size.height * 0.35,
        fit: BoxFit.fill);
  }

  Widget _textLookingFor() {
    return Container(
        child: Text('Buscando conductor',
            style: TextStyle(fontSize: 17, color: utils.Colors.PrincipalUber)));
  }

  Widget _textCounter() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 30),
      child: Text(
        '0',
        style: TextStyle(fontSize: 30),
      ),
    );
  }

  Widget _buttonCancel() {
    return Container(
      height: 50,
      margin: EdgeInsets.all(30),
      child: ButtonApp(
        text: 'Cancelar viaje',
        color: utils.Colors.TerceroUber,
        icon: Icons.cancel_outlined,
        textColor: utils.Colors.SecundarioUber,
      ),
    );
  }

  Widget _driverInfo() {
    return ClipPath(
      clipper: WaveClipperOne(),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.3,
        color: utils.Colors.PrincipalUber,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/img/Perfil_Conductor.jpg'),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'Tu conductor',
                maxLines: 1,
                style: TextStyle(
                  fontSize: 18,
                  color: utils.Colors.QuintoUber,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}
