import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:uber_clonsito/src/api/environment.dart';
import 'package:uber_clonsito/src/models/client.dart';
import 'package:uber_clonsito/src/providers/auth_provider.dart';
import 'package:uber_clonsito/src/providers/client_provider.dart';
import 'package:uber_clonsito/src/providers/driver_provider.dart';
import 'package:uber_clonsito/src/providers/geofire_provider.dart';
import 'package:uber_clonsito/src/utils/my_progress_dialog.dart';
import 'package:uber_clonsito/src/utils/snackbar.dart' as utils;
import 'package:google_maps_webservice/places.dart' as places;
import 'package:flutter_google_places/flutter_google_places.dart';
// ignore: unused_import
import 'package:geocoder/geocoder.dart';
import 'package:geocoding/geocoding.dart';

class ClientMapController {
  BuildContext context;
  Function refresh;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  Completer<GoogleMapController> _mapController = Completer();

  CameraPosition initialPosition =
      CameraPosition(target: LatLng(19.2287318, -99.6325685), zoom: 14.0);

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  // ignore: missing_return
  Position _position;
  StreamSubscription<Position> _positionStream;
  BitmapDescriptor markerDriver;

  GeofireProvider _geofireProvider;
  AuthProvider _authProvider;
  // ignore: unused_field
  DriverProvider _driverProvider;
  ClientProvider _clientProvider;

  bool isConnect = false;

  places.GoogleMapsPlaces _places =
      places.GoogleMapsPlaces(apiKey: Environment.API_KEY_MAPS);
  // ignore: unused_field
  ProgressDialog _progressDialog;

  StreamSubscription<DocumentSnapshot> _statusSuscription;
  StreamSubscription<DocumentSnapshot> _clientInfoSubscription;

  Client client;
  String from;
  LatLng fromLatLng;
  String to;
  LatLng toLatLng;

  bool isFromSelected = true;
//Instancear
  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    _geofireProvider = new GeofireProvider();
    _authProvider = new AuthProvider();
    _driverProvider = new DriverProvider();
    _clientProvider = new ClientProvider();

    _progressDialog =
        MyProgressDialog.createProgressDialog(context, 'Conectandose...');
    markerDriver = await createMarketImageFromAsset('assets/img/taxi.png');
    checkGPS();
    getClientInfo();
  }

//
  void getClientInfo() {
    Stream<DocumentSnapshot> clientStream =
        _clientProvider.getByIdstream(_authProvider.getUser().uid);
    _clientInfoSubscription = clientStream.listen((DocumentSnapshot document) {
      client = Client.fromJson(document.data());
      refresh();
    });
  }

  void openDarwer() {
    key.currentState.openDrawer();
  }

  void dispose() {
    _positionStream?.cancel();
    _statusSuscription?.cancel();
    _clientInfoSubscription?.cancel();
  }

