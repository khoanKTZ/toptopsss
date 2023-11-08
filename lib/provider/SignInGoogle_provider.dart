import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tiktok_app_poly/database/services/SignInGoogle_service.dart';

class SignInGooogleProvider extends ChangeNotifier {
  final SignInGooogleService _signInGooogleService = SignInGooogleService();
  User? _user;

  User? get user => _user;

  Future<void> signInWithGoogle() async {
    _user = await _signInGooogleService.signInWithGoogle();
    notifyListeners();
  }

  // Future<void> signOut() async {
  //   await _signInGooogleService.signOut();
  //   _user = null;
  //   notifyListeners();
  // }
}
