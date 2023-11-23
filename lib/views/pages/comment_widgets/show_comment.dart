import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tiktok_app_poly/database/services/notifi_service.dart';
import 'package:tiktok_app_poly/database/services/video_service.dart';
import 'package:tiktok_app_poly/provider/comment_model.dart';
import 'package:tiktok_app_poly/views/pages/comment_widgets/rep_comment_show.dart';
import 'package:tiktok_app_poly/views/widgets/textf_comment.dart';

class CommentItem extends StatefulWidget {
  CommentItem({Key? key, required this.videoID, required this.uid})
      : super(key: key);
  final String videoID;
  final String uid;

  @override
  State<CommentItem> createState() => _CommentItemState();
}


class _CommentItemState extends State<CommentItem> {
  CollectionReference videos = FirebaseFirestore.instance.collection('videos');
  TextEditingController _textEditingControllerup =
  TextEditingController();
 // Khai báo ở cấp độ lớp




  _showDialog(BuildContext context, String idexx,String value) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  VideoServices.delete(videoID: widget.videoID, idexx: idexx);
                  Navigator.pop(context);
                },
                child: Text("Delete"),
              ),
              TextButton(
                onPressed: () {
                  print('đã click');
                  _showUpdateDialog(context, idexx, widget.videoID,value);
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

  Future<void> _showUpdateDialog(BuildContext context, String indexT,
      String videoID,String value) async {
    _textEditingControllerup.text = ''; // Đặt giá trị ban đầu cho TextField
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: Text("Cập nhật bình luận"),
            content: SizedBox(
              height: 100,
                width: 300,
                child: TextFComment(check: 'update', videoID: videoID, uid: widget.uid, commentID: indexT,vauleUp: value,))
        );
      },
    );
  }

  void _showRepCM(BuildContext context, String videoID, String idComment) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery
              .of(context)
              .size
              .height * 2 / 5 + 50,
          child: TextFComment(
              check: 'rep', videoID: videoID, uid: widget.uid, commentID: idComment,vauleUp: ''),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final RenderObject? overlay =
    Overlay
        .of(context)
        .context
        .findRenderObject();
    Offset tapDownPosition = Offset.zero;
    return Scaffold(
      body: SizedBox(
        height: MediaQuery
            .of(context)
            .size
            .height * 3 / 4,
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
                  videos.doc(widget.videoID).collection('commentList').snapshots(),
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
                stream: videos.doc(widget.videoID)
                    .collection('commentList')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (BuildContext context, int index) {
                              final item = snapshot.data!.docs[index];
                              return ChangeNotifierProvider<Cmodel>(
                                create: (context) => Cmodel(),
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                                width: MediaQuery
                                                    .of(context)
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
                                                    item.get('uID')
                                                        .toString();
                                                    if (widget.uid == idCheck) {
                                                      _showDialog(
                                                          context, indexite,item['content']);
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
                                                        ? DateTime.now()
                                                        .toString()
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
                                                        _showRepCM(context,
                                                            widget.videoID,
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
                                                        widget.videoID, item['id']);
                                                  },
                                                  child: Icon(
                                                    Icons.favorite,
                                                    color: snapshot.data!
                                                        .docs[index]['likes']
                                                        .contains(widget.uid)
                                                        ? Colors.red
                                                        : Colors.grey,
                                                  ),
                                                ),
                                                Text('${item['likes']
                                                    .length}'),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    RepCMW(
                                      videoID: widget.videoID,
                                      itemID: item['id'],
                                      uid: widget.uid,
                                    )
                                  ],
                                ),
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
            Container(
              child: TextFComment(
                check: 'send',
                videoID: widget.videoID,
                uid: widget.uid,
                commentID: '',
                vauleUp: '',
              ),
            )
          ],
        ),
      ),
    );
  }
}
