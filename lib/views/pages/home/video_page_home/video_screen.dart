import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tiktok_app_poly/database/models/video_model.dart';
import 'package:tiktok_app_poly/database/services/user_service.dart';
import 'package:tiktok_app_poly/views/pages/comment_widgets/show_comment.dart';
import 'package:tiktok_app_poly/views/widgets/circle_animation.dart';

import '../../../../database/services/storage_services.dart';
import '../../../../database/services/video_service.dart';
import '../../../widgets/colors.dart';
import '../../../widgets/video_player_item.dart';
import '../user_page/people_detail_screen.dart';

// ignore: must_be_immutable
class VideoScreen extends StatelessWidget {
  VideoScreen({Key? key}) : super(key: key);
  String? uid = FirebaseAuth.instance.currentUser?.uid;
  CollectionReference videos = FirebaseFirestore.instance.collection('videos');
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');
  // final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<dynamic> list = [''];

  Stream<QuerySnapshot> fetch() {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .snapshots()
        .asyncMap((snapshot) async {
      List<dynamic> list2 = snapshot.data()!['following'];
      QuerySnapshot videoSnapshot = await FirebaseFirestore.instance
          .collection('videos')
          .where('uid', whereIn: list2)
          .get();
      return videoSnapshot;
    });
  }

