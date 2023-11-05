import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

String? uid = FirebaseAuth.instance.currentUser?.uid;
CollectionReference videos = FirebaseFirestore.instance.collection('videos');
final CollectionReference users =
    FirebaseFirestore.instance.collection('users');

void _showBottomSheetoooo(BuildContext context, String videoID) {
  TextEditingController _textEditingController = TextEditingController();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // Đảm bảo BottomSheet mở rộng tới đáy màn hình
    builder: (BuildContext context) {
      return Container(
        padding: EdgeInsets.all(16),
        height: MediaQuery.of(context).size.height *
            0.33, // Chiều cao khoảng 1/3 màn hình
        child: Column(
          children: [
            TextField(
              controller: _textEditingController,
              decoration: InputDecoration(
                hintText: 'Nhập nội dung',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                String comment = _textEditingController.text;
                // Gọi hàm gửi bình luận ở đây
                sendCommentList(comment, videoID, "");
                _textEditingController.clear(); // Xóa nội dung trong ô nhập
              },
              child: Icon(Icons.send),
            ),
          ],
        ),
      );
    },
  );
}

Future<void> sendCommentList(
    String message, String videoID, String idComment) async {
  if (message == '') return;
  final result = await users.doc(uid).get();
  final String avatarURL = result.get('avartaURL');
  final String userName = result.get('fullName');
  var allDocs = await FirebaseFirestore.instance
      .collection('videos')
      .doc(videoID)
      .collection('commentList')
      .get();
  int len = allDocs.docs.length;

  await FirebaseFirestore.instance
      .collection('videos')
      .doc(videoID)
      .collection('commentList')
      .doc('Comment $len')
      .collection('repcomment')
      .add({
        'createdOn': FieldValue.serverTimestamp(),
        'uID': uid,
        'content': message,
        'avatarURL': avatarURL,
        'userName': userName,
        'id': 'Comment $len',
        'likes': []
      })
      .then((value) {})
      .catchError((error) {
        print("Lỗi khi thêm dữ liệu vào repcomment: $error");
      });
}
