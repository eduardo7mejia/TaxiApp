import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:uber_clonsito/src/models/client.dart';
import 'package:uber_clonsito/src/providers/auth_provider.dart';
import 'package:uber_clonsito/src/providers/client_provider.dart';
import 'package:uber_clonsito/src/utils/my_progress_dialog.dart';
import 'package:uber_clonsito/src/utils/snackbar.dart' as utils;


class ClientRegisterController {
  BuildContext context;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();

  TextEditingController userController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController confirmPasswordController = new TextEditingController();

  AuthProvider _authProvider;
  ClientProvider _clientProvider;
  ProgressDialog _progressDialog;

  // ignore: missing_return
  Future init(BuildContext context) {
    this.context = context;
    _authProvider = new AuthProvider();
    _clientProvider = new ClientProvider();
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
        Client client = new Client(
          id: _authProvider.getUser().uid,
          email: _authProvider.getUser().email,
          username: username,
          password: password
        );
        await _clientProvider.create(client);
        _progressDialog.hide();
        Navigator.pushNamedAndRemoveUntil(context, 'client/map', (route) => false);
        
        print('Eres un crack te haz registrado correctamente');
        utils.Snackbar.showSnackbar(context, key, 'Eres un crack te haz registrado correctamente');
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
