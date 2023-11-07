import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommentService {

  static sendComment({required BuildContext context,required message,required uid,required videoID}) async {
    final CollectionReference users =
    FirebaseFirestore.instance.collection('users');
    CollectionReference videos = FirebaseFirestore.instance.collection('videos');
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
    videos.doc(videoID).collection('commentList').doc('Comment $len').set({
      'createdOn': FieldValue.serverTimestamp(),
      'uID': uid,
      'content': message,
      'avatarURL': avatarURL,
      'userName': userName,
      'id': 'Comment $len',
      'likes': []
    }).then((value) async {});
  }

  static RepComment({required BuildContext context,required message,required uid,required videoID,required idComment}) async {
    final CollectionReference users =
    FirebaseFirestore.instance.collection('users');
    CollectionReference videos = FirebaseFirestore.instance.collection('videos');
    if (message == '') return;
    final result = await users.doc(uid).get();
    final String avatarURL = result.get('avartaURL');
    final String userName = result.get('fullName');
    int len = 0;
    var allDocs = await FirebaseFirestore.instance
        .collection('videos')
        .doc(videoID)
        .collection('commentList')
        .doc(idComment)
        .collection('repcomment')
        .get();
    len = allDocs.docs.length;
    await FirebaseFirestore.instance
        .collection('videos')
        .doc(videoID)
        .collection('commentList')
        .doc(idComment)
        .collection('repcomment')
        .doc('RepCount $len')
        .set({
      'createdOn': FieldValue.serverTimestamp(),
      'uID': uid,
      'content': message,
      'avatarURL': avatarURL,
      'userName': userName,
      'id': 'RepCount $len',
      'likes': []
    })
        .then((value) {})
        .catchError((error) {
      print("Lỗi khi thêm dữ liệu vào repcomment: $error");
    });
    Navigator.pop(context);
  }


  //xóa comment
  static delete({required videoID, required idexx}){
    CollectionReference videos = FirebaseFirestore.instance.collection('videos');
    videos.doc(videoID).collection('commentList').doc(idexx).delete();
  }

  //sửa comment
  static update({required videoID,required commentId,required comment}) async {
    return await FirebaseFirestore.instance
        .collection('videos')
        .doc(videoID)
        .collection('commentList')
        .doc(commentId)
        .update({'content': comment});
  }
}
