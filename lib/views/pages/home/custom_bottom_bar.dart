import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tiktok_app_poly/provider/notifi_model_check.dart';
import 'package:tiktok_app_poly/views/pages/home/camera_page/camera_screen.dart';

// ignore: must_be_immutable
class CustomAnimatedBottomBar extends StatefulWidget {
  CustomAnimatedBottomBar({
    Key? key,
    required this.selectedScreenIndex,
    required this.onItemTap,
  }) : super(key: key);

  final int selectedScreenIndex;
  final Function onItemTap;

  @override
  State<CustomAnimatedBottomBar> createState() =>
      _CustomAnimatedBottomBarState();
}

class _CustomAnimatedBottomBarState extends State<CustomAnimatedBottomBar> {
  bool _isNavigating = false;

  // Flag to control navigation
  @override
  Widget build(BuildContext context) {
    var style = Theme.of(context)
        .textTheme
        .bodyMedium!
        .copyWith(fontSize: 11, fontWeight: FontWeight.w600);
    var barHeight = MediaQuery.of(context).size.height * 0.06;
    return BottomAppBar(
      child: Container(
        color: widget.selectedScreenIndex == 0 ? Colors.black : Colors.white,
        height: barHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _bottomNavBarItem(0, "Home", style, 'home'),
            _bottomNavBarItem(1, "Chat", style, 'message'),
            _addVideoNavItem(context, barHeight),
            _bottomNavBarItem(2, "Notification", style, 'notification'),
            _bottomNavBarItem(3, "Profile", style, 'profile'),
          ],
        ),
      ),
    );
  }

  _bottomNavBarItem(
      int index, String label, TextStyle textStyle, String iconName) {
    bool isSelected = widget.selectedScreenIndex == index;
    Color itemColor = isSelected ? Colors.black : Colors.grey;
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    int count = 0;
    if (isSelected && widget.selectedScreenIndex == 0) {
      itemColor = Colors.white;
    }
    CollectionReference notifi =
        FirebaseFirestore.instance.collection('notifications');
    return ChangeNotifierProvider<NotifiCheck>(
      create: (context) => NotifiCheck(),
      child: InkWell(
        onTap: () => {widget.onItemTap(index)},
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(children: [
              SizedBox(
                width: 20,
                height: 20,
                child: SvgPicture.asset(
                  "assets/icons/${isSelected ? '${iconName}_filled' : iconName}.svg",
                  color: itemColor,
                ),
              ),
              if (label == 'Notification')
                Consumer<NotifiCheck>(
                  builder: (context, value, child) {
                    return StreamBuilder<QuerySnapshot>(
                        stream: notifi.where('uid', whereIn: [uid]).snapshots(),
                        builder: (BuildContextcontext,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          for (int i = 0; i < snapshot.data!.docs.length; i++) {
                            final item = snapshot.data!.docs[i];
                            if (item['check'] == 0) {
                              count += 1;
                            }
                          }
                          if (snapshot.hasData) {
                            if(count == 0){
                              value.changerNoti(false);
                            }else{
                              value.changerNoti(true);
                            }
                            return value.isNoti ? Positioned(
                                top: 1,
                                right: 1,
                                child: Icon(
                                  Icons.circle_sharp,
                                  color: Colors.red,
                                  size: 10,
                                )) : Container();
                          } else {
                            return Container();
                          }
                        });
                  },
                )
            ]),
            const SizedBox(
              height: 3,
            ),
            Text(
              label,
              style: textStyle.copyWith(color: itemColor, fontSize: 10),
            )
          ],
        ),
      ),
    );
  }

  _addVideoNavItem(BuildContext context, double barHeight) {
    return InkWell(
      onTap: () {
        if (_isNavigating) {
          print("Navigation is already in progress.");
          return; // Avoid triggering navigation if another navigation is ongoing.
        }

        _isNavigating =
            true; // Set the flag to indicate navigation is in progress
        Navigator.of(context).push(MaterialPageRoute(builder: (_) {
          return const CameraScreen();
        })).then((_) {
          _isNavigating = false; // Reset the flag after navigation is complete
        });
      },
      child: Container(
        height: barHeight - 15,
        width: 48,
        decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.blueAccent, Colors.redAccent],
            ),
            borderRadius: BorderRadius.circular(8)),
        child: Center(
          child: Container(
            width: 40,
            height: barHeight - 15,
            decoration: BoxDecoration(
                color: widget.selectedScreenIndex == 0
                    ? Colors.white
                    : Colors.black,
                borderRadius: BorderRadius.circular(8)),
            child: Icon(
              Icons.add,
              color:
                  widget.selectedScreenIndex == 0 ? Colors.black : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
