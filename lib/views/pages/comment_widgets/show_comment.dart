import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tiktok_app_poly/database/services/comment_service.dart';
import 'package:tiktok_app_poly/database/services/video_service.dart';
import 'package:tiktok_app_poly/views/pages/comment_widgets/rep_comment_show.dart';
import 'package:intl/intl.dart';
import 'package:tiktok_app_poly/views/widgets/textf_comment.dart';

class CommentItem extends StatelessWidget {
  CommentItem({Key? key, required this.videoID, required this.uid})
      : super(key: key);
  final String videoID;
  final String uid;

  CollectionReference videos = FirebaseFirestore.instance.collection('videos');
  TextEditingController _textEditingControllerup =
  TextEditingController(); // Khai báo ở cấp độ lớp

  _showDialog(BuildContext context, String idexx) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  CommentService.delete(videoID: videoID, idexx: idexx);
                  Navigator.pop(context);
                },
                child: Text("Delete"),
              ),
              TextButton(
                onPressed: () {
                  print('đã click');
                  _showUpdateDialog(context, idexx, videoID);
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


  Future<void> _showUpdateDialog(
      BuildContext context, String indexT, String videoID) async {
    _textEditingControllerup.text = ''; // Đặt giá trị ban đầu cho TextField
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Cập nhật bình luận"),
          content: TextField(
            controller: _textEditingControllerup, // Gán controller cho TextField
            textAlignVertical: TextAlignVertical.bottom,
            decoration: InputDecoration(hintText: 'Nhập nội dung bình luận'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Lưu'),
              onPressed: () {
                String comment = _textEditingControllerup.text;
                CommentService.update(
                    videoID: videoID, commentId: indexT, comment: comment);
                print(indexT);
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showRepCM(
      BuildContext context, String videoID, String idComment) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return TextFComment(check: 'rep', videoID: videoID, uid: uid, commentID: idComment);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
                                                  _showDialog(
                                                    context,
                                                    indexite,
                                                  );
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
                                                    _showRepCM(
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
                                RepCMW(videoID: videoID, itemID: item['id'],uid: uid,)
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
          TextFComment(check: 'send', videoID: videoID, uid: uid,commentID: '',)
        ],
      ),
    );
  }
}
