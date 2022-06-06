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




  String isOnline = "0";
  String get getisOnline => isOnline;

  void setisOnline(var value) async {
    isOnline = value;

    notifyListeners();
  }


  String isCurrent = "0";
  String get getisCurrent => isCurrent;

  void setisCurrent(var value) async {
    isCurrent = value;

    notifyListeners();
  }


  String isHablamos = "0";
  String get getisHablamos => isHablamos;

  void setisHablamos(var value) async {
    isHablamos = value;

    notifyListeners();
  }


  String isReligious = "0";
  String get getisReligious => isReligious;

  void setisReligious(var value) async {
    isReligious = value;

    notifyListeners();
  }

}
