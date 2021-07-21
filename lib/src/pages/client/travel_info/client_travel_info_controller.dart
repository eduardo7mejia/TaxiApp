import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_clonsito/src/api/environment.dart';
import 'package:uber_clonsito/src/models/directions.dart';
import 'package:uber_clonsito/src/models/prices.dart';
import 'package:uber_clonsito/src/providers/google_provider.dart';
import 'package:uber_clonsito/src/providers/prices_provider.dart';
import 'package:uber_clonsito/src/utils/Colors.dart' as utils;

class ClientTravelInfoController {
  BuildContext context;

  GoogleProvider _googleProvider;
  PricesProvider _pricesProvider;

  Function refresh;

  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  Completer<GoogleMapController> _mapController = Completer();

  CameraPosition initialPosition =
      CameraPosition(target: LatLng(19.2287318, -99.6325685), zoom: 14.0);
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  String from;
  String to;
  LatLng fromLatLng;
  LatLng toLatLng;

  Set<Polyline> polylines = {};
  List<LatLng> points = new List();

  BitmapDescriptor fromMarker;
  BitmapDescriptor toMarker;

  Direction _directions;
  String min;
  String km;
  double minTotal;
  double maxTotal;

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;

    Map<String, dynamic> arguments =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    from = arguments['from'];
    to = arguments['to'];
    fromLatLng = arguments['fromLatLng'];
    toLatLng = arguments['toLatLng'];

    _googleProvider = new GoogleProvider();
    _pricesProvider = new PricesProvider();


    fromMarker =
        await createMarketImageFromAsset('assets/img/icon-red-map.png');
    toMarker = await createMarketImageFromAsset('assets/img/icon-blue-map.png');

