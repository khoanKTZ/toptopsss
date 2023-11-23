import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UpdateMusicPage extends StatefulWidget {
  UpdateMusicPage({Key?key,required this.videoID}): super(key: key);
  String videoID;
  @override
  State<UpdateMusicPage> createState() => _UpdateMusicPageState();
}

class _UpdateMusicPageState extends State<UpdateMusicPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          child: Column(
            children: [
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(onPressed: () {
                      Navigator.of(context).pop();
                    }, icon: Icon(CupertinoIcons.back)),
                    Text('top music',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: Colors.black.withOpacity(0.55))),
                    Icon(CupertinoIcons.music_albums),
                  ],
                ),
              ),
              Expanded(
                  child: StreamBuilder(
                stream: null,
                builder: (context, snapshot) {
                  return ListView.builder(
                    itemCount: 20,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('giá trị ${index + 1}',style: TextStyle(fontWeight: FontWeight.bold),),
                                Text('Mô tả của ${index + 1}'),
                              ],
                            ),
                            IconButton(
                                onPressed: () {}, icon: Icon(Icons.play_circle))
                          ],
                        ),
                      );
                    },
                  );
                },
              ))
            ],
          ),
        ));
  }
}
