import 'package:flutter/material.dart';
import 'package:tiktok_app_poly/views/pages/home/home_screen.dart';
import 'package:tiktok_app_poly/views/pages/home/user_page/Editprofileitem.dart';

import '../../../../../database/services/user_service.dart';

class EditProifilePage extends StatefulWidget {
  const EditProifilePage({super.key});
  @override
  State<EditProifilePage> createState() => _EditProifilePageState();
}

class _EditProifilePageState extends State<EditProifilePage> {
  bool CheckIcon = true;

  @override
  Widget build(BuildContext context) {
    TextStyle style = Theme.of(context)
        .textTheme
        .bodyText1!
        .copyWith(fontSize: 15, color: Colors.black);
    TextStyle styleLable = Theme.of(context).textTheme.bodyText1!.copyWith(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.black.withOpacity(0.6),
        );
    return FutureBuilder(
      future: UserService.getUserInfo(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //title
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          size: 15,
                        ),
                        onTap: () {
                          setState(() {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeScreen()),
                                (route) => false);
                          });
                        },
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 40,
                        alignment: Alignment.center,
                        child: Text(
                          "Edit profile",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(
                                  fontSize: 20,
                                  color:
                                      const Color.fromARGB(255, 246, 246, 246)),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 20),
                  child: Text(
                    "About you",
                    style: styleLable,
                  ),
                ),

                _editItemSelect(
                    style,
                    "${snapshot.data.get('fullName')}",
                    "Name",
                    Editprofileitem(
                      title: "Name",
                      Collums: "fullName",
                      valueText: "${snapshot.data.get('fullName')}",
                    )),

                _editItemSelect(
                    style,
                    "${snapshot.data.get('email')}",
                    "Email",
                    Editprofileitem(
                      title: "Email",
                      Collums: "email",
                      valueText: "${snapshot.data.get('email')}",
                    )),

                _editItemSelect(
                    style,
                    snapshot.data.get('age').toString() == "None"
                        ? ""
                        : "${snapshot.data.get('age')}",
                    "Age",
                    Editprofileitem(
                      title: "Age",
                      Collums: "age",
                      valueText: snapshot.data.get('age').toString() == "None"
                          ? ""
                          : "${snapshot.data.get('age')}",
                    )),
                _editItemSelect(
                    style,
                    snapshot.data.get('phone').toString() == "None"
                        ? ""
                        : "${snapshot.data.get('phone')}",
                    "Phone",
                    Editprofileitem(
                      title: "Phone",
                      Collums: "phone",
                      valueText: snapshot.data.get('phone').toString() == "None"
                          ? ""
                          : "${snapshot.data.get('phone')}",
                    )),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "https://www.tiktok.com/@khoanbb",
                        style: style,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Icon(
                        Icons.copy_rounded,
                        size: 15,
                      ),
                    ],
                  ),
                ), // Link tiktok đang phát triển
                _editItemSelect(
                    style,
                    snapshot.data.get('gender').toString() == "None"
                        ? ""
                        : "${snapshot.data.get('gender')}",
                    "Gender",
                    Editprofileitem(
                        title: "Gender",
                        Collums: "gender",
                        valueText:
                            snapshot.data.get('gender').toString() == "None"
                                ? ""
                                : "${snapshot.data.get('gender')}")),
                SizedBox(
                  height: 20,
                ),
                Divider(color: Colors.grey.withOpacity(0.5)),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 20),
                  child: Text(
                    "Social",
                    style: styleLable,
                  ),
                ),
                _editItemSelect(
                    style,
                    "Add Instagram",
                    "Instagram",
                    Scaffold(
                      appBar: AppBar(),
                      body: Container(
                        alignment: Alignment.center,
                        child: Text("đang phát triển"),
                      ),
                    )),
                _editItemSelect(
                    style,
                    "Add Youtobe",
                    "Youtobe",
                    Scaffold(
                      appBar: AppBar(),
                      body: Container(
                        alignment: Alignment.center,
                        child: Text("đang phát triển"),
                      ),
                    )),
                _editItemSelect(
                    style,
                    "Add Twitter",
                    "Twitter",
                    Scaffold(
                      appBar: AppBar(),
                      body: Container(
                        alignment: Alignment.center,
                        child: Text("đang phát triển"),
                      ),
                    )),
                SizedBox(
                  height: 20,
                ),
                Divider(
                  color: Colors.grey.withOpacity(0.5),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 20),
                  child: Text(
                    "Change display order",
                    style: styleLable,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Your orders",
                        style: style,
                      ),
                      Icon(
                        Icons.menu,
                        size: 15,
                      )
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Add yours",
                        style: style,
                      ),
                      Icon(
                        Icons.menu,
                        size: 15,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  _editItemSelect(TextStyle style, String value, String itemName, Widget mh) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(bottom: 15),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent, elevation: 0),
        onPressed: () {
          if (itemName != "Email") {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => mh));
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "$itemName",
              style: style,
            ),
            Row(
              children: [
                Text(
                  "$value",
                  style: style,
                ),
                Icon(
                  Icons.navigate_next,
                  color: Colors.black.withOpacity(0.5),
                  size: 15,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
