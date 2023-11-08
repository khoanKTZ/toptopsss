import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiktok_app_poly/database/services/comment_service.dart';
import 'package:tiktok_app_poly/provider/comment_model.dart';
import 'package:tiktok_app_poly/views/widgets/colors.dart';
import 'package:path_provider/path_provider.dart';

class TextFComment extends StatelessWidget {
  TextFComment(
      {Key? key,
      required this.check,
      required this.videoID,
      required this.uid,
      required this.commentID})
      : super(key: key);
  String check = '';
  String uid, videoID, commentID;

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    return Consumer<Cmodel>(builder: (context, value, child) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 40,
          child: TextField(
            controller: controller,
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
                  value.checkComment(check);
                  if (value.isSend) {
                    CommentService.sendComment(
                        context: context,
                        message: controller.text,
                        uid: uid,
                        videoID: videoID);
                    controller.clear();
                  }
                  if (value.isRepCM) {
                    CommentService.RepComment(
                        message: controller.text,
                        uid: uid,
                        videoID: videoID,
                        idComment: commentID);
                    controller.clear();
                  }
                },
                icon: Icon(
                  Icons.send_rounded,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
