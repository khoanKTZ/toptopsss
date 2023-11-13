import 'package:flutter/foundation.dart';
import 'package:tiktok_app_poly/database/models/video_model.dart';

class VideoProvider with ChangeNotifier {
  List<Video> _videos = [];

  List<Video> get videos => _videos;
  List<Video> searchVideos(String query) {
    return _videos
        .where((video) =>
            video.caption.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  void updateVideos(List<Video> newVideos) {
    _videos = newVideos;
    notifyListeners();
  }
}