  buildProfile(
      BuildContext context, String profilePhoto, String id, String videoUid) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Stack(children: [
        Positioned(
          left: 5,
          child: Container(
            width: 50,
            height: 50,
            padding: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PeopleInfoScreen(peopleID: id)),
                  );
                },
                child: Image(
                  image: NetworkImage(profilePhoto),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        StreamBuilder(
            stream: users.doc(uid).snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox();
              }
              bool isFollowing =
                  snapshot.data!.get('following').contains(videoUid);
              return Positioned(
                left: 20,
                bottom: 0,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: InkWell(
                    onTap: () async {
                      if (!isFollowing) {
                        await UserService.follow(
                            videoUid); // Function to follow a user
                      }
                    },
                    child: Container(
                      key: ValueKey<int>(isFollowing ? 1 : 2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isFollowing ? Colors.white : MyColors.pinkColor,
                      ),
                      child: Icon(
                        isFollowing ? Icons.check : Icons.add,
                        color: isFollowing ? MyColors.pinkColor : Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              );
            })
      ]),
    );
  }

  buildMusicAlbum(String profilePhoto) {
    return SizedBox(
      width: 50,
      height: 50,
      child: Column(
        children: [
          Container(
              padding: const EdgeInsets.all(8),
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Colors.grey,
                      Colors.white,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(25)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image(
                  image: NetworkImage(profilePhoto),
                  fit: BoxFit.cover,
                ),
              ))
        ],
      ),
    );
  }

  _showBottomSheetooooooo(BuildContext context, String videoID,String uid) {
    //_scaffoldKey.currentState.showBottomSheet((context) => null);
    showModalBottomSheet<void>(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(7),
        ),
      ),
      enableDrag: true,
      backgroundColor: Colors.white,
      context: context,
      builder: (context) {
        return CommentItem(videoID: videoID, uid: uid);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //FocusManager.instance.primaryFocus.unfocus();
    return DefaultTabController(
      initialIndex: 1,
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            TabBarView(
              children: [body(context, true), body(context, false)],
            ),
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SizedBox(
                height: 50,
                child: TabBar(
                  tabs: [
                    Tab(
                      child: Text(
                        'Following',
                        style:
                            TextStyle(fontSize: 18), // Điều chỉnh cỡ chữ ở đây
                      ),
                    ),
                    Tab(
                      child: Text(
                        'Related',
                        style:
                            TextStyle(fontSize: 18), // Điều chỉnh cỡ chữ ở đây
                      ),
                    ),
                  ],
                  indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(
                      width: 3,
                      color: Colors.white,
                    ),
                    insets: EdgeInsets.only(left: 70, right: 70),
                    // Điều chỉnh chiều dài ở đây
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget body(BuildContext context, bool check) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: StreamBuilder<QuerySnapshot>(
        stream: check
            ? fetch()
            : FirebaseFirestore.instance
                .collection('videos')
                .where('uid', whereNotIn: [uid]).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.90,
            child: PageView.builder(
              dragStartBehavior: DragStartBehavior.down,
              itemCount: snapshot.data!.docs.length,
              scrollDirection: Axis.vertical,
              controller: PageController(initialPage: 0, viewportFraction: 1),
              itemBuilder: (context, index) {
                final Video item = Video.fromSnap(snapshot.data!.docs[index]);
                return Stack(
                  children: [
                    Positioned(
                      top: index % 2 == 0
                          ? MediaQuery.of(context).size.height * 0.25
                          : null,
                      bottom: index % 2 == 0
                          ? MediaQuery.of(context).size.height * 0.25
                          : null,
                      child: VideoPlayerItem(context: context,
                        videoUrl: item.videoUrl,
                      ),
                    ),
                    Column(
                      children: [
                        const SizedBox(
                          height: 100,
                        ),
                        Expanded(
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 20, bottom: 10),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        '@ ${item.username}',
                                        style: const TextStyle(
                                            fontSize: 20, color: Colors.white),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        item.caption,
                                        style: const TextStyle(
                                            fontSize: 15,
                                            color: Colors.white60),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          const Icon(
                                            CupertinoIcons.double_music_note,
                                            color: Colors.white,
                                          ),
                                          Text(
                                            item.songName,
                                            style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                width: 80,
                                margin: EdgeInsets.only(
                                    top:
                                        MediaQuery.of(context).size.height / 5),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    buildProfile(context, item.profilePhoto,
                                        item.uid, item.uid),
                                    Column(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            VideoServices.likeVideo(item.id);
                                          },
                                          child: Icon(
                                            Icons.favorite,
                                            size: 25,
                                            color: snapshot
                                                    .data!.docs[index]['likes']
                                                    .contains(uid)
                                                ? Colors.red
                                                : Colors.white,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 7,
                                        ),
                                        Text(
                                          '${item.likes.length}',
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            _showBottomSheetooooooo(
                                                context, item.id,uid!);
                                          },
                                          child: const Icon(
                                            CupertinoIcons
                                                .chat_bubble_text_fill,
                                            size: 25,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 7,
                                        ),
                                        StreamBuilder<QuerySnapshot>(
                                          stream: videos
                                              .doc(item.id)
                                              .collection('commentList')
                                              .snapshots(),
                                          builder: (BuildContext context,
                                              AsyncSnapshot<QuerySnapshot>
                                                  snapshot) {
                                            if (snapshot.hasError) {
                                              return const Text(
                                                  'Something went wrong');
                                            }
                                            if (snapshot.hasData) {
                                              return Text(
                                                '${snapshot.data!.docs.length}',
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white),
                                              );
                                            }
                                            return Container();
                                          },
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            print('Đã click');
                                          },
                                          child: const Icon(
                                            Icons.save,
                                            size: 25,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 7,
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            showOptionsDialog(
                                                context, item.videoUrl);
                                          },
                                          child: const Icon(
                                            Icons.reply,
                                            size: 25,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 7,
                                        ),
                                      ],
                                    ),
                                    CircleAnimation(
                                      child: buildMusicAlbum(item.profilePhoto),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }


  showOptionsDialog(BuildContext context, String url) {
    return showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        children: [
          SimpleDialogOption(
            onPressed: () {
              StorageServices.saveFile(url);
              Navigator.of(context).pop();
            },
            child: Row(
              children: const [
                Icon(Icons.save_alt),
                Padding(
                  padding: EdgeInsets.all(7.0),
                  child: Text(
                    'Save',
                    style: TextStyle(fontSize: 20),
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
                    'Cancel',
                    style: TextStyle(fontSize: 20, color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
