import 'package:flutter/material.dart';
import 'package:tiktok_app_poly/views/pages/home/home_screen.dart';
import 'package:tiktok_app_poly/views/widgets/snackbar.dart';

// ignore: must_be_immutable
class RegisterPhoneScreen extends StatelessWidget {
  String? uid;
  RegisterPhoneScreen({Key? key, this.uid}) : super(key: key);
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final _registerFormKey = GlobalKey<FormState>();

  doRegister(BuildContext context) {
    // if (validate()) {
    //   context:
    //   context;
    //   email:
    //   '';
    //   password:
    //   '';

    //   fullName:
    //   nameController.text;
    //   uid:
    //   uid;
    // }
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomeScreen()));
    getSnackBar(
        'Login', 'Login Thành công', const Color.fromARGB(255, 254, 4, 4));
    print('Đã nhấp xxxxxx');
  }

  bool validate() {
    if (nameController.text.isNotEmpty) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Enter your name"),
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.west,
            color: Colors.grey,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            info(),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: () {
                  doRegister(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                ),
                child: const Text("Confirm"),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget info() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 15.0),
              hintText: "Full name",
            ),
          ),
        ],
      ),
    );
  }
}
