import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tiktok_app_poly/views/pages/home/user_page/EditProfile.dart';

import '../../views/widgets/snackbar.dart';

class UserService {
  //Get userInfo from firestore cloud
  static Future getUserInfo() async {
    final CollectionReference users =
        FirebaseFirestore.instance.collection('users');
    const storage = FlutterSecureStorage();
    String? UID = await storage.read(key: 'uID');
    final result = await users.doc(UID).get();
    return result;
  }

  static Stream getPeopleInfo(String peopleID) {
    final CollectionReference users =
        FirebaseFirestore.instance.collection('users');
    final result = users.doc(peopleID).snapshots();
    return result;
  }

  //Add user to firestore cloud after registering
  static addUser({
    required String? UID,
    required String fullName,
    required String email,
  }) {
    // Call the user's CollectionReference to add a new user
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');
      users
          .doc(UID)
          .set({
            'uID': UID,
            'fullName': fullName,
            'email': email,
            'following': [],
            'follower': [],
            'avartaURL': '',
            'phone': '',
            'age': '',
            'gender': '',
          })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    } catch (e) {}
  }

  static editUserFetch({
    required BuildContext context,
    required String collums,
    required String values,
  }) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');
      final storage = FlutterSecureStorage();
      String? UID = await storage.read(key: 'uID');
      users
          .doc(UID)
          .update({
            collums: values,
          })
          .then((value) => print("User Updated"))
          .catchError((error) => print("Failed to update user: $error"));
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => EditProifilePage()),
          (router) => true);
      getSnackBar(
        'Edit $collums',
        'Edit Success.',
        Colors.green,
      ).show(context);
    } catch (e) {
      getSnackBar(
        'Edit $collums',
        'Edit Fail. $e',
        Colors.red,
      ).show(context);
      print(e);
    }
  }

  //Edit user's Image
  static editUserImage(
      {required BuildContext context, required ImageStorageLink}) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');
      final storage = FlutterSecureStorage();
      String? UID = await storage.read(key: 'uID');
      users
          .doc(UID)
          .update({
            'avartaURL': ImageStorageLink,
          })
          .then((value) => print("User's Image Updated"))
          .catchError((error) => print("Failed to update user: $error"));
      return false;
    } catch (e) {
      getSnackBar(
        'Edit Image',
        'Edit Fail. $e',
        Colors.red,
      ).show(context);
    }
  }

  static changPassword({required BuildContext context, required newPassword}) {
    try {
      FirebaseAuth.instance.currentUser?.updatePassword(newPassword);
      Navigator.of(context).pop();
      getSnackBar(
        'Update Password',
        'Success.',
        Colors.green,
      ).show(context);
    } catch (e) {
      getSnackBar(
        'Update Password',
        'Fail. $e',
        Colors.red,
      ).show(context);
    }
  }

  static Future<void> follow(String uid) async {
    String currentUid = FirebaseAuth.instance.currentUser!.uid;
    print("$currentUid++++$uid");

    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUid)
        .get();
    if ((doc.data()! as dynamic)['following'].contains(uid)) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUid)
          .update({
        'following': FieldValue.arrayRemove([uid]),
      });
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'follower': FieldValue.arrayRemove([currentUid]),
      });
    } else {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUid)
          .update({
        'following': FieldValue.arrayUnion([uid]),
      });

      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'follower': FieldValue.arrayUnion([currentUid]),
      });
    }
  }
}
