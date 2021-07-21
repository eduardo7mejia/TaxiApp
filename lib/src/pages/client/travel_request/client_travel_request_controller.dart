import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_clonsito/src/models/travel_info.dart';
import 'package:uber_clonsito/src/providers/auth_provider.dart';
import 'package:uber_clonsito/src/providers/driver_provider.dart';
import 'package:uber_clonsito/src/providers/travel_info_provider.dart';

class ClientTravelRequestController {
  
  BuildContext context;
  Function refresh;
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  String from;
  String to;
  LatLng fromLatLng;
  LatLng toLatLng;

  TravelInfoProvider _travelInfoProvider;
  AuthProvider _authProvider;
  DriverProvider _driverProvider;

  Future init(BuildContext context, Function refresh){
    this.context = context;
    this.refresh = refresh;
    
    _travelInfoProvider = new TravelInfoProvider();
    _authProvider = new AuthProvider();
    _driverProvider = new DriverProvider();
    
    Map<String, dynamic> arguments =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    from = arguments['from'];
    to = arguments['to'];
    fromLatLng = arguments['fromLatLng'];
    toLatLng = arguments['toLatLng'];

    _createTravelInfo();
    // refresh();
  }

  void _createTravelInfo() async{
    TravelInfo travelInfo = new TravelInfo(
      id: _authProvider.getUser().uid,
      from: from,
      to: to,
      fromLat: fromLatLng.latitude,
      fromLng: fromLatLng.longitude,
      toLat: toLatLng.latitude,
      toLng: toLatLng.longitude,
      status: 'created'
    );
    await _travelInfoProvider.create(travelInfo);
  }
}