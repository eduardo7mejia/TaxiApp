import 'package:flutter/material.dart';
import 'package:uber_clonsito/src/utils/Colors.dart' as utils;

class Snackbar {
  static void showSnackbar(
      BuildContext context, GlobalKey<ScaffoldState> key, String text) {
    if (context == null) return;
    if (key == null) return;
    if (key.currentState == null) return;

    FocusScope.of(context).requestFocus(new FocusNode());

    // ignore: deprecated_member_use
    key.currentState?.removeCurrentSnackBar();
    // ignore: deprecated_member_use
    key.currentState.showSnackBar(new SnackBar(
        content: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(color: utils.Colors.QuintoUber, fontSize: 14),
        ),
        backgroundColor: utils.Colors.PrincipalUber,
        duration: Duration(seconds: 4)));
  }
}
