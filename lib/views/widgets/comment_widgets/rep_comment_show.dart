import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RepCMW extends StatelessWidget {
  RepCMW({Key? key,required this.videoID,required this.itemID}): super(key: key);
  String videoID,itemID;
  CollectionReference videos = FirebaseFirestore.instance.collection('videos');
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 2,
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
              .doc(itemID)
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
                                          null ? DateTime.now().toString()
                                          : DateFormat.yMMMd().add_jm().format(
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
                            //         onTap: () {
                            //           VideoServices
                            //               .likeComment(
                            //                   videoID,
                            //                   item[
                            //                       'id']);
                            //         },
                            //         child: Icon(
                            //           Icons
                            //               .favorite,
                            //           color: snapshot
                            //                   .data!
                            //                   .docs[
                            //                       index]
                            //                       [
                            //                       'likes']
                            //                   .contains(
                            //                       uid)
                            //               ? Colors
                            //                   .red
                            //               : Colors
                            //                   .grey,
                            //         ),
                            //       ),
                            //       Text(
                            //           '${item['likes'].length}'),
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
    );
  }
}
