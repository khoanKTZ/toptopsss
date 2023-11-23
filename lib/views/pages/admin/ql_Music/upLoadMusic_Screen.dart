import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiktok_app_poly/database/services/storage_services.dart';
import 'package:tiktok_app_poly/views/widgets/text.dart';
import 'package:tiktok_app_poly/views/widgets/textformfield.dart';

import '../../../../provider/loading_model.dart';
import '../../../widgets/video_player_item.dart';

class UploadMusicScreen extends StatelessWidget {
  final List<int>? audioData;

  UploadMusicScreen({Key? key, this.audioData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Music'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (audioData != null)
              Text('Audio Data Length: ${audioData!.length} bytes'),
          ],
        ),
      ),
    );
  }
}
