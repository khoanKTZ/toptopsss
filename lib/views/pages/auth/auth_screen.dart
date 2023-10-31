import 'package:flutter/material.dart';
import 'package:tiktok_app_poly/views/pages/auth/register_screen.dart';
import 'package:tiktok_app_poly/views/widgets/button_style_login.dart';

class LoginAll extends StatefulWidget {
  const LoginAll({super.key});

  @override
  State<LoginAll> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginAll> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: null,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Log in to TikTok',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                      'Manage your account, check notification, \n        commenton video, end more'),
                  const SizedBox(
                    height: 10,
                  ),
                  BottomStyleLogin(
                      nameButton: "Continue with Apple ",
                      checkButton: false,
                      icons: "apples.png"),
                  const SizedBox(
                    height: 10,
                  ),
                  BottomStyleLogin(
                      nameButton: "User email/ username",
                      checkButton: true,
                      icons: "user.png"),
                  BottomStyleLogin(
                      nameButton: "User Login phone",
                      checkButton: true,
                      icons: "phone.png"),
                  const SizedBox(
                    height: 10,
                  ),
                  BottomStyleLogin(
                      nameButton: "Continue with Facebook",
                      checkButton: true,
                      icons: "facebooks.png"),
                  const SizedBox(
                    height: 10,
                  ),
                  BottomStyleLogin(
                      nameButton: "Continue with Google",
                      checkButton: true,
                      icons: "googles.jpg"),
                  const SizedBox(
                    height: 10,
                  ),
                  BottomStyleLogin(
                      nameButton: "Continue with Whatsapp",
                      checkButton: false,
                      icons: "whatsapps.png"),
                  const SizedBox(
                    height: 10,
                  ),
                  BottomStyleLogin(
                      nameButton: "Continue with Line",
                      checkButton: false,
                      icons: "line.png"),
                  const SizedBox(
                    height: 10,
                  ),
                  BottomStyleLogin(
                      nameButton: "Continue with Instagram",
                      checkButton: false,
                      icons: "instagram.png"),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "           By continuing, you agree to TikTok\n Terms of Use and acknowledge that you have read\n          and understood TikTok's Privacy Policy.",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Don't have an account ?",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterScreen()),
                          );
                        },
                        child: const Text(
                          "Sign up",
                          style: TextStyle(
                              color: Color.fromARGB(255, 252, 13, 200)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
    );
  }
}
