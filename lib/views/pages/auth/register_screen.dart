import 'package:flutter/material.dart';
import 'package:tiktok_app_poly/database/services/auth_service.dart';
import 'package:tiktok_app_poly/views/pages/RULES/policy_creen.dart';
import 'package:tiktok_app_poly/views/pages/RULES/rules_screen.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool showPassword = false;
  bool showconfirmPassword = false;

  bool isValidEmail(String email) {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(email);
  }

  String? validateEmail(String value) {
    if (value.isEmpty) {
      return "Empty Field !";
    } else if (!isValidEmail(value)) {
      return "Wrong Email !";
    } else {
      return null;
    }
  }

  doRegister(BuildContext context) {
    if (validate()) {
      AuthService.registerFetch(
        context: context,
        email: emailController.text,
        password: passwordController.text,
        fullName: nameController.text,
        uid: '',
      );
    }
  }

  bool validate() {
    return nameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty &&
        passwordController.text == confirmPasswordController.text;
  }

  String? validatePassword(String value) {
    if (value.isEmpty) {
      return "Empty Field !";
    } else if (value.length <= 5) {
      return "Your password is too short !";
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                  backgroundColor: Colors.pink,
                ),
                child: const Text("Đăng Ký Ngay"),
              ),
            ),
            Container(
              margin:
                  EdgeInsets.only(top: 100, left: 20, right: 20, bottom: 20),
              child: Column(
                children: [
                  const Text(
                    'Bằng Cách nhấn Đăng Ký Ngay bạn đồng ý với',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  Container(
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RulesScreen()));

                              print('Hướng Trang điều khoản dịch vụ');
                            },
                            child: Text('Điều Khoản dịch vụ',
                                style: TextStyle(
                                    color:
                                        const Color.fromARGB(255, 16, 16, 16))),
                          ),
                          Text(
                            'và',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PolicyScreen()));
                            },
                            child: Text('Chính Sách Bảo Mật',
                                style: TextStyle(
                                    color: const Color.fromARGB(255, 0, 0, 0))),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
          Container(
            margin: EdgeInsets.symmetric(vertical: 20),
            child: const Text(
              'Sign up for TikTok',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            height: 50.0, // Điều chỉnh chiều cao của Container
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
                width: 0.5,
              ),
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: TextField(
              controller: nameController,
              decoration: const InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
                hintText: "Name",
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            height: 50.0, // Điều chỉnh chiều cao của Container
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
                width: 0.5,
              ),
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: TextField(
              controller: emailController,
              decoration: const InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
                hintText: "Email",
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            height: 50.0, // Điều chỉnh chiều cao của Container
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
                width: 0.5,
              ),
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: TextField(
              controller: passwordController,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
                hintText: "Password",
                border: InputBorder.none,
                suffixIcon: IconButton(
                  icon: Icon(
                    showPassword ? Icons.visibility : Icons.visibility_off,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    setState(() {
                      showPassword = !showPassword;
                    });
                  },
                ),
              ),
              obscureText: !showPassword,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            height: 50.0, // Điều chỉnh chiều cao của Container
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
                width: 0.5,
              ),
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: TextField(
              controller: confirmPasswordController,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
                hintText: "ConfirmPass",
                border: InputBorder.none,
                suffixIcon: IconButton(
                  icon: Icon(
                    showconfirmPassword
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    setState(() {
                      showconfirmPassword = !showconfirmPassword;
                    });
                  },
                ),
              ),
              obscureText: !showconfirmPassword,
            ),
          ),
        ],
      ),
    );
  }
}
