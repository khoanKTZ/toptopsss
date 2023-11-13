import 'package:flutter/material.dart';
import 'package:tiktok_app_poly/database/services/auth_service.dart';

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
      AuthService.loginFetch(
        context: context,
        email: emailController.text,
        password: passwordController.text,
      );
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

  String? validatePassword() {
    if (passwordController.text.isEmpty) {
      return "Password is required!";
    }
    return null;
  }

  String? validate() {
    if (emailController.text.isEmpty) {
      return "Email is required!!";
    } else if (passwordController.text.isEmpty) {
      return "Password is required!";
    } else if (!isValidEmail(emailController.text)) {
      return "Invalid email format!";
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
          TextField(
            controller: emailController,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 15.0),
              hintText: "Email",
            ),
          ),
          if (emailErrorText != null)
            Text(
              emailErrorText!,
              style: TextStyle(color: Colors.red),
            ),
          const SizedBox(height: 20),
          TextField(
            controller: passwordController,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 15.0),
              hintText: "Password",
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
          if (passwordErrorText != null)
            Text(
              passwordErrorText!,
              style: TextStyle(color: Colors.red),
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
                  "Confirm",
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
