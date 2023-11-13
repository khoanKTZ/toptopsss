import 'package:flutter/material.dart';
import 'package:tiktok_app_poly/database/models/video_model.dart';
import 'package:tiktok_app_poly/views/pages/home/user_page/video_page/video_profile_player_screen.dart';
import 'package:video_player/video_player.dart';

class LoadGridView extends StatefulWidget {
  final Video video;

  const LoadGridView({Key? key, required this.video}) : super(key: key);

  @override
  _LoadGridViewState createState() => _LoadGridViewState();
}

class _LoadGridViewState extends State<LoadGridView> {
  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.network(widget.video.videoUrl)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => VideoProfileScreen(
                    videoID: widget.video.id,
                  )),
        );
      },
      child: Container(
        color: Color.fromARGB(255, 0, 0, 0),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            if (_videoController.value.isInitialized)
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: AspectRatio(
                  aspectRatio: _videoController.value.aspectRatio,
                  child: VideoPlayer(_videoController),
                ),
              ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(8),
                color: Colors.black.withOpacity(0.5),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.favorite,
                          color: const Color.fromARGB(
                            255,
                            255,
                            255,
                            255,
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          '${widget.video.likes.length}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      widget.video.caption,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }
}
