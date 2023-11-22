import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:tiktok_app_poly/database/services/notifi_service.dart';
import 'package:tiktok_app_poly/provider/notifi_model_check.dart';
import 'package:tiktok_app_poly/views/pages/home/user_page/fllower/follower_screen.dart';
import 'package:tiktok_app_poly/views/pages/home/user_page/people_detail_screen.dart';
import 'package:tiktok_app_poly/views/pages/home/user_page/video_page/video_profile_player_screen.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final notification = NotificationsService();
  String? uid = FirebaseAuth.instance.currentUser?.uid;
  int Count = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 15, 0, 25),
                  height: 60,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Hộp thư',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 20),
                      ),
                      Icon(Icons.notifications,color: Colors.grey,)
                    ],
                  ),
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('notifications')
                      .where('uid', whereIn: [uid]).snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    print(
                        "thông tin ===================================${snapshot.data!.docs.length}");
                    return ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        final item = snapshot.data!.docs[index];
                        return ChangeNotifierProvider<NotifiCheck>(
                          create: (context) => NotifiCheck(),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                if(item['cretory'] == 'follow')Navigator.push(context, MaterialPageRoute(builder: (context) => PeopleInfoScreen(peopleID: item['idUser']),));
                                if(item['cretory'] == 'likeVideo')Navigator.push(context, MaterialPageRoute(builder: (context) => VideoProfileScreen(videoID: item['idUser']),));
                                NotificationsService.editCheckNotiShow(context: context,id: item.id);
                              });
                            },
                            child: Consumer<NotifiCheck>(
                              builder: (BuildContext context, NotifiCheck value, Widget? child) {
                                value.changerNotifiCheck(item['check']);
                                return Card(
                                  margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                  child: Container(
                                    color: value.isCheckNoti ? Colors.white.withOpacity(0.25): Colors.grey.withOpacity(0.25),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 60,
                                          height: 60,
                                          margin: const EdgeInsets.all(10),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(30),
                                            child: Image.network(
                                              item['image'],
                                              width: 60,
                                              height: 60,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item['title'],
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 17,
                                              ),
                                            ),
                                            Text(
                                              item['content'],
                                              style: const TextStyle(
                                                color: Color(0xff666666),
                                                fontSize: 13,
                                              ),
                                            ),
                                            Text(
                                              item['time'] == null
                                                  ? DateTime.now().toString()
                                                  : DateFormat.yMMMd()
                                                  .add_jm()
                                                  .format(item['time'].toDate()),
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.black38,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
