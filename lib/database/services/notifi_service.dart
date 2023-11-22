import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:tiktok_app_poly/views/pages/home/Notification/notifi.dart';
import 'package:tiktok_app_poly/views/widgets/snackbar.dart';

class NotificationsService {
  static const key =
      'AAAADwV1u20:APA91bFdjV0QuGcO6cCwD8ydwhQLFp3U9NQbjMGJ-IaCsFDm_LQeOS59Wp9ROaDNeYy0zEOzX8QCZwukHSxf5pwt75SbMJwU0D4hpwdpbpt7hZth29TvaqZKWXMhBkuM88fFG2QJowau';
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  void initLocalNotification() {
    try {
      const androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      const iosSettings = DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestCriticalPermission: true,
          requestSoundPermission: true);

      const initializationSettings =
          InitializationSettings(android: androidSettings, iOS: iosSettings);

      flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (details) {
          debugPrint(details.payload.toString());
        },
      );
    } catch (e) {
      print('=======================chết ở 1');
    }
  }

  Future<void> requestPermission() async {
    final messaging = FirebaseMessaging.instance;
    final settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true);
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('============================User granted permission');
      debugPrint('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('============================User granted provisional permission');
      debugPrint('User granted provisional permission');
    } else {
      print(
          '============================User declined or has not accepted permission');
      debugPrint('User declined or has not accepted permission');
    }
  }

  Future<void> getToken() async {
    final token = await FirebaseMessaging.instance.getToken();
    _saveToken(token!);
  }

  Future<void> _saveToken(String token) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({'token': token}, SetOptions(merge: true));
  }

  Future<String> getReceiverToken(String? receiverId) async {
    final getToken = await FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .get();
    print('${getToken.data()}-----------------------');
    return await getToken.data()!['token'];
  }

  void firebaseNotification(context) {
    try {
      initLocalNotification();
      FirebaseMessaging.onMessageOpenedApp.listen((event) async {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const NotificationScreen(),
          ),
        );
      });
      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        print(message.data);
        await _showLocalNotification(message);
      });
    } catch (e) {
      print('===========================chết ở 4');
    }
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    try {
      final senderAvatarUrl = message.data['senderAvatarUrl'];
      final styleInformation = BigTextStyleInformation(
          message.notification!.body.toString(),
          htmlFormatBigText: true,
          contentTitle: message.notification!.title,
          htmlFormatTitle: true);

      final androidDetails = AndroidNotificationDetails(
          'com.example.tiktok_app_poly',
          importance: Importance.max,
          'mychannelid',
          styleInformation: styleInformation,
          priority: Priority.max,
          largeIcon: senderAvatarUrl);

      const iosDetails =
          DarwinNotificationDetails(presentAlert: true, presentBadge: true);
      final notificaltionDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );
      await flutterLocalNotificationsPlugin.show(0, message.notification!.title,
          message.notification!.body, notificaltionDetails,
          payload: message.data['body']);
    } catch (e) {
      print('=======================chết ở 2');
    }
  }

  Future<void> sendNotification(
      {required String uidNd,
      required String title,
      required String body,
      required String idOther,
      required String avartarUrl,
      required String cretory}) async {
    print('đến đây r');
    String token = await getReceiverToken(uidNd);
    print(token.toString());
    String uid = FirebaseAuth.instance.currentUser!.uid;
    try {
      await http
          .post(
            Uri.parse('https://fcm.googleapis.com/fcm/send'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Authorization': 'key=$key',
            },
            body: jsonEncode(<String, dynamic>{
              'to': token,
              'priority': 'high',
              'notification': <String, dynamic>{
                'body': body,
                'title': title,
              },
              'data': <String, String>{
                'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                'status': 'done',
                'senderId': uid,
              }
            }),
          )
          .then(
            (value) {},
          );
      await addNotification(
          uiD: uidNd,
          content: body,
          idUser: idOther,
          title: title,
          avartarUrl: avartarUrl,
          cretory: cretory);
      print('thành công=======================');
    } catch (e) {
      print('Lỗi ==========================');
      print(e.toString());
    }
  }

  static addNotification(
      {required String uiD,
      required String idUser,
      required String title,
      required String content,
      required String avartarUrl,
      required String cretory}) async {
    print('thêm');
    CollectionReference notifications =
        FirebaseFirestore.instance.collection('notifications');
    try {
      DateTime currentTime = DateTime.now();
      await notifications.add({
        'uid': uiD,
        'title': title,
        'content': content,
        'idUser': idUser,
        'time': currentTime,
        'image': avartarUrl,
        'cretory': cretory,
        'check': 0
      }).then((value) => print("User Added"));
    } catch (e) {
      print('Lỗi khi thêm thông báo: $e');
    }
  }

  static editCheckNotiShow(
      {required BuildContext context,required String id}) async {
    try {
      CollectionReference noti =
          FirebaseFirestore.instance.collection('notifications');
      noti.doc(id)
          .update({
            'check': 1,
          })
          .then((value) => print("Updated"))
          .catchError((error) => print("Failed to update noti: $error"));
    } catch (e) {}
  }

  static CheckNotiShow({required int id}) {}
}
