import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tiktok_app_poly/database/models/video_model.dart';
import 'package:tiktok_app_poly/database/services/user_service.dart';
import 'package:tiktok_app_poly/views/widgets/circle_animation.dart';

import '../../../../../database/services/storage_services.dart';
import '../../../../../database/services/video_service.dart';
import '../../../../widgets/colors.dart';
import '../../../../widgets/video_player_item.dart';
import '../people_detail_screen.dart';

// ignore: must_be_immutable
class VideoScreen extends StatelessWidget {
  VideoScreen({Key? key, required this.videoID}) : super(key: key);
  final String videoID;
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

  Future<void> sendComment(String message, String videoID) async {
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

  _deleteComment(BuildContext context, String idexx, String videoID) async {
    videos.doc(videoID).collection('commentList').doc(idexx).delete();
    Navigator.pop(context);
  }

  void _updateComment(String videoID, String commentId, String comment,
      BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('videos')
          .doc(videoID)
          .collection('commentList')
          .doc(commentId)
          .update({'content': comment});
    } on FirebaseException catch (e) {
      print('khaonnannandandandan' + e.message.toString());
    }
  }

  TextEditingController _textEditingController = TextEditingController();
  Future<void> _showUpdateDialog(
      BuildContext context, String indexT, String videoID) async {
    _textEditingController.text = ''; // Đặt giá trị ban đầu cho TextField
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Update Comment"),
          content: TextField(
            controller: _textEditingController, // Gán controller cho TextField
            textAlignVertical: TextAlignVertical.bottom,
            decoration: InputDecoration(hintText: 'Nhập nội dung bình luận'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Lưu'),
              onPressed: () {
                String comment = _textEditingController.text;
                _updateComment(videoID, indexT, comment, context);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _showDialog(BuildContext context, String idexx, String videoId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  _deleteComment(context, idexx, videoId);
                },
                child: Text("Delete"),
              ),
              TextButton(
                onPressed: () {
                  _showUpdateDialog(context, idexx, videoID);
                  // _showBottomSheet(context, videoID);
                },
                child: Text("Update"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Đóng hộp thoại
                },
                child: Text("Cancel"),
              ),
            ],
          ),
        );
      },
    );
  }

  _showBottomSheetooooooo(BuildContext context, String videoID) {
    final TextEditingController _textEditingController =
        TextEditingController();
    final page2 = SizedBox(
      height: MediaQuery.of(context).size.height * 3 / 4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamBuilder<QuerySnapshot>(
                stream:
                    videos.doc(videoID).collection('commentList').snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something.....');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Container(),
                    );
                  }
                  if (snapshot.hasData) {
                    return Text(
                      '${snapshot.data!.docs.length} Comments',
                      style: const TextStyle(fontSize: 18),
                    );
                  }
                  return Container();
                },
              ),
            ],
          ),
          Flexible(
            child: StreamBuilder<QuerySnapshot>(
              stream: videos.doc(videoID).collection('commentList').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Container(),
                  );
                }
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            final item = snapshot.data!.docs[index];
                            return Column(
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            '${item['avatarURL']}'),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${item['userName']}',
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black38),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                3 /
                                                4,
                                            child: GestureDetector(
                                              onTap: () {
                                                // Xử lý sự kiện khi chạm vào Text
                                                String indexite =
                                                    item.get('id').toString();
                                                String idCheck =
                                                    item.get('uID').toString();
                                                if (uid == idCheck) {
                                                  _showDialog(context, indexite,
                                                      videoID);
                                                }
                                              },
                                              child: Text(
                                                '${item['content']}',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                  fontFamily: 'Popins',
                                                ),
                                              ),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                item['createdOn'] == null
                                                    ? DateTime.now().toString()
                                                    : DateFormat.yMMMd()
                                                        .add_jm()
                                                        .format(
                                                            item['createdOn']
                                                                .toDate()),
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black38,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              // Khoảng cách giữa "Trả lời" và thời gian
                                              GestureDetector(
                                                onTap: () =>
                                                    _showBottomSheetoooo(
                                                        context,
                                                        videoID,
                                                        item.get('id')),
                                                child: const Text(
                                                  'Trả lời',
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black38,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: Column(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                VideoServices.likeComment(
                                                    videoID, item['id']);
                                              },
                                              child: Icon(
                                                Icons.favorite,
                                                color: snapshot.data!
                                                        .docs[index]['likes']
                                                        .contains(uid)
                                                    ? Colors.red
                                                    : Colors.grey,
                                              ),
                                            ),
                                            Text('${item['likes'].length}'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height / 2,
                                  margin: EdgeInsets.only(left: 10),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      left: BorderSide(
                                          color: Colors.grey, width: 2),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: StreamBuilder<QuerySnapshot>(
                                      stream: videos
                                          .doc(videoID)
                                          .collection('commentList')
                                          .doc(item['id'])
                                          .collection('repcomment')
                                          .snapshots(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<QuerySnapshot>
                                              snapshots) {
                                        if (snapshots.hasError) {
                                          return const Text(
                                              'Something went wrong');
                                        }
                                        if (snapshots.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(
                                            child: Container(
                                              height: 20,
                                              color: Colors.red,
                                            ),
                                          );
                                        }
                                        if (snapshots.hasData) {
                                          return ListView.builder(
                                            itemCount:
                                                snapshots.data!.docs.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              final items =
                                                  snapshots.data!.docs[index];
                                              return Column(
                                                children: [
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        CircleAvatar(
                                                          backgroundImage:
                                                              NetworkImage(
                                                                  '${items['avatarURL']}'),
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              '${items['userName']}',
                                                              style: const TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .black38),
                                                            ),
                                                            SizedBox(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  3 /
                                                                  4,
                                                              child:
                                                                  GestureDetector(
                                                                onTap: () {},
                                                                child: Text(
                                                                  '${items['content']}',
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    color: Colors
                                                                        .black,
                                                                    fontFamily:
                                                                        'Popins',
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  items['createdOn'] ==
                                                                          null
                                                                      ? DateTime
                                                                              .now()
                                                                          .toString()
                                                                      : DateFormat
                                                                              .yMMMd()
                                                                          .add_jm()
                                                                          .format(
                                                                              items['createdOn'].toDate()),
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    color: Colors
                                                                        .black38,
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                    width: 8),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        // const Spacer(),
                                                        // Padding(
                                                        //   padding:
                                                        //       const EdgeInsets
                                                        //           .only(
                                                        //           right: 8.0),
                                                        //   child: Column(
                                                        //     children: [
                                                        //       InkWell(
                                                        //         onTap: () {},
                                                        //         child: Icon(
                                                        //           Icons
                                                        //               .favorite,
                                                        //           color: Colors
                                                        //               .grey,
                                                        //         ),
                                                        //       ),
                                                        //     ],
                                                        //   ),
                                                        // ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }
                                        return Container(
                                          height: 20,
                                          color: Colors.red,
                                        );
                                      },
                                    ),
                                  ),
                                )
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }
                return Container();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 40,
              child: TextField(
                controller: _textEditingController,
                textAlignVertical: TextAlignVertical.bottom,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 2,
                      color: MyColors.thirdColor,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  hintText: "Comment here ...",
                  suffixIcon: IconButton(
                    onPressed: () {
                      sendComment(_textEditingController.text, videoID);
                      _textEditingController.text = '';
                    },
                    icon: Icon(
                      Icons.send_rounded,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
    //_scaffoldKey.currentState.showBottomSheet((context) => null);
    showModalBottomSheet<void>(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(7),
        ),
      ),
      //enableDrag: true,
      backgroundColor: Colors.white,
      context: context,
      builder: (context) {
        return page2;
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
                      child: VideoPlayerItem(
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
                                                context, item.id);
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

  void _showBottomSheetoooo(
      BuildContext context, String videoID, String idComment) {
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
                  sendCommentList(comment, videoID, idComment);
                  _textEditingController.clear();
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