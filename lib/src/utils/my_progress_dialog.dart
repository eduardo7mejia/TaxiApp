import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:uber_clonsito/src/utils/Colors.dart' as utils;

class MyProgressDialog {
  static ProgressDialog createProgressDialog(
      BuildContext context, String text) {
    ProgressDialog progressDialog = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    progressDialog.style(
        message: text,
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(
           valueColor:AlwaysStoppedAnimation<Color>(Colors.indigo),
        ),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: utils.Colors.PrincipalUber, fontSize: 10.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: utils.Colors.PrincipalUber, fontSize: 15.0, fontWeight: FontWeight.w600));
    return progressDialog;
  }
}
