import 'package:flutter/material.dart';
import 'package:tiktok_app_poly/views/widgets/snackbar.dart';

import '../../../../../database/services/user_service.dart';

class Editprofileitem extends StatefulWidget {
  Editprofileitem(
      {Key? key,
      required this.title,
      required this.Collums,
      required this.valueText})
      : super(key: key);
  String title;
  String Collums;
  String valueText;

  @override
  State<Editprofileitem> createState() => _EditprofileitemState();
}

class _EditprofileitemState extends State<Editprofileitem> {
  final _editUserFormKey = GlobalKey<FormState>();

  doEdit(BuildContext context, TextEditingController controller,
      String collum) async {
    if (!controller.text.isEmpty) {
      if (controller.text == widget.valueText) {
        getSnackBar("thông báo", "trùng tên cũ: ${controller.text}", Colors.red)
            .show(context);
      } else {
        UserService.editUserFetch(
            context: context, collums: collum, values: controller.text);
      }
    } else {
      getSnackBar("thông báo", "không có dữ liệu", Colors.red).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController controller =
        TextEditingController(text: widget.valueText.toString());
    TextStyle _style = Theme.of(context).textTheme.bodyText1!.copyWith(
        fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black);
    TextStyle _stylebt = Theme.of(context)
        .textTheme
        .bodyText1!
        .copyWith(fontSize: 15, color: Colors.black);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    child: Text("cancel", style: _stylebt),
                  ),
                  Text(
                    widget.title,
                    style: _style,
                  ),
                  TextButton(
                    onPressed: () {
                      //lưu thông tin
                      doEdit(context, controller, widget.Collums);
                    },
                    child: Text(
                      "save",
                      style: _stylebt,
                    ),
                  ),
                ],
              ),
            ),
            TextFormField(
              controller: controller,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                    onPressed: () {
                      //xóa text
                      controller.text = "";
                    },
                    icon: Icon(Icons.cancel)),
              ),
            ),
            Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "mô tả chức năng edit thông tin",
                  style: TextStyle(
                      color: Colors.black.withOpacity(0.8), fontSize: 12),
                ))
          ],
        ),
      ),
    );
  }
}
