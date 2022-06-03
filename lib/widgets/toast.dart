import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void toast(String msg) {
  Fluttertoast.showToast(
    backgroundColor: Colors.red,
    fontSize: 16.0,
    gravity: ToastGravity.BOTTOM,
    msg: msg,
    textColor: Colors.white,
    timeInSecForIosWeb: 1,
    toastLength: Toast.LENGTH_LONG,
  );
}
