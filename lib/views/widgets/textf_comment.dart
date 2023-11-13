import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiktok_app_poly/database/services/video_service.dart';
import 'package:tiktok_app_poly/provider/comment_model.dart';
import 'package:tiktok_app_poly/views/widgets/colors.dart';

class TextFComment extends StatefulWidget {
  const TextFComment({
    Key? key,
    required this.check,
    required this.videoID,
    required this.uid,
    required this.commentID,
    required this.vauleUp,
  }) : super(key: key);
  final String check;
  final String uid, videoID, commentID,vauleUp;

  @override
  _TextFCommentState createState() => _TextFCommentState();
}

class _TextFCommentState extends State<TextFComment> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<Cmodel>(builder: (context, value, child) {
      value.checkComment(widget.check);
      if(value.isUp){
        controller.text = widget.vauleUp;
      }
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: TextFormField(
                controller: controller,
                maxLength: 150,
                textAlignVertical: TextAlignVertical.center,
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
                      if (value.isSend) {
                        VideoServices.sendComment(
                          context: context,
                          message: controller.text,
                          uid: widget.uid,
                          videoID: widget.videoID,
                        );
                        controller.text = "";
                      }
                      if (value.isRepCM) {
                        VideoServices.RepComment(
                          message: controller.text,
                          uid: widget.uid,
                          videoID: widget.videoID,
                          idComment: widget.commentID,
                        );
                        controller.text = "";
                        Navigator.of(context).pop();
                      }
                      if (value.isUp) {
                        VideoServices.update(
                            videoID: widget.videoID,
                            commentId: widget.commentID,
                            comment: controller.text);
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      }
                    },
                    icon: const Icon(
                      Icons.send_rounded,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
