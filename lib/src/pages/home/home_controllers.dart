import 'package:flutter/material.dart';
import 'package:uber_clonsito/src/providers/auth_provider.dart';
import 'package:uber_clonsito/src/utils/shared_pref.dart';

class HomeController {
  BuildContext context;
  SharedPref _sharedPref;

  AuthProvider _authProvider;
  String _typeUser;

  // ignore: missing_return
  Future init(BuildContext context) async {
    this.context = context;
    _sharedPref = new SharedPref();
    _authProvider = new AuthProvider();
    _typeUser = await _sharedPref.read('typeUser');
    // _authProvider.checkIfUserLogged(context, _typeUser);
    checkIfUserIsAuth();
  }

  void checkIfUserIsAuth() {
    bool isSigned = _authProvider.isSignedIn();
    if (isSigned) {
      print('Si esta logeado');
      if (_typeUser == 'client') {
        Navigator.pushNamedAndRemoveUntil(
            context, 'client/map', (route) => false);
      } else {
      Navigator.pushNamedAndRemoveUntil(
          context, 'driver/map', (route) => false);
      }
    }else{
      print('No esta logeado');
    }
  }

  //Cambiar de pantalla
  void goToLoginPage(String typeUser) {
    saveTypeUser(typeUser);
    Navigator.pushNamed(context, 'login');
  }

  void saveTypeUser(String typeUser) async {
    // ignore: await_only_futures
    await _sharedPref.save('typeUser', typeUser);
  }
}
