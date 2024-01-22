import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class UploadMusicScreen extends StatefulWidget {
  final String audioFilePath;

  UploadMusicScreen({required this.audioFilePath});

  @override
  _UploadMusicScreenState createState() => _UploadMusicScreenState();
}

class _UploadMusicScreenState extends State<UploadMusicScreen> {
  late AudioPlayer audioPlayer;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
  }

  Future<void> _playAudio() async {
    try {
      final bytes = await http.readBytes(Uri.parse(widget.audioFilePath));
      final tempDir = await getTemporaryDirectory();
      final tempFilePath = '${tempDir.path}/temp_audio_file.mp3';
      final tempFile = File(tempFilePath);
      await tempFile.writeAsBytes(bytes);
      await audioPlayer.play(UrlSource(tempFilePath));
    } catch (e) {
      print('Lỗi khi phát âm thanhx2: $e');
    }
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload File Audio'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('File đã chọn: ${widget.audioFilePath.split('/').last}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _playAudio,
              child: Text('Nghe File Audio'),
            ),
          ],
        ),
      ),
    );
  }
}
