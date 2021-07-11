import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uber_clonsito/src/models/client.dart';

class ClientProvider {
  CollectionReference _ref;

  ClientProvider() {
    _ref = FirebaseFirestore.instance.collection('Clients');
  }
  // ignore: missing_return
  Future<void> create(Client client) {
    String errorMessage;
    try {
      return _ref.doc(client.id).set(client.toJson());
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

  //Verificar si es cliente o conductor
  Future<Client> getByID(String id) async {
    DocumentSnapshot document = await _ref.doc(id).get();
    if (document.exists) {
      Client client = Client.fromJson(document.data());
      return client;
    } else {
      return null;
    }
  }
}
