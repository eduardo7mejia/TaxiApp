import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:uber_clonsito/src/models/driver.dart';
import 'package:uber_clonsito/src/providers/auth_provider.dart';
import 'package:uber_clonsito/src/providers/driver_provider.dart';
import 'package:uber_clonsito/src/utils/my_progress_dialog.dart';
import 'package:uber_clonsito/src/utils/snackbar.dart' as utils;


class DriverRegisterController {
  BuildContext context;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();

  TextEditingController userController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController confirmPasswordController = new TextEditingController();
  TextEditingController pin1Controller = new TextEditingController();
  TextEditingController pin2Controller = new TextEditingController();
  TextEditingController pin3Controller = new TextEditingController();
  TextEditingController pin4Controller = new TextEditingController();
  TextEditingController pin5Controller = new TextEditingController();
  TextEditingController pin6Controller = new TextEditingController();
  TextEditingController pin7Controller = new TextEditingController();
  

  AuthProvider _authProvider;
  DriverProvider _driverProvider;
  ProgressDialog _progressDialog;

  // ignore: missing_return
  Future init(BuildContext context) {
    this.context = context;
    _authProvider = new AuthProvider();
    _driverProvider = new DriverProvider();
    _progressDialog = MyProgressDialog.createProgressDialog(context, 'Registrando, espere un momento...');
  }

  void goToLoginPage() {
    Navigator.pushNamed(context, 'login');
  }

  void register() async {
    String username = userController.text;
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();
    String pin1 = pin1Controller.text.trim();
    String pin2 = pin2Controller.text.trim();
    String pin3 = pin3Controller.text.trim();
    String pin4 = pin4Controller.text.trim();
    String pin5 = pin5Controller.text.trim();
    String pin6 = pin6Controller.text.trim();
    String pin7 = pin7Controller.text.trim();

    String plate = '$pin1$pin2$pin3-$pin4$pin5$pin6$pin7';


    print('Usuario: $username');
    print('Correo: $email');
    print('Contraseña: $password');
    print('Confirmar contraseña: $confirmPassword');

    if (username.isEmpty &&
        email.isEmpty &&
        password.isEmpty &&
        confirmPassword.isEmpty) {
      print('Debes de ingresar todos los campos vale verga');
      utils.Snackbar.showSnackbar(context, key, 'Debes de ingresar todos los campos tarado');
      return;
    }
    if (confirmPassword != password) {
      print('Las contraseñas no coinciden');
      utils.Snackbar.showSnackbar(context, key, 'Las contraseñas no coinciden');
    }
    if (password.length < 6) {
      print('La contraseña debe tener al menos 6 caracteres');
      utils.Snackbar.showSnackbar(context, key, 'La contraseña debe tener al menos 6 caracteres');
    }
    _progressDialog.show();

    try {
      bool isRegister = await _authProvider.register(email, password);
      if (isRegister) {
        Driver driver = new Driver(
          id: _authProvider.getUser().uid,
          email: _authProvider.getUser().email,
          username: username,
          password: password,
          plate: plate
        );
        await _driverProvider.create(driver);
        _progressDialog.hide();
        Navigator.pushNamedAndRemoveUntil(context, 'driver/map', (route) => false);

        utils.Snackbar.showSnackbar(context, key, 'Eres un crack te haz registrado correctamente');
        print('Eres un crack te haz registrado correctamente');
      } else {
        _progressDialog.hide();
        print('Estas bien pendejo no te pudiste registrar');
      }
    } catch (error) {
      _progressDialog.hide();
      print('Error: $error');
      utils.Snackbar.showSnackbar(context, key, 'Error: $error');
    }
  }
}
