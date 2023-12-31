import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tiktok_app_poly/database/services/notifi_service.dart';
import 'package:tiktok_app_poly/views/widgets/snackbar.dart';

class VideoServices {
  static likeVideo(String id) async {
    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection('videos').doc(id).get();
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    DocumentSnapshot docUser =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    print(docUser.data().toString());
    if ((doc.data()! as dynamic)['likes'].contains(uid)) {
      await FirebaseFirestore.instance.collection('videos').doc(id).update({
        'likes': FieldValue.arrayRemove([uid]),
      });
    } else {
      await FirebaseFirestore.instance.collection('videos').doc(id).update({
        'likes': FieldValue.arrayUnion([uid]),
      });
      NotificationsService().sendNotification(
          uidNd: doc.get('uid').toString(),
          title: "Chào bạn",
          body: 'Bạn nhận 1 lượt thích từ ${(docUser.data()! as dynamic)['fullName']}',
          idOther: uid.toString(),
          idVideo: doc.get('id').toString(),
          avartarUrl: '${(docUser.data()! as dynamic)['avartaURL']}',
          cretory: 'likeVideo');
    }
  }

  static likeComment(String videoID, String commentId) async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('videos')
        .doc(videoID)
        .collection('commentList')
        .doc(commentId)
        .get();
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    DocumentSnapshot docUser =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if ((doc.data()! as dynamic)['likes'].contains(uid)) {
      await FirebaseFirestore.instance
          .collection('videos')
          .doc(videoID)
          .collection('commentList')
          .doc(commentId)
          .update({
        'likes': FieldValue.arrayRemove([uid]),
      });
    } else {
      await FirebaseFirestore.instance
          .collection('videos')
          .doc(videoID)
          .collection('commentList')
          .doc(commentId)
          .update({
        'likes': FieldValue.arrayUnion([uid]),
      });
    }
  }

  static likeReComment(String videoID, String commentId, String repID) async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('videos')
        .doc(videoID)
        .collection('commentList')
        .doc(commentId)
        .collection('repcomment')
        .doc(repID)
        .get();
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if ((doc.data()! as dynamic)['likes'].contains(uid)) {
      await FirebaseFirestore.instance
          .collection('videos')
          .doc(videoID)
          .collection('commentList')
          .doc(commentId)
          .collection('repcomment')
          .doc(repID)
          .update({
        'likes': FieldValue.arrayRemove([uid]),
      });
    } else {
      await FirebaseFirestore.instance
          .collection('videos')
          .doc(videoID)
          .collection('commentList')
          .doc(commentId)
          .collection('repcomment')
          .doc(repID)
          .update({
        'likes': FieldValue.arrayUnion([uid]),
      });
    }
  }

  static sendComment(
      {required BuildContext context,
      required message,
      required uid,
      required videoID}) async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('videos')
        .doc(videoID)
        .get();
    final CollectionReference users =
        FirebaseFirestore.instance.collection('users');
    CollectionReference videos =
        FirebaseFirestore.instance.collection('videos');
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

  static RepComment(
      {required message,
      required uid,
      required videoID,
      required idComment}) async {
    final CollectionReference users =
        FirebaseFirestore.instance.collection('users');
    // ignore: unused_local_variable
    CollectionReference videos =
        FirebaseFirestore.instance.collection('videos');
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
    }).then((value) {
      print("thêm dữ liệu thành công");
    }).catchError((error) {
      print("Lỗi khi thêm dữ liệu vào repcomment: $error");
    });
  }

  //xóa comment
  static delete({required videoID, required idexx}) async {
    await FirebaseFirestore.instance
        .collection("videos")
        .doc(videoID)
        .collection('commentList')
        .doc(idexx)
        .delete()
        .then((value) => {print("xóa thành công")});

    var allDocs = await FirebaseFirestore.instance
        .collection('videos')
        .doc(videoID)
        .collection('commentList')
        .doc(idexx)
        .collection('repcomment')
        .get();
    int len = allDocs.docs.length;
    if (len != 0) {
      FirebaseFirestore.instance
          .collection('videos')
          .doc(videoID)
          .collection('commentList')
          .doc(idexx)
          .collection('repcomment')
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((document) {
          document.reference.delete();
        });
        print("Xóa tất cả tài liệu thành công");
      }).catchError((error) {
        print("Lỗi khi xóa tất cả tài liệu: $error");
      });
    }
  }

  //xóa rep comment
  static deleteRep({required videoID, required idexx, idcomment}) async {
    await FirebaseFirestore.instance
        .collection("videos")
        .doc(videoID)
        .collection('commentList')
        .doc(idexx)
        .collection('repcomment')
        .doc(idcomment)
        .delete();
  }

  //sửa comment
  static update(
      {required videoID, required commentId, required comment}) async {
    return await FirebaseFirestore.instance
        .collection('videos')
        .doc(videoID)
        .collection('commentList')
        .doc(commentId)
        .update({'content': comment});
  }

  static checkLike(String id) {}

  static updateVideoFect(BuildContext context,String id, String collums, String values) async {
    try{
      CollectionReference doc = FirebaseFirestore.instance.collection('videos');
      doc.doc(id)
          .update({
        collums: values,
      }).then((value) => print("Video Updated")).catchError((error) => print("Failed to update user: $error"));
    }catch (e){
      print('lỗi : ${e}');
    }
  }
}
