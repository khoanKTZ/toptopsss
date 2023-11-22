import 'package:flutter/material.dart';

class NotifiCheck extends ChangeNotifier{

  bool isCheckNoti;

  NotifiCheck({this.isCheckNoti = false});

  changerNotifiCheck(int a){
    if(a == 0){
      isCheckNoti = false;
    }else if(a==1){
      isCheckNoti = true;
    }
    notifyListeners();
  }


}