import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GeofireProvider{

  CollectionReference _ref;
  Geoflutterfire _geo;

  GeofireProvider(){
    _ref = FirebaseFirestore.instance.collection('Locations');
    _geo = Geoflutterfire();
  }
  //Conseguir conductores cercanos en tiempo real(Stream)
  Stream<List<DocumentSnapshot>>getNearbyDrivers(double lat, double lng, double radius){
    GeoFirePoint center = _geo.point(latitude: lat, longitude: lng);
    return _geo.collection(collectionRef: _ref.where('status',isEqualTo: 'drivers_available')
    ).within(center: center, radius: radius, field: 'position');
  }
  

  Stream<DocumentSnapshot> getLocationByIdStream(String id){
    return _ref.doc(id).snapshots(includeMetadataChanges: true);
  }

  //Alamacenar la información de la base de datos (la posición del conductor)
  Future<void>create(String id, double lat, double lng){
    GeoFirePoint myLocation = _geo.point(latitude: lat, longitude: lng);
    return _ref.doc(id).set({'status': 'drivers_available','position': myLocation.data});
  }
  //eliminar la posición actual del conductor
  Future<void> delete(String id){
    return _ref.doc(id).delete();
  }
}