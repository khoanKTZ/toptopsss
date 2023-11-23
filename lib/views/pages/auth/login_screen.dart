import 'package:flutter/material.dart';
import 'package:tiktok_app_poly/database/services/auth_service.dart';
import 'package:tiktok_app_poly/views/pages/auth/forgot_password.dart';
import 'package:tiktok_app_poly/views/pages/admin/admin.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _loginFormKey = GlobalKey<FormState>();
  bool showPassword = false;
  String? emailErrorText;
  String? passwordErrorText;

  bool isValidEmail(String email) {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(email);
  }

  doLogin(BuildContext context) {
    setState(() {
      emailErrorText = validateEmail();
      passwordErrorText = validatePassword();
    });

    if (emailErrorText == null && passwordErrorText == null) {
      String enteredEmail = emailController.text;
      String enteredPassword = passwordController.text;

      if (enteredEmail == "admynkhoan@gmail.com" &&
          enteredPassword == "Khoan292003") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const admin()),
        );
      } else {
        AuthService.loginFetch(
          context: context,
          email: enteredEmail,
          password: enteredPassword,
        );
      }
    }
  }

  String? validateEmail() {
    if (emailController.text.isEmpty) {
      return "Email is required!!";
    } else if (!isValidEmail(emailController.text)) {
      return "Invalid email format!";
    }
    return null; // Trả về null nếu không có lỗi
  }

  String? validatePassword() {
    if (passwordController.text.isEmpty) {
      return "Password is required!";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login with email',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(child: body(context)),
    );
  }

  Widget body(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black, // Màu đường viền
                width: 0.5, // Độ dày của đường viền
              ),
              borderRadius: BorderRadius.circular(15.0), // Độ cong của góc
            ),
            child: TextField(
              controller: emailController,
              decoration: const InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
                hintText: "Email",
                border: InputBorder
                    .none, // Để loại bỏ đường viền mặc định của TextField
              ),
            ),
          ),
          if (emailErrorText != null)
            Text(
              emailErrorText!,
              style: TextStyle(color: Colors.red),
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
          if (passwordErrorText != null)
            Text(
              passwordErrorText!,
              style: TextStyle(color: Colors.red),
            ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Container(
                child: TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const ForgotPasswordScreen()));
                    },
                    child: Text(
                      'Forgot your password?',
                      style: TextStyle(
                          color: const Color.fromARGB(255, 19, 19, 19)),
                    )),
              ),
            ],
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 15),
            child: ElevatedButton(
              onPressed: () {
                doLogin(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
              ),
              child: const Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
