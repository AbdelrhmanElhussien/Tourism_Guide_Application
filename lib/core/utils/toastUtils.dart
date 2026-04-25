
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class toastutils {
  static Future<bool?> flutterToast({
    required String msg,
    required Color BackgroundColor,
    required Color textColor,
  }) {
    return Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: BackgroundColor,
      textColor: textColor,
      fontSize: 16.0,
    );
  }
}
