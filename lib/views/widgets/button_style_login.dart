import 'package:flutter/material.dart';
import 'package:tiktok_app_poly/views/pages/auth/login_phone_screen.dart';
import 'package:tiktok_app_poly/views/pages/auth/login_screen.dart';

// ignore: must_be_immutable
class BottomStyleLogin extends StatelessWidget {
  BottomStyleLogin(
      {Key? key,
      required this.nameButton,
      required this.checkButton,
      required this.icons})
      : super(key: key);
  String nameButton;
  bool checkButton;
  String icons;

  void checkcode(BuildContext context) {
    if (checkButton == false) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ứng dụng đang được phát triển.')));
    } else {
      if (nameButton == "User email/ username") {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Đã nhấp.')));
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
      }

      if (nameButton == "User Login phone") {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Đã nhấp.')));
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => LoginWithPhoneNumber()));
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
              'assets/icons/$icons',
              width: 25,
              height: 25,
            ),
            Expanded(
              child: Text(
                nameButton,
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
