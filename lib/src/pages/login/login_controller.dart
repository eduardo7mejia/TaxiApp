import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:uber_clonsito/src/models/client.dart';
import 'package:uber_clonsito/src/models/driver.dart';
import 'package:uber_clonsito/src/providers/auth_provider.dart';
import 'package:uber_clonsito/src/providers/client_provider.dart';
import 'package:uber_clonsito/src/providers/driver_provider.dart';
import 'package:uber_clonsito/src/utils/my_progress_dialog.dart';
import 'package:uber_clonsito/src/utils/shared_pref.dart';
import 'package:uber_clonsito/src/utils/snackbar.dart' as utils;

class LoginController {
  BuildContext context;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();

  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  AuthProvider _authProvider;
  ProgressDialog _progressDialog;
  DriverProvider _driverProvider;
  ClientProvider _clientProvider;

  SharedPref _sharedPref;
  String _typeUser;

  // ignore: missing_return
  Future init(BuildContext context) async {
    this.context = context;
    _authProvider = new AuthProvider();
    _driverProvider = new DriverProvider();
    _clientProvider = new ClientProvider();

    _progressDialog =
        MyProgressDialog.createProgressDialog(context, 'Iniciando sesión...');
    _sharedPref = new SharedPref();
    _typeUser = await _sharedPref.read('typeUser');

    print('++++++++++ Tipo de usuario ++++++++++');
    print(_typeUser);
  }

  void goToRegisterPage() {
    if (_typeUser == 'client') {
      Navigator.pushNamed(context, 'client/register');
    } else {
      Navigator.pushNamed(context, 'driver/register');
    }
  }

  void login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    print('Correo: $email');
    print('Contraseña: $password');
    _progressDialog.show();
    try {
      bool isLogin = await _authProvider.login(email, password);
      _progressDialog.hide();
      if (isLogin) {
        print('Eres un crack estas logeado');
        if (_typeUser == 'client') {
          Client client =
              await _clientProvider.getByID(_authProvider.getUser().uid);
              print('CLIENT: $client');
          if (client != null) {
            print('El cliente no es nulo');
            Navigator.pushNamedAndRemoveUntil(
                context, 'client/map', (route) => false);
          } else {
            print('El cliente si es nulo');
            utils.Snackbar.showSnackbar(context, key, 'El usuario no es valido');
            await AuthProvider().signOut();
          }
        } else if (_typeUser == 'driver') {
          Driver driver =
              await _driverProvider.getByID(_authProvider.getUser().uid);
              print('DRIVER: $driver');
          if (driver != null) {
            Navigator.pushNamedAndRemoveUntil(
                context, 'driver/map', (route) => false);
          } else {
            utils.Snackbar.showSnackbar(context, key, 'El usuario no es valido');
            await AuthProvider().signOut();
          }
        }
      } else {
        utils.Snackbar.showSnackbar(
            context, key, 'El usuario no se pudo autenticar');
        print('Estas bien pendejo no te pudiste logear');
        // _progressDialog.hide();
      }
    } catch (error) {
      utils.Snackbar.showSnackbar(context, key, 'Error: $error');
      _progressDialog.hide();
      print('Error: $error');
    }
  }
}
