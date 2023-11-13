import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tiktok_app_poly/database/services/chat_services.dart';
import 'package:tiktok_app_poly/database/services/user_service.dart';
import 'package:tiktok_app_poly/views/widgets/colors.dart';
import 'package:tiktok_app_poly/views/widgets/text.dart';

class Following_Screen extends StatefulWidget {
  final String peopleID;
  const Following_Screen({Key? key, required this.peopleID}) : super(key: key);

  @override
  State<Following_Screen> createState() => _Following_ScreenState();
}

class _Following_ScreenState extends State<Following_Screen> {
  final currentUserID = FirebaseAuth.instance.currentUser?.uid;
  String? uid = FirebaseAuth.instance.currentUser?.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Following'),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(currentUserID)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                Map<String, dynamic>? userData =
                    snapshot.data!.data() as Map<String, dynamic>?;

                if (userData == null || !userData.containsKey('following')) {
                  return Text('Bạn chưa theo dõi ai !!!');
                }

                List<String> followingList =
                    List.castFrom<dynamic, String>(userData['following']);

                return ListView.separated(
                  separatorBuilder: (BuildContext context, int index) =>
                      const Padding(
                    padding: EdgeInsets.only(left: 16.0, right: 16.0),
                    child: Divider(
                      thickness: 1,
                      color: Colors.black12,
                    ),
                  ),
                  itemCount: followingList.length,
                  itemBuilder: (BuildContext ctx, int index) {
                    String followingUserID = followingList[index];

                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(followingUserID)
                          .get(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                        if (userSnapshot.hasError || !userSnapshot.hasData) {
                          return const Text(
                              'Something went wrong while loading user data');
                        }

                        Map<String, dynamic> userData =
                            userSnapshot.data!.data() as Map<String, dynamic>;

                        return InkWell(
                            onTap: () {
                              ChatService.getChatID(
                                context: context,
                                peopleID: userData['uID'],
                                currentUserID: currentUserID.toString(),
                                peopleName: userData['fullName'],
                                peopleImage: userData['avartaURL'],
                              );
                            },
                            child: ListTile(
                              leading: Container(
                                width: 48,
                                height: 48,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                alignment: Alignment.center,
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    userData['avartaURL'],
                                  ),
                                ),
                              ),
                              title: CustomText(
                                alignment: Alignment.centerLeft,
                                fontsize: 16,
                                text: userData['fullName'],
                                fontFamily: 'Poppins',
                                color: Colors.black54,
                              ),
                              subtitle: CustomText(
                                alignment: Alignment.centerLeft,
                                fontsize: 14,
                                text: 'Age: ${userData['age']}',
                                fontFamily: 'Poppins',
                                color: Colors.black26,
                              ),
                              trailing: Wrap(
                                spacing: 20,
                                children: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      UserService.follow(userData['uID']);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: MyColors.pinkColor,
                                      elevation: 0,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 60),
                                    ),
                                    child: !followingList
                                            .contains(widget.peopleID)
                                        ? const Text(
                                            "Unfollow",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700),
                                          )
                                        : const Icon(Icons.check),
                                  ),
                                ],
                              ),
                            ));
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
