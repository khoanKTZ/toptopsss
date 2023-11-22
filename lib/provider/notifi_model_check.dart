import 'package:flutter/material.dart';

class NotifiCheck extends ChangeNotifier{

  bool isCheckNoti;
  bool isNoti;

  NotifiCheck({
    this.isCheckNoti = false,
    this.isNoti = false,
  });


  changerNotifiCheck(int a){
    if(a == 0){
      isCheckNoti = false;
    }else if(a==1){
      isCheckNoti = true;
    }
    notifyListeners();
  }

  changerNoti(bool check){
    isNoti = check;
    notifyListeners();
  }

}