import 'package:flutter/material.dart';

class RepCmodel extends ChangeNotifier {
  bool isShowCM;
  RepCmodel(this.isShowCM);

  changeShow(){
    if(isShowCM == false){
      isShowCM = true;
    }else{
      isShowCM = false;
    }
    notifyListeners();
  }
}
