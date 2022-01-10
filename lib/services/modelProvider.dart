import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class Counter with ChangeNotifier {
  String countt = "";
  String get count => countt;

  void getNotify() async {
    countt = currentPath;

    notifyListeners();
  }

}