//Cerrar sesión y llevarlo a la pantalla de inicio
  void signOut() async {
    await _authProvider.signOut();
    Navigator.pushNamedAndRemoveUntil(context, 'home', (route) => false);
  }

  void onMapCreated(GoogleMapController controller) {
    controller.setMapStyle(
        '[ { "elementType": "geometry", "stylers": [ { "color": "#1d2c4d" } ] }, { "elementType": "labels.text.fill", "stylers": [ { "color": "#8ec3b9" } ] }, { "elementType": "labels.text.stroke", "stylers": [ { "color": "#1a3646" } ] }, { "featureType": "administrative.country", "elementType": "geometry.stroke", "stylers": [ { "color": "#4b6878" } ] }, { "featureType": "administrative.land_parcel", "elementType": "labels.text.fill", "stylers": [ { "color": "#64779e" } ] }, { "featureType": "administrative.province", "elementType": "geometry.stroke", "stylers": [ { "color": "#4b6878" } ] }, { "featureType": "landscape.man_made", "elementType": "geometry.stroke", "stylers": [ { "color": "#334e87" } ] }, { "featureType": "landscape.natural", "elementType": "geometry", "stylers": [ { "color": "#023e58" } ] }, { "featureType": "poi", "elementType": "geometry", "stylers": [ { "color": "#283d6a" } ] }, { "featureType": "poi", "elementType": "labels.text.fill", "stylers": [ { "color": "#6f9ba5" } ] }, { "featureType": "poi", "elementType": "labels.text.stroke", "stylers": [ { "color": "#1d2c4d" } ] }, { "featureType": "poi.park", "elementType": "geometry.fill", "stylers": [ { "color": "#023e58" } ] }, { "featureType": "poi.park", "elementType": "labels.text.fill", "stylers": [ { "color": "#3C7680" } ] }, { "featureType": "road", "elementType": "geometry", "stylers": [ { "color": "#304a7d" } ] }, { "featureType": "road", "elementType": "labels.text.fill", "stylers": [ { "color": "#98a5be" } ] }, { "featureType": "road", "elementType": "labels.text.stroke", "stylers": [ { "color": "#1d2c4d" } ] }, { "featureType": "road.highway", "elementType": "geometry", "stylers": [ { "color": "#2c6675" } ] }, { "featureType": "road.highway", "elementType": "geometry.stroke", "stylers": [ { "color": "#255763" } ] }, { "featureType": "road.highway", "elementType": "labels.text.fill", "stylers": [ { "color": "#b0d5ce" } ] }, { "featureType": "road.highway", "elementType": "labels.text.stroke", "stylers": [ { "color": "#023e58" } ] }, { "featureType": "transit", "elementType": "labels.text.fill", "stylers": [ { "color": "#98a5be" } ] }, { "featureType": "transit", "elementType": "labels.text.stroke", "stylers": [ { "color": "#1d2c4d" } ] }, { "featureType": "transit.line", "elementType": "geometry.fill", "stylers": [ { "color": "#283d6a" } ] }, { "featureType": "transit.station", "elementType": "geometry", "stylers": [ { "color": "#3a4762" } ] }, { "featureType": "water", "elementType": "geometry", "stylers": [ { "color": "#0e1626" } ] }, { "featureType": "water", "elementType": "labels.text.fill", "stylers": [ { "color": "#4e6d70" } ] } ]');
    _mapController.complete(controller);
  }

  void updateLocation() async {
    try {
      await _determinePosition();
      //Obtener ubicación una unica vez
      _position = await Geolocator.getLastKnownPosition();
      centerPosition();
      getNearbyDrivers();
    } catch (error) {
      print('Error en la localización: $error');
    }
  }
  //Enviar a la pantalla de confirmar viaje (versión de dart v3.20.1)
  void requestDriver(){
    if (fromLatLng != null && toLatLng != null) {
      Navigator.pushNamed(context, 'client/travel/info', arguments: {
        'from': from,
        'to': to,
        'fromLatLng': fromLatLng,
        'toLatLng': toLatLng,
      });
    } else {
      utils.Snackbar.showSnackbar(context, key,'Seleccionar el punto de partida y destino');
    }
  }

  // ignore: non_constant_identifier_names
  void ChangeFromTo() {
    isFromSelected = !isFromSelected;
    if (isFromSelected) {
      utils.Snackbar.showSnackbar(
          context, key, 'Estas Seleccionando el lugar de recogida');
    } else {
      utils.Snackbar.showSnackbar(
          context, key, 'Estas Seleccionando el destino');
    }
  }

  Future<Null> showGoogleAutocomplete(bool isFrom) async {
    places.Prediction p = await PlacesAutocomplete.show(
        context: context,
        apiKey: Environment.API_KEY_MAPS,
        language: 'es',
        strictbounds: true,
        radius: 20000,
        location: places.Location(19.2622211, -99.6339932));

    if (p != null) {
      places.PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId, language: 'es');
      double lat = detail.result.geometry.location.lat;
      double lng = detail.result.geometry.location.lng;
      List<Address> address =
          await Geocoder.local.findAddressesFromQuery(p.description);
      if (address != null) {
        if (address.length > 0) {
          if (detail != null) {
            String direction = detail.result.name;
            String city = address[0].locality;
            // ignore: unused_local_variable
            String departmen = address[0].adminArea;
            if (isFrom) {
              from = '$direction, $city, department';
              fromLatLng = new LatLng(lat, lng);
            } else {
              to = '$direction, $city, department';
              toLatLng = new LatLng(lat, lng);
            }
            refresh();
          }
        }
      }
    }
  }

  Future<Null> setLocationDraggableInfo() async {
    if (initialPosition != null) {
      double lat = initialPosition.target.latitude;
      double lng = initialPosition.target.longitude;
      List<Placemark> address = await placemarkFromCoordinates(lat, lng);
      if (address != null) {
        if (address.length > 0) {
          String direction = address[0].thoroughfare;
          String street = address[0].subThoroughfare;
          String city = address[0].locality;
          String deparment = address[0].administrativeArea;
          // ignore: unused_local_variable
          String country = address[0].country;

          if (isFromSelected) {
            from = '$direction #$street, $city, $deparment';
            fromLatLng = new LatLng(lat, lng);
          } else {
            to = '$direction #$street, $city, $deparment';
            toLatLng = new LatLng(lat, lng);
          }
          refresh();
        }
      }
    }
  }

  void getNearbyDrivers() {
    Stream<List<DocumentSnapshot>> stream = _geofireProvider.getNearbyDrivers(
        _position.latitude, _position.longitude, 10);

    stream.listen((List<DocumentSnapshot> documentList) {
      for (MarkerId m in markers.keys) {
        bool remove = true;
        for (DocumentSnapshot d in documentList) {
          if (m.value == d.id) {
            remove = false;
          }
        }
        if (remove) {
          markers.remove(m);
          refresh();
        }
      }
      for (DocumentSnapshot d in documentList) {
        GeoPoint point = d.data()['position']['geopiont'];
        addMarker(d.id, point.latitude, point.longitude, 'Conductor disponible',
            '', markerDriver);
      }
      refresh();
    });
  }

//Mover la cámara hacia nuestra ubicación
  void centerPosition() {
    if (_position != null) {
      animateCameraToPosition(_position.latitude, _position.longitude);
    } else {
      utils.Snackbar.showSnackbar(
          context, key, 'Activa el GPs para obtener tu posición');
    }
  }

  void checkGPS() async {
    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if (isLocationEnabled) {
      print('GPS Activado');
      updateLocation();
    } else {
      print('GPS Desactivado');
      bool locationGPS = await location.Location().requestService();
      if (locationGPS) {
        updateLocation();

        print('Activo el GPs');
      }
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  Future animateCameraToPosition(double latitude, double longitude) async {
    GoogleMapController controller = await _mapController.future;
    if (controller != null) {
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          bearing: 0, target: LatLng(latitude, longitude), zoom: 13)));
    }
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
        draggable: false,
        zIndex: 2,
        flat: true,
        anchor: Offset(0.5, 0.5),
        rotation: _position.heading);
    markers[id] = marker;
  }
}
