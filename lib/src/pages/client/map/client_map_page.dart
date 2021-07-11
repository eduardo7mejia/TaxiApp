import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_clonsito/src/pages/client/map/client_map_controller.dart';
import 'package:uber_clonsito/src/utils/Colors.dart' as utils;
import 'package:uber_clonsito/src/widgets/button_app.dart';

class ClientMapPage extends StatefulWidget {
  @override
  _ClientMapPageState createState() => _ClientMapPageState();
}

class _ClientMapPageState extends State<ClientMapPage> {
  ClientMapController _con = new ClientMapController();
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
              _buttonDrawer(),
              _cardGooglePlace(),
              _buttonChangeTo(),
              _buttonCenterPosition(),
              Expanded(child: Container()),
              _buttonRequest()
            ],
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: _iconMyLocation(),
        )
      ]),
    );
  }

  Widget _iconMyLocation() {
    return Image.asset(
      'assets/img/My_Location.png',
      width: 40,
      height: 40,
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
                    _con.client?.username ?? 'Nombre del usuario',
                    style: TextStyle(
                        fontSize: 25,
                        color: utils.Colors.QuintoUber,
                        fontWeight: FontWeight.bold),
                    maxLines: 1,
                  ),
                ),
                Container(
                  child: Text(
                    _con.client?.email ?? 'Correo electronico: ',
                    style: TextStyle(
                        fontSize: 14,
                        color: utils.Colors.CuartoUber,
                        fontWeight: FontWeight.bold),
                    maxLines: 1,
                  ),
                ),
                SizedBox(height: 10),
                CircleAvatar(
                  backgroundImage: AssetImage('assets/img/Perfil_Cliente.jpg'),
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
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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

  Widget _buttonChangeTo() {
    return GestureDetector(
      onTap: _con.ChangeFromTo,
      child: Container(
          alignment: Alignment.centerRight,
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Card(
              shape: CircleBorder(),
              elevation: 5.0,
              child: Container(
                padding: EdgeInsets.all(8),
                child: Icon(
                  Icons.refresh,
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

  Widget _buttonRequest() {
    return Container(
      height: 50,
      alignment: Alignment.bottomCenter,
      margin: EdgeInsets.symmetric(horizontal: 60, vertical: 30),
      child: ButtonApp(
        onPressed: () {},
        text: 'Confirmar viaje',
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
      onCameraMove: (position) {
        _con.initialPosition = position;
      },
      onCameraIdle: () async {
        await _con.setLocationDraggableInfo();
      },
    );
  }

  Widget _cardGooglePlace() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _infoCardLocation('Desde', _con.from ?? '', () async {
                await _con.showGoogleAutocomplete(true);
              }),
              SizedBox(height: 5),
              Container(
                  child: Divider(color: utils.Colors.CuartoUber, height: 10)),
              SizedBox(height: 5),
              _infoCardLocation('Hasta', _con.to ?? '', () async {
                await _con.showGoogleAutocomplete(false);
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoCardLocation(String title, String value, Function function) {
    return GestureDetector(
      onTap: function,
          child: Column(children: [
        Text(
          title,
          style: TextStyle(color: utils.Colors.CuartoUber, fontSize: 15),
        ),
        Text(
          value,
          style: TextStyle(
            color: utils.Colors.SecundarioUber,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 2,
        ),
      ]),
    );
  }

  void refresh() {
    setState(() {});
  }
}
