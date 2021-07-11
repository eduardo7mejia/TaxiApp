import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uber_clonsito/src/models/driver.dart';

class DriverProvider {
  CollectionReference _ref;

  DriverProvider() {
    _ref = FirebaseFirestore.instance.collection('Drivers');
  }
  // ignore: missing_return
  Future<void> create(Driver driver) {
    String errorMessage;
    try {
      return _ref.doc(driver.id).set(driver.toJson());
    } catch (error) {
      errorMessage = error.code;
    }
    if (errorMessage != null) {
      return Future.error(errorMessage);
    }
  }
//Obtener la información de el usuario
  Stream<DocumentSnapshot> getByIdstream(String id){
    return _ref.doc(id).snapshots(includeMetadataChanges: true);
  }

  //Verificar is es cliente o conductor
  Future<Driver> getByID(String id) async {
    DocumentSnapshot document = await _ref.doc(id).get();
    if (document.exists) {
      Driver driver = Driver.fromJson(document.data());
      return driver;
    } else {
      return null;
    }
  }
}
