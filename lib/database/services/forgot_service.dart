// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tiktok_app_poly/views/pages/home/user_page/update_password_screen.dart';
import 'package:tiktok_app_poly/views/widgets/snackbar.dart';

class ForgotService {
  static Future<void> forgotEmail(
      {required BuildContext context, required String email}) async {
    try {
      // Kiểm tra xem email đã được đăng ký chưa
      bool isEmailExists = await isEmailRegistered(email);

      if (isEmailExists) {
        // Nếu email tồn tại, thực hiện đăng nhập
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: "");

        final storage = FlutterSecureStorage();
        String? uID = userCredential.user?.uid.toString();
        await storage.write(key: 'uID', value: uID);

        FocusScope.of(context).unfocus();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => UpdatePasswordScreen()),
            (route) => false);
      } else {
        getSnackBar(
          'Login',
          'Email không tồn tại',
          Colors.red,
        ).show(context);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        print(e.code);
        getSnackBar(
          'Login',
          'Wrong password provided for that user.',
          Colors.red,
        ).show(context);
      }
    }
  }

  static Future<bool> isEmailRegistered(String email) async {
    try {
      // Sử dụng hàm fetchSignInMethodsForEmail để kiểm tra xem email đã được đăng ký chưa
      List<String> signInMethods =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      return signInMethods.isNotEmpty;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        // Nếu không tìm thấy người dùng, email chưa đăng ký
        return false;
      } else {
        // Xử lý các trường hợp lỗi khác
        throw e;
      }
    }
  }
}
