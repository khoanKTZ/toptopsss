import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class LoginFacebookService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserCredential?> signInWithFacebook(BuildContext context) async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();

      if (loginResult.status == LoginStatus.success) {
        final AuthCredential credential =
            FacebookAuthProvider.credential(loginResult.accessToken!.token);
        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);

        if (userCredential.user != null) {
          // Lấy thông tin người dùng từ Firestore
          // ignore: unused_local_variable
          DocumentSnapshot userSnapshot = await _firestore
              .collection('users')
              .doc(userCredential.user!.uid)
              .get();

          // Người dùng mới đăng nhập hoặc thông tin người dùng đã tồn tại, lưu thông tin vào Firestore
          await _firestore
              .collection('users')
              .doc(userCredential.user!.uid)
              .set({
            'uID': userCredential.user!.uid,
            'fullName': userCredential.user!.displayName ?? '',
            'email': userCredential.user!.email ?? '',
            'avartaURL': userCredential.user!.photoURL,
            'follower': [],
            'following': [],
            'age': '',
            'gender': '',
            'phone': '',
            // Thêm các trường khác nếu cần
          });

          return userCredential;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      print("Error signing in with Facebook: $e");
      return null;
    }
  }
}
