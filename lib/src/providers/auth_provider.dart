import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthProvider {
  FirebaseAuth _firebaseAuth;
  AuthProvider() {
    _firebaseAuth = FirebaseAuth.instance;
  }

  User getUser(){
    return _firebaseAuth.currentUser;
  }
  bool isSignedIn(){
    final currentUser =  _firebaseAuth.currentUser;
    if(currentUser == null){
      return false;
    }
    return true;
  }
  //Verificar si el usuarip esta logeado
  void checkIfUserLogged(BuildContext context, String typeUser){
    FirebaseAuth.instance.authStateChanges().listen((User user) { 
      //Que el usario este logeado
      if (user != null && typeUser != null){
        if (typeUser == 'client') {
          Navigator.pushNamedAndRemoveUntil(context, 'client/map', (route) => false);
        } else {
          Navigator.pushNamedAndRemoveUntil(context, 'driver/map', (route) => false);
        }
        print('El usuario esta logeado');      
      } else{
        print('El usuario no esta logeado');
      }
    });
  }
  //Logearnos con Firebase
  Future<bool> login(String email, String password)async{
  String errorMessage;
  try{
    await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  }catch(error){
    print(error);
    //Correo o password incorecto, no hay conexión a internet
    errorMessage = error.code;
    }
    if (errorMessage!=null) {
      return Future.error(errorMessage);
    }
    return true;
  }
  //Registrarnos con Firebase
  Future<bool> register(String email, String password)async{
  String errorMessage;
  try{
    await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
  }catch(error){
    print(error);
    //Correo o password incorecto, no hay conexión a internet
    errorMessage = error.code;
    }
    if (errorMessage!=null) {
      return Future.error(errorMessage);
    }
    return true;
  }
  Future<void> signOut()async{
    return Future.wait([_firebaseAuth.signOut()]);
  }
}
