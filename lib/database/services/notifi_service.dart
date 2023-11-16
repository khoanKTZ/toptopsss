import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotifiService {
  final FlutterLocalNotificationsPlugin _flu = FlutterLocalNotificationsPlugin();

  Future<void> initNoti ()async{
    try{
      AndroidInitializationSettings androidSetting = AndroidInitializationSettings('tiktok_logo');

      var iosSetting = DarwinInitializationSettings(
          requestSoundPermission: true,
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestProvisionalPermission: true,
          onDidReceiveLocalNotification: (int id, String? title, String? body, String? payload) async {});


      InitializationSettings settings = InitializationSettings(
        android: androidSetting,
        iOS: iosSetting,
      );

      await _flu.initialize(settings,onDidReceiveNotificationResponse: (NotificationResponse response) async {},);
    }catch (e){
      print("lỗi notifiservice: ${e}");
    }
  }

  Future<NotificationDetails> notificationDetails() async {
    print('vào đây');
    return NotificationDetails(
        android: AndroidNotificationDetails('com.example.tiktok_app_poly', 'tiktokn4',
            importance: Importance.max,
        priority: Priority.high),
        iOS: DarwinNotificationDetails(presentAlert: true,presentBanner: true));
  }

  Future showNotification(
      {int id = 0, String? title, String? body, String? payLoad}) async {
    print('chạy vào đây trước');
    return _flu.show(
        id, title, body,await notificationDetails());
  }

}