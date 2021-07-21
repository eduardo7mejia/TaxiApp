import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/scheduler.dart';
import 'package:uber_clonsito/src/pages/client/travel_info/client_travel_info_controller.dart';
import 'package:uber_clonsito/src/utils/Colors.dart' as utils;
import 'package:uber_clonsito/src/widgets/button_app.dart';

class ClientTravelInfoPage extends StatefulWidget {
  @override
  _ClientTravelInfoPageState createState() => _ClientTravelInfoPageState();
}

class _ClientTravelInfoPageState extends State<ClientTravelInfoPage> {
  ClientTravelInfoController _con = new ClientTravelInfoController();

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
      key: _con.key,
      body: Stack(
        children: [
          Align(
            child: _googleMapsWidget(),
            alignment: Alignment.topCenter,
          ),
          Align(
            child: _cradTravelInfo(),
            alignment: Alignment.bottomCenter,
          ),
          Align(
            child: _buttonBack(),
            alignment: Alignment.topLeft,
          ),
          Align(
            child: _cardKmInfo(_con.km),
            alignment: Alignment.topRight,
          ),
           Align(
            child: _cardMinInfo(_con.min),
            alignment: Alignment.topRight,
          )
        ],
      ),
    );
  }

  Widget _cradTravelInfo() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.33,
      padding: EdgeInsets.symmetric(vertical: 10),
    //  padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: utils.Colors.SextoUber,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          )),
      child: Column(
        children: [
          ListTile(
            title: Text('Punto de partida', style: TextStyle(fontSize: 15)),
            subtitle: Text(
              _con.from ?? '',
              style: TextStyle(fontSize: 13),
            ),
            leading: Icon(Icons.location_on),
          ),
          ListTile(
            title: Text('¿A donde vamos?', style: TextStyle(fontSize: 15)),
            subtitle: Text(
              _con.to ?? '',
              style: TextStyle(fontSize: 13),
            ),
            leading: Icon(Icons.my_location),
          ),
          ListTile(
            title: Text('Precio aproximado: ', style: TextStyle(fontSize: 15)),
            subtitle: Text(
              '\$ ${_con.minTotal?.toStringAsFixed(2) ?? '0.0'} - \$ ${_con.maxTotal?.toStringAsFixed(2) ?? '0.0'}',
              style: TextStyle(fontSize: 13),
              maxLines: 1,
            ),
            leading: Icon(Icons.attach_money),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 30),
            child: ButtonApp(
              onPressed: _con.goToRequest,
              text: 'CONFIRMAR',
              textColor: utils.Colors.QuintoUber,
              color: utils.Colors.PrincipalUber,
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardKmInfo(String km) {
    return SafeArea(
      child: Container(
        width: 110,
        padding: EdgeInsets.symmetric(horizontal: 30),
        margin: EdgeInsets.only(right: 15, top: 20),
        decoration: BoxDecoration(
            color: utils.Colors.CuartoUber,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Text(km ?? '0 km', maxLines: 1,),
      ),
    );
  }

  Widget _cardMinInfo(String km) {
    return SafeArea(
      child: Container(
        width: 110,
        padding: EdgeInsets.symmetric(horizontal: 30),
        margin: EdgeInsets.only(right: 15, top: 45),
        decoration: BoxDecoration(
            color: utils.Colors.TerceroUber,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Text(km ?? '0 Min', maxLines: 1,),
      ),
    );
  }

  Widget _buttonBack() {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: CircleAvatar(
          radius: 20,
          backgroundColor: utils.Colors.QuintoUber,
          child: Icon(
            Icons.arrow_back,
            color: utils.Colors.PrincipalUber,
          ),
        ),
      ),
    );
  }

  Widget _googleMapsWidget() {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _con.initialPosition,
      onMapCreated: _con.onMapCreated,
      myLocationEnabled: false,
      myLocationButtonEnabled: true,
      markers: Set<Marker>.of(_con.markers.values),
      polylines: _con.polylines,
    );
  }

  void refresh() {
    setState(() {});
  }
}
