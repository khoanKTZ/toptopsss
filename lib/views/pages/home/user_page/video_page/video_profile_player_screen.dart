import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiktok_app_poly/database/models/video_model.dart';
import 'package:tiktok_app_poly/views/widgets/circle_animation.dart';
import 'package:tiktok_app_poly/views/widgets/comment_widgets/show_comment.dart';
import '../../../../../database/services/storage_services.dart';
import '../../../../../database/services/video_service.dart';
import '../../../../widgets/video_player_item.dart';

// ignore: must_be_immutable
class VideoProfileScreen extends StatelessWidget {
  final String videoID;

  VideoProfileScreen({Key? key, required this.videoID}) : super(key: key);
  List<String> comments = [];
  String? uid = FirebaseAuth.instance.currentUser?.uid;
  CollectionReference videos = FirebaseFirestore.instance.collection('videos');
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');
  buildProfile(String profilePhoto) {
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
              child: Image(
                image: NetworkImage(profilePhoto),
                fit: BoxFit.cover,
              ),
            ),
          ),
        )
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
      //enableDrag: true,
      backgroundColor: Colors.white,
      context: context,
      builder: (context) {
        return CommentItem(videoID: videoID, uid: uid);
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('videos')
            .where('id', isEqualTo: videoID)
            .limit(1)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            final Video item = Video.fromSnap(snapshot.data!.docs[0]);
            return SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    children: [
                      VideoPlayerItem(
                        videoUrl: item.videoUrl,
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
                                              fontSize: 20,
                                              color: Colors.white),
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
                                      top: MediaQuery.of(context).size.height /
                                          5),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      buildProfile(item.profilePhoto),
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
                                                      .data!.docs[0]['likes']
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
                                                  context, item.id, uid!);
                                              print('JKhoan nhấp ccc');
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
                                                  style: TextStyle(
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
                                        child:
                                            buildMusicAlbum(item.profilePhoto),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        top: 20,
                        left: 20,
                        child: IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return Container();
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
