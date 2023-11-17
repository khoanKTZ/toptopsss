import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tiktok_app_poly/database/services/forgot_service.dart';
import 'package:tiktok_app_poly/views/pages/auth/login_screen.dart';
import 'package:tiktok_app_poly/views/widgets/snackbar.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController emailController = TextEditingController();
  String? emailErrorText;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  bool isValidEmail(String email) {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(email);
  }

  Fogot(BuildContext context) {
    setState(() {
      emailErrorText = validateEmail();
    });

    if (emailErrorText == null) {
      ForgotService.forgotEmail(context: context, email: emailController.text);
    }
  }

  Future<void> resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text.trim(),
      );

      getSnackBar(
        'Forgot',
        'Password Reset Email sent',
        Colors.red,
      ).show(context);
      // Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    } on FirebaseAuthException catch (e) {
      print(e);
      // ignore: use_build_context_synchronously
      getSnackBar(
        'Error',
        e.message ?? 'Error occurred',
        Colors.red,
      ).show(context);
      Navigator.of(context).pop();
    }
  }

  String? validateEmail() {
    if (emailController.text.isEmpty) {
      return "Email is required!!";
    } else if (!isValidEmail(emailController.text)) {
      return "Invalid email format!";
    }
    return null;
  }

  bool emailRadioValue = false;
  bool phoneRadioValue = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          const Center(
            child: const Text(
              'Thay đổi mật khẩu',
              style: TextStyle(fontSize: 30, color: Colors.black),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            height: 100,
            width: 330,
            child: Row(
              children: [
                // Radio(
                //   value: emailRadioValue,
                //   groupValue: true,
                //   onChanged: (bool? newValue) {
                //     setState(() {
                //       emailRadioValue = true;
                //       phoneRadioValue = false;
                //     });
                //   },
                // ),
                Expanded(
                  child: Container(
                    height: 50,
                    padding:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Center(
                      child: TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10),
                          hintText: "Your Email",
                          border: InputBorder
                              .none, // Để loại bỏ đường viền mặc định của TextField
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (emailErrorText != null)
            Text(
              emailErrorText!,
              style: TextStyle(color: Colors.red),
            ),
          TextButton(
            onPressed: () {
              resetPassword();
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text(
              'Gửi mã xác thực',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 10,
              left: 1,
              right: 1,
            ),
            child: Container(
              margin:
                  EdgeInsets.only(top: 200, left: 20, right: 20, bottom: 20),
              child: Container(
                child: Column(
                  children: [
                    const Text(
                      'Copyright ©KhoanUBU Online. Trademarks belong to their respective ',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    const Center(
                      child: const Text(
                        'owners. All rights reserved.',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ),
                    Container(
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {},
                              child: Text('Điều Khoản Sử Dụng    |',
                                  style: TextStyle(
                                      color: const Color.fromARGB(
                                          255, 16, 16, 16))),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text('Chính Sách Riêng Tư',
                                  style: TextStyle(
                                      color:
                                          const Color.fromARGB(255, 0, 0, 0))),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
