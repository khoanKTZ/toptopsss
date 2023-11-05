import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CommentList extends StatefulWidget {
  @override
  _CommentListState createState() => _CommentListState();
}

class _CommentListState extends State<CommentList> {
  List<DocumentSnapshot> comments = [];
  int displayedComments = 5;
  bool showLoadMoreButton = false;

  @override
  void initState() {}

  void loadMoreComments() {
    setState(() {
      displayedComments >= 5;
      if (displayedComments >= comments.length) {
        showLoadMoreButton = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('kHOANNNNNN'),
      ),
      body: ListView.builder(
        itemCount: displayedComments,
        itemBuilder: (BuildContext context, int index) {
          if (index >= 5) {
            return Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Column(
                children: [
                  Text('Xem thêm bình luận'),
                ],
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Column(
                children: [
                  Text('kHOAN VVVVV ${index + 1}'),
                  Text('kHOAN VVVVV'),
                  Text('kHOAN VVVVV'),
                  Text('kHOAN VVVVV'),
                  Text('kHOAN VVVVV'),
                  Text('kHOAN VVVVV'),
                  Text('kHOAN VVVVV'),
                  Text('kHOAN VVVVV'),
                  Text('kHOAN VVVVV'),
                  Text('kHOAN VVVVV'),
                  Text('kHOAN VVVVV'),
                  Text('kHOAN VVVVV'),
                  Text('kHOAN VVVVV'),
                  Text('kHOAN VVVVV'),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
