import 'package:flutter/material.dart';
import 'package:tiktok_app_poly/database/services/LoginFacebook_service.dart';
import 'package:tiktok_app_poly/provider/SignInGoogle_provider.dart';
import 'package:tiktok_app_poly/views/pages/auth/login_phone_screen.dart';
import 'package:tiktok_app_poly/views/pages/auth/login_screen.dart';
import 'package:tiktok_app_poly/views/pages/home/home_screen.dart';

class BottomStyleLogin extends StatefulWidget {
  final String nameButton;
  final bool checkButton;
  final String icons;

  BottomStyleLogin({
    Key? key,
    required this.nameButton,
    required this.checkButton,
    required this.icons,
  }) : super(key: key);

  @override
  _BottomStyleLoginState createState() => _BottomStyleLoginState();
}

class _BottomStyleLoginState extends State<BottomStyleLogin> {
  final SignInGooogleProvider signInGoogleProvider = SignInGooogleProvider();

  Future<void> _signInWithGoogle(BuildContext context) async {
    await signInGoogleProvider.signInWithGoogle();

    if (signInGoogleProvider.user != null && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {}
  }

  Future<void> _signInWithFacebook(BuildContext context) async {
    final authService = LoginFacebookService();
    final userCredential = await authService.signInWithFacebook(context);

    if (userCredential != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      // Xử lý khi đăng nhập thất bại
    }
  }

  void checkcode(BuildContext context) {
    if (widget.checkButton == false) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Chức năng đang được phát triển.')));
    } else {
      if (widget.nameButton == "User email/ username") {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Đã chọn.')));
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
      }

      if (widget.nameButton == "User Login phone") {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Đã nhấp.')));
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => LoginWithPhoneNumber()));
      }

      if (widget.nameButton == "Continue with Google") {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Đã nhấp.')));
        _signInWithGoogle(context);
      }

      if (widget.nameButton == "Continue with Facebook") {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Đã nhấp.')));
        _signInWithFacebook(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(13)),
        color: Colors.white,
      ),
      width: MediaQuery.of(context).size.width - 50,
      child: TextButton(
        onPressed: () => checkcode(context),
        child: Row(
          children: [
            Image.asset(
              'assets/icons/${widget.icons}',
              width: 25,
              height: 25,
            ),
            Expanded(
              child: Text(
                widget.nameButton,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
