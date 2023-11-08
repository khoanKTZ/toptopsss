import 'package:flutter/material.dart';

class Cmodel extends ChangeNotifier {
  bool isShowCM;
  bool isShowRepCM;
  bool isCountCM,isRepCM,isSend;


  Cmodel({this.isShowCM = false,
    this.isCountCM = false,
    this.isRepCM = false,
    this.isSend = false,
  this.isShowRepCM = false});

  changeShowRepCM(){
    isShowRepCM = !isShowRepCM;
    notifyListeners();
  }

  double height(double a){
    return a * 100;
  }

  checkComment(String a){
    if(a == 'rep'){
      isRepCM = true;
    }
    else{
      isRepCM = false;
    }
    if(a== "send"){
      isSend = true;
    }else{
      isSend = false;
    }
  }

}
