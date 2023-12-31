import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tiktok_app_poly/database/services/video_service.dart';
import 'package:tiktok_app_poly/provider/comment_model.dart';

class RepCMW extends StatefulWidget {
  RepCMW(
      {Key? key,
      required this.videoID,
      required this.itemID,
      required this.uid})
      : super(key: key);
  String videoID, itemID, uid;

  @override
  State<RepCMW> createState() => _RepCMWState();
}

class _RepCMWState extends State<RepCMW> {
  CollectionReference videos = FirebaseFirestore.instance.collection('videos');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: videos
          .doc(widget.videoID)
          .collection('commentList')
          .doc(widget.itemID)
          .collection('repcomment')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshots) {
        if (snapshots.hasError) {
          return const Text('Something went wrong');
        }
        if (snapshots.hasData) {
          bool check = snapshots.data!.docs.length != 0;
          int count = snapshots.data!.docs.length;
          return check ? Consumer<Cmodel>(
            builder: (context, value, child) {
              return Column(
                children: [
                  value.isShowRepCM
                      ? Padding(
                          padding: const EdgeInsets.only(left: 50,right: 20),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 200,
                            //lành
                            child: ListView.builder(
                              itemCount: snapshots.data!.docs.length,
                              itemBuilder: (BuildContext context, int index) {
                                final items = snapshots.data!.docs[index];
                                return Column(
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 30,
                                            height: 30,
                                            child: CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  '${items['avatarURL']}'),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Container(
                                            width: 200,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${items['userName']}',
                                                  style: const TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.black38),
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      3 /
                                                      4,
                                                  child: GestureDetector(
                                                    onTap: () {},
                                                    child: Text(
                                                      '${items['content']}',
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black,
                                                        fontFamily: 'Popins',
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      items['createdOn'] == null
                                                          ? DateTime.now()
                                                              .toString()
                                                          : DateFormat.yMMMd()
                                                              .add_jm()
                                                              .format(items[
                                                                      'createdOn']
                                                                  .toDate()),
                                                      style: const TextStyle(
                                                        fontSize: 8,
                                                        color: Colors.black38,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 8),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Spacer(),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 2.0),
                                            child: Column(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    VideoServices.likeReComment(
                                                        widget.videoID,
                                                        widget.itemID,
                                                        items['id']);
                                                  },
                                                  child: Icon(
                                                    Icons.favorite,
                                                    color: snapshots
                                                            .data!
                                                            .docs[index]
                                                                ['likes']
                                                            .contains(widget.uid)
                                                        ? Colors.red
                                                        : Colors.grey,size: 17,
                                                  ),
                                                ),
                                                Text(
                                                    '${items['likes'].length}'),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        )
                      : Row(
                          children: [
                            Container(
                              width: 20,
                              child: const Divider(
                                color: Colors.grey,
                                height: 20,
                                thickness: 1,
                              ),
                            ),
                            const SizedBox(width: 5),
                            TextButton(
                              onPressed: () {
                                value.changeShowRepCM();
                              },
                              child: Text(
                                "view ${count}",
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                  SizedBox(
                    height: 10,
                  ),
                  value.isShowRepCM
                      ? Align(
                    child: TextButton(
                      onPressed: () {
                        value.changeShowRepCM();
                      },
                      child: const Text(
                        "— ẩn —",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  )
                      : SizedBox(),
                ],
              );
            },
          ):
          SizedBox();
        }
        return Container(
          child: SizedBox(),
        );
      },
    );
  }
}
