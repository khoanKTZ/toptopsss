import 'package:cloud_firestore/cloud_firestore.dart';

class Music {
  late String songName;
  late String profilePhoto;
  late String videoUrl;

  Music({
    required this.songName,
    required this.profilePhoto,
    required this.videoUrl,
  });

  Map<String, dynamic> toJson() => {
        "SongName": songName,
        "profilePhoto": profilePhoto,
        "videoUrl": videoUrl,
      };

  static Music fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Music(
      songName: snapshot['SongName'],
      videoUrl: snapshot['videoUrl'],
      profilePhoto: snapshot['profilePhoto'],
    );
  }
}
