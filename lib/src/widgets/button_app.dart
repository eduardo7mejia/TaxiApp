import 'package:flutter/material.dart';
import 'package:uber_clonsito/src/utils/Colors.dart' as utils;

// ignore: must_be_immutable
class ButtonApp extends StatelessWidget {
  Color color;
  Color textColor;
  String text;
  IconData icon;

  Function onPressed;

  ButtonApp(
      {this.color = utils.Colors.PrincipalUber,
      this.textColor = utils.Colors.QuintoUber,
      this.icon = Icons.arrow_forward_ios,
      this.onPressed,
      @required this.text
      });

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return RaisedButton(
      onPressed: () {
        onPressed();
      },
      color: color,
      textColor: textColor,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
                height: 50,
                alignment: Alignment.center,
                child: Text(
                  text,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              height: 50,
              child: CircleAvatar(
                  radius: 20,
                  child: Icon(icon, color: utils.Colors.PrincipalUber),
                  backgroundColor: utils.Colors.QuintoUber),
            ),
          )
        ],
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
    );
  }
}
