import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_clonsito/src/pages/driver/map/driver_map_controller.dart';
import 'package:uber_clonsito/src/utils/Colors.dart' as utils;
import 'package:uber_clonsito/src/widgets/button_app.dart';

class DriverMapPage extends StatefulWidget {
  @override
  _DriverMapPageState createState() => _DriverMapPageState();
}

class _DriverMapPageState extends State<DriverMapPage> {
  DriverMapController _con = new DriverMapController();

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

//Este método se ejecuta cuando se cierra la pantalla del mapa del conductor
  @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
    super.dispose();
    print('Se ejecuto el dispose');
    _con.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.key,
      drawer: _drawer(),
      body: Stack(children: [
        _googleMapsWidget(),
        SafeArea(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [_buttonDrawer(), _buttonCenterPosition()],
              ),
              Expanded(child: Container()),
              _buttonConnect()
            ],
          ),
        )
      ]),
    );
  }

  Widget _drawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Column(
              //alaienar en forma vertical
              mainAxisAlignment: MainAxisAlignment.start,
              //Alinear los elementos a la izquierda
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    _con.driver?.username??'Nombre del usuario',
                    style: TextStyle(
                        fontSize: 18,
                        color: utils.Colors.QuintoUber,
                        fontWeight: FontWeight.bold),
                    maxLines: 1,
                  ),
                ),
                Container(
                  child: Text(
                    _con.driver?.email??'Correo electronico: ',
                    style: TextStyle(
                        fontSize: 14,
                        color: utils.Colors.CuartoUber,
                        fontWeight: FontWeight.bold),
                    maxLines: 1,
                  ),
                ),
                SizedBox(height: 10),
                CircleAvatar(
                  backgroundImage:
                      AssetImage('assets/img/Perfil_Conductor.jpg'),
                  radius: 40,
                )
              ],
            ),
            decoration: BoxDecoration(color: utils.Colors.PrincipalUber),
          ),
          ListTile(
            title: Text('Editar perfil'),
            trailing: Icon(Icons.edit),
            //leading: Icon(Icons.edit_attributes_rounded),
            onTap: () {},
          ),
          ListTile(
            title: Text('Cerrar Sesión'),
            trailing: Icon(Icons.power_settings_new),
            //leading: Icon(Icons.edit_attributes_rounded),
            onTap: _con.signOut,
          ),
        ],
      ),
    );
  }

  Widget _buttonCenterPosition() {
    return GestureDetector(
      onTap: _con.centerPosition,
      child: Container(
          alignment: Alignment.centerRight,
          margin: EdgeInsets.symmetric(horizontal: 5, vertical: 30),
          child: Card(
              shape: CircleBorder(),
              elevation: 5.0,
              child: Container(
                padding: EdgeInsets.all(8),
                child: Icon(
                  Icons.location_searching,
                  color: utils.Colors.PrincipalUber,
                  size: 25,
                ),
              ))),
    );
  }

  Widget _buttonDrawer() {
    return Container(
      alignment: Alignment.centerLeft,
      child: IconButton(
        onPressed: _con.openDarwer,
        icon: Icon(
          Icons.menu,
          color: Colors.white,
          size: 40,
        ),
      ),
    );
  }

  Widget _buttonConnect() {
    return Container(
      height: 50,
      alignment: Alignment.bottomCenter,
      margin: EdgeInsets.symmetric(horizontal: 60, vertical: 30),
      child: ButtonApp(
        onPressed: _con.conncet,
        text: _con.isConnect ? 'Desconectarse' : 'Conectarse',
        color: _con.isConnect
            ? utils.Colors.CuartoUber
            : utils.Colors.PrincipalUber,
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
    );
  }

  void refresh() {
    setState(() {});
  }
}
