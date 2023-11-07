import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tiktok_app_poly/database/services/comment_service.dart';
import 'package:tiktok_app_poly/database/services/video_service.dart';
import 'package:tiktok_app_poly/views/widgets/colors.dart';
import 'package:tiktok_app_poly/views/widgets/comment_widgets/rep_comment_show.dart';
import 'package:intl/intl.dart';

class CommentItem extends StatelessWidget {
  CommentItem({Key?key,required this.videoID,required this.uid}): super(key: key);
  final String videoID;
  final String uid;

  CollectionReference videos = FirebaseFirestore.instance.collection('videos');

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

  TextEditingController _textEditingController =
  TextEditingController(); // Khai báo ở cấp độ lớp

  Future<void> _showUpdateDialog(
      BuildContext context, String indexT, String videoID) async {
    _textEditingController.text = ''; // Đặt giá trị ban đầu cho TextField
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Cập nhật bình luận"),
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
                CommentService.update(videoID: videoID, commentId: indexT, comment: comment);
                print(indexT);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showBottomSheetoooo(
      BuildContext context, String videoID, String idComment) {
    TextEditingController _textEditingControllerup = TextEditingController();
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
                controller: _textEditingControllerup,
                decoration: InputDecoration(
                  hintText: 'Nhập nội dung',
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  String comment = _textEditingControllerup.text;
                  CommentService.RepComment(context: context,message: comment, uid: uid, videoID: videoID, idComment: idComment);
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
                                                  _showDialog(context, indexite,);
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
                                // RepCM(context, item['id'])
                                RepCMW(videoID: videoID, itemID: item['id'])
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
                      CommentService.sendComment(context: context, message: _textEditingController.text, uid: uid, videoID: videoID);
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
  }
}
