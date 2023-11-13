import 'package:flutter/material.dart';

import '../../../../database/services/user_service.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/text.dart';

// ignore: must_be_immutable
class UpdatePasswordScreen extends StatelessWidget {
  UpdatePasswordScreen({Key? key}) : super(key: key);

  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final _updatePasswordFormKey = GlobalKey<FormState>();

  doEdit(BuildContext context) {
    bool isValidate = _updatePasswordFormKey.currentState!.validate();
    if (isValidate) {
      UserService.changPassword(
          context: context, newPassword: newPassword.text);
    }
  }

  String? validatePassword(String value) {
    if (value == '') {
      return "Empty Field !";
    } else if (value.length < 6) {
      return "Your password is too short !";
    }
    return null;
  }

  String? validateConfirmPassword(String value) {
    if (value == '') {
      return "Empty Field !";
    } else if (value != newPassword.text) {
      return "Your confirmation password does not match !";
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  Positioned(
                    top: MediaQuery.of(context).size.height / 10,
                    left: MediaQuery.of(context).size.width / 5,
                    child: Center(
                      child: CustomText(
                        text: 'Update Password',
                        fontsize: 30,
                        color: Colors.black,
                        fontFamily: 'DancingScript',
                      ),
                    ),
                  ),
                  Positioned(
                    top: 20,
                    right: 0,
                    child: IconButton(
                      iconSize: 20,
                      icon: const Icon(
                        Icons.backspace,
                        color: Color.fromARGB(255, 255, 0, 0),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height / 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 4 / 6,
                        width: MediaQuery.of(context).size.width - 32,
                        child: Form(
                          key: _updatePasswordFormKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 10),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black, // Màu đường viền
                                    width: 0.5, // Độ dày của đường viền
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      15.0), // Độ cong của góc
                                ),
                                child: TextField(
                                  controller: newPassword,
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 15.0, horizontal: 10),
                                    hintText: "New Password",
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 0.5,
                                  ),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: TextField(
                                  controller: confirmPasswordController,
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 15.0, horizontal: 10),
                                    hintText: "Confirm Password",
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              CustomButton(
                                onPress: () {
                                  doEdit(context);
                                },
                                text: 'Save',
                                color: Colors.pink,
                              ),
                            ],
                          ),
                        ),
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
}
