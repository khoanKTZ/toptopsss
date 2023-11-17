import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tiktok_app_poly/database/models/video_model.dart';

class SearchService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<String>> fetchCaptionsFromVideos() async {
    try {
      final querySnapshot = await _firestore.collection('videos').get();
      final captions = querySnapshot.docs.map((doc) {
        return doc.data()['caption'] as String;
      }).toList();
      return captions;
    } catch (e) {
      print('Error fetching data: $e');
      throw Exception('Failed to load captions from Firestore');
    }
  }

  // Stream<List<Video>> searchVideosByCaption(String query) {
  //   return _firestore
  //       .collection('videos')
  //       .where('caption', isGreaterThanOrEqualTo: query)
  //       .snapshots()
  //       .map((querySnapshot) {
  //     List<Video> videoList = [];
  //     querySnapshot.docs.forEach((doc) {
  //       videoList.add(Video.fromSnap(doc));
  //     });
  //     return videoList;
  //   });
  // }

  Stream<List<Video>> searchVideosByCaption(String query) {
    return _firestore
        .collection('videos')
        .where('caption', isGreaterThanOrEqualTo: query)
        .snapshots()
        .map((querySnapshot) {
      List<Video> videoList = [];
      querySnapshot.docs.forEach((doc) {
        videoList.add(Video.fromSnap(doc));
      });
      return videoList;
    });
  }

  Future<List<String>> getFollowingList() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    try {
      DocumentSnapshot docUser =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();
      Map<String, dynamic> data = docUser.data() as Map<String, dynamic>;
      List<String> idFollowing =
          data['following'] != null ? List<String>.from(data['following']) : [];
      return idFollowing;
    } catch (e) {
      print('Error fetching following list: $e');
      throw e;
    }
  }

  Future<String> getUserById(String uid) async {
    try {
      // ignore: unused_local_variable
      DocumentSnapshot docUser =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();
      return 'null';
    } catch (e) {
      print('Error fetching following list: $e');
      throw e;
    }
  }

  Stream<List<Video>> getVideosByCaption(String caption) {
    return _firestore
        .collection('videos')
        .where('caption', isEqualTo: caption)
        .snapshots()
        .map((querySnapshot) {
      List<Video> videoList = [];
      querySnapshot.docs.forEach((doc) {
        videoList.add(Video.fromSnap(doc));
      });
      return videoList;
    });
  }
}
