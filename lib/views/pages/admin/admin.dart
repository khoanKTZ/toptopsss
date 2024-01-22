import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tiktok_app_poly/database/models/video_model.dart';
import 'package:tiktok_app_poly/database/services/auth_service.dart';
import 'package:tiktok_app_poly/provider/loading_model.dart';
import 'package:tiktok_app_poly/views/pages/admin/ql_Music/upLoadMusic_Screen.dart';
import 'package:tiktok_app_poly/views/pages/home/camera_page/add_video_screen.dart';
import 'package:tiktok_app_poly/views/widgets/colors.dart';

class admin extends StatefulWidget {
  const admin({Key? key}) : super(key: key);

  @override
  State<admin> createState() => _AdminState();
}

Stream<QuerySnapshot> getUserImage() async* {
  final currentUserID = FirebaseAuth.instance.currentUser?.uid;
  yield* FirebaseFirestore.instance
      .collection('music')
      .where('uID', isEqualTo: currentUserID)
      .snapshots();
}

showLogoutDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) => SimpleDialog(
      children: [
        const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Log out',
                style: TextStyle(
                    fontSize: 25, color: Color.fromARGB(255, 120, 196, 112)),
              ),
              Text(
                'Log out administrator account?',
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SimpleDialogOption(
              onPressed: () {
                AuthService.Logout(context: context);
              },
              child: const Row(
                children: [
                  Icon(
                    Icons.done,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                  Padding(
                    padding: EdgeInsets.all(7.0),
                    child: Text(
                      'Yes',
                      style: TextStyle(fontSize: 20, color: Colors.green),
                    ),
                  ),
                ],
              ),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.of(context).pop(),
              child: Row(
                children: const [
                  Icon(
                    Icons.cancel,
                    color: Colors.red,
                  ),
                  Padding(
                    padding: EdgeInsets.all(7.0),
                    child: Text(
                      'No',
                      style: TextStyle(
                          fontSize: 20, color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class _AdminState extends State<admin> {
  TextEditingController musicController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Center(
              child: Text(
            'administrator',
            style: TextStyle(
                fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
          )),
          // actions: [
          //   IconButton(
          //     icon: Icon(Icons.logout),
          //     onPressed: () => showLogoutDialog(context),
          //   ),
          // ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.grey[200],
                ),
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    "1. Quản lý người dùng",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.grey[200],
                ),
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    "2. Quản lý nội dung",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.grey[200],
                ),
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    "3. Quản lý bình luận",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.grey[200],
                ),
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    "4. Bảo mật vào phân quyền",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.grey[200],
                ),
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    "5. Quản lý dữ liệu",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.grey[200],
                ),
                child: TextButton(
                  onPressed: () async {
                    try {
                      String? filePath = await FilePicker.platform
                          .pickFiles(
                            type: FileType.audio,
                            allowCompression: true,
                          )
                          .then((value) => value?.files.single.path);

                      if (filePath != null) {
                        final file = File(filePath);
                        if (await file.exists()) {
                          print('Đường dẫn file âm thanh: $filePath');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  UploadMusicScreen(audioFilePath: filePath),
                            ),
                          );
                        } else {
                          print(
                              'File không tồn tại hoặc đường dẫn không hợp lệ.');
                        }
                      }
                    } catch (e) {
                      print('Lỗi khi lấy file âm thanh: $e');
                    }
                  },
                  child: const Text(
                    '6.Quản lý âm thanh',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.grey[200],
                ),
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    "7. Thống kê và báo cáo",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.grey[200],
                ),
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    "8. Tương tác với người dùng",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.grey[200],
                ),
                child: TextButton(
                  // onPressed: () => showLicensePage(context: context),
                  onPressed: () => showLogoutDialog(context),

                  child: const Text(
                    "Thoát",
                    style: TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(255, 255, 0, 0),
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
