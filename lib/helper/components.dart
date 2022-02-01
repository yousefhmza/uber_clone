import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

void showToast(String msg, {bool error = false}) async {
  await Fluttertoast.showToast(
    msg: msg,
    textColor: error ? Colors.white : Colors.black,
    backgroundColor: error ? Colors.red : Colors.grey.shade300,
  );
}