    animateCameraToPosition(fromLatLng.latitude, fromLatLng.longitude);
    getGoogleMapsDirection(fromLatLng, toLatLng);
  }

  void getGoogleMapsDirection(LatLng from, LatLng to) async {
    _directions = await _googleProvider.getGoogleMapsDirections(
        from.latitude, from.longitude, to.latitude, to.longitude);
    min = _directions.duration.text;
    km = _directions.distance.text;
    calculatePrices();
    refresh();
  }

  void goToRequest(){
    Navigator.pushNamed(context, 'client/travel/request', arguments: {
        'from': from,
        'to': to,
        'fromLatLng': fromLatLng,
        'toLatLng': toLatLng,
      });
  }

  void calculatePrices() async{
    Prices prices = await _pricesProvider.getAll();
    double  kmValue = double.parse(km.split(" ")[0]) * prices.km;
    double minValue = double.parse(min.split(" ")[0]) * prices.min;
    double total = kmValue + minValue;

    minTotal = total - 1.8;
    maxTotal = total + 1.8;
    refresh();

  }

  Future<void> setPolylines() async {
    PointLatLng pointFromLatLng =
        PointLatLng(fromLatLng.latitude, fromLatLng.longitude);
    PointLatLng pointToLatLng =
        PointLatLng(toLatLng.latitude, toLatLng.longitude);

    PolylineResult result = await new PolylinePoints()
        .getRouteBetweenCoordinates(
            Environment.API_KEY_MAPS, pointFromLatLng, pointToLatLng);
//Puntos para trazar la ruta
    for (PointLatLng point in result.points) {
      points.add(LatLng(point.latitude, point.longitude));
    }
    Polyline polyline = Polyline(
      polylineId: PolylineId('poly'),
      color: utils.Colors.TerceroUber,
      points: points,
      width: 6,
    );

    polylines.add(polyline);
    addMarker('from', fromLatLng.latitude, fromLatLng.longitude, 'Recoger aquí',
        '', fromMarker);
    addMarker('to', toLatLng.latitude, toLatLng.longitude, 'Lugar de destino',
        '', toMarker);
    refresh();
  }

  Future animateCameraToPosition(double latitude, double longitude) async {
    GoogleMapController controller = await _mapController.future;
    if (controller != null) {
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          bearing: 0, target: LatLng(latitude, longitude), zoom: 15)));
    }
  }

  void onMapCreated(GoogleMapController controller) async {
    controller.setMapStyle(
        '[ { "elementType": "geometry", "stylers": [ { "color": "#1d2c4d" } ] }, { "elementType": "labels.text.fill", "stylers": [ { "color": "#8ec3b9" } ] }, { "elementType": "labels.text.stroke", "stylers": [ { "color": "#1a3646" } ] }, { "featureType": "administrative.country", "elementType": "geometry.stroke", "stylers": [ { "color": "#4b6878" } ] }, { "featureType": "administrative.land_parcel", "elementType": "labels.text.fill", "stylers": [ { "color": "#64779e" } ] }, { "featureType": "administrative.province", "elementType": "geometry.stroke", "stylers": [ { "color": "#4b6878" } ] }, { "featureType": "landscape.man_made", "elementType": "geometry.stroke", "stylers": [ { "color": "#334e87" } ] }, { "featureType": "landscape.natural", "elementType": "geometry", "stylers": [ { "color": "#023e58" } ] }, { "featureType": "poi", "elementType": "geometry", "stylers": [ { "color": "#283d6a" } ] }, { "featureType": "poi", "elementType": "labels.text.fill", "stylers": [ { "color": "#6f9ba5" } ] }, { "featureType": "poi", "elementType": "labels.text.stroke", "stylers": [ { "color": "#1d2c4d" } ] }, { "featureType": "poi.park", "elementType": "geometry.fill", "stylers": [ { "color": "#023e58" } ] }, { "featureType": "poi.park", "elementType": "labels.text.fill", "stylers": [ { "color": "#3C7680" } ] }, { "featureType": "road", "elementType": "geometry", "stylers": [ { "color": "#304a7d" } ] }, { "featureType": "road", "elementType": "labels.text.fill", "stylers": [ { "color": "#98a5be" } ] }, { "featureType": "road", "elementType": "labels.text.stroke", "stylers": [ { "color": "#1d2c4d" } ] }, { "featureType": "road.highway", "elementType": "geometry", "stylers": [ { "color": "#2c6675" } ] }, { "featureType": "road.highway", "elementType": "geometry.stroke", "stylers": [ { "color": "#255763" } ] }, { "featureType": "road.highway", "elementType": "labels.text.fill", "stylers": [ { "color": "#b0d5ce" } ] }, { "featureType": "road.highway", "elementType": "labels.text.stroke", "stylers": [ { "color": "#023e58" } ] }, { "featureType": "transit", "elementType": "labels.text.fill", "stylers": [ { "color": "#98a5be" } ] }, { "featureType": "transit", "elementType": "labels.text.stroke", "stylers": [ { "color": "#1d2c4d" } ] }, { "featureType": "transit.line", "elementType": "geometry.fill", "stylers": [ { "color": "#283d6a" } ] }, { "featureType": "transit.station", "elementType": "geometry", "stylers": [ { "color": "#3a4762" } ] }, { "featureType": "water", "elementType": "geometry", "stylers": [ { "color": "#0e1626" } ] }, { "featureType": "water", "elementType": "labels.text.fill", "stylers": [ { "color": "#4e6d70" } ] } ]');
    _mapController.complete(controller);
    await setPolylines();
  }

  Future<BitmapDescriptor> createMarketImageFromAsset(String path) async {
    ImageConfiguration configuration = ImageConfiguration();
    BitmapDescriptor bitmapDescriptor =
        await BitmapDescriptor.fromAssetImage(configuration, path);
    return bitmapDescriptor;
  }

  void addMarker(String markerId, double lat, double lng, String title,
      String content, BitmapDescriptor iconMarker) {
    MarkerId id = MarkerId(markerId);
    Marker marker = Marker(
      markerId: id,
      icon: iconMarker,
      position: LatLng(lat, lng),
      infoWindow: InfoWindow(title: title, snippet: content),
    );
    markers[id] = marker;
  }
}
