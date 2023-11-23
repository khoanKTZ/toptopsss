import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tiktok_app_poly/database/models/video_model.dart';
import 'package:tiktok_app_poly/database/services/video_service.dart';

class UpdateVideo extends StatefulWidget {
  UpdateVideo({Key? key,required this.id});
  String id;

  @override
  State<UpdateVideo> createState() => _UpdateVideoState();
}

class _UpdateVideoState extends State<UpdateVideo> {
  TextEditingController controllerCaption = TextEditingController();
  Future<void> fetchData() async {
    try {

    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  @override
  initState() {
    super.initState();
    fetchData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextFormField(
            controller: controllerCaption,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                  onPressed: () {
                    //xóa text
                    controllerCaption.text = "";
                  },
                  icon: Icon(Icons.cancel)),
            ),
          ),
          IconButton(onPressed: () {
            if(controllerCaption.text != ''){VideoServices.updateVideoFect(context, widget.id, 'caption', controllerCaption.text);
            Navigator.pop(context);}
          }, icon: Icon(Icons.update))
        ],
      ),
    );
  }
}
