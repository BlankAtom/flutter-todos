import 'package:flutter/material.dart';

class FullScreenDialog {
  static FullScreenDialog _instance = FullScreenDialog._internal();

  factory FullScreenDialog() {
    return _instance;
  }

  FullScreenDialog._internal();

  static FullScreenDialog getInstance() {
    if (_instance == null) {
      _instance = FullScreenDialog._internal();
    }
    return _instance;
  }

  void showDialog(BuildContext context, Widget child) {
    Navigator.of(context).push(PageRouteBuilder(
        opaque: false,
        pageBuilder: (ctx, anm1, anm2) {
          return child;
        }));
  }
}
