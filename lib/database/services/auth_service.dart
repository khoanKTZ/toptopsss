import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tiktok_app_poly/database/services/user_service.dart';
import 'package:tiktok_app_poly/views/pages/auth/auth_screen.dart';
import 'package:tiktok_app_poly/views/pages/auth/login_screen.dart';
import 'package:tiktok_app_poly/views/widgets/snackbar.dart';

import '../../views/pages/home/home_screen.dart';

class AuthService {
  FirebaseAuth auth = FirebaseAuth.instance;

  static loginFetch(
      {required BuildContext context,
      required email,
      required password}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      final storage = FlutterSecureStorage();
      String? uID = userCredential.user?.uid.toString();
      await storage.write(key: 'uID', value: uID);
      // String? value = await storage.read(key: 'uID');
      FocusScope.of(context).unfocus();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
          (route) => false);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        getSnackBar(
          'Login',
          'No user found for that email.',
          Colors.red,
        ).show(context);
        //print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print(e.code);

        getSnackBar(
                'Login', 'Wrong password provided for that user.', Colors.red)
            .show(context);
        //print('Wrong password provided for that user.');
      }
    }
  }

  static Logout({required BuildContext context}) async {
    try {
      FirebaseAuth.instance.signOut();
      final storage = FlutterSecureStorage();
      await storage.deleteAll();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginAll()),
        (route) => false,
      );
      getSnackBar(
        'Logout',
        'Logout Success.',
        Colors.green,
      ).show(context);
    } catch (e) {}
  }

  static registerFetch(
      {required BuildContext context,
      required email,
      required password,
      required fullName,
      required uid}) async {
    try {
      // if (email == null || password == null) {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await UserService.addUser(
          UID: userCredential.user?.uid, fullName: fullName, email: email);
      // } else {
      //   await UserService.addUser(UID: uid, fullName: fullName, email: email);
      // }
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false,
      );
      getSnackBar(
        'Register',
        'Register Success.',
        Colors.green,
      ).show(context);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        //print('The password provided is too weak.');
        getSnackBar(
          'Register',
          'The password provided is too weak.',
          Colors.red,
        ).show(context);
      } else if (e.code == 'email-already-in-use') {
        getSnackBar(
          'Register',
          'The account already exists for that email.',
          Colors.red,
        ).show(context);
        //print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }
}
