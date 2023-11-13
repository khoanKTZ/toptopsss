import 'package:flutter/material.dart';

class Follower_Screen extends StatefulWidget {
  const Follower_Screen({super.key});

  @override
  State<Follower_Screen> createState() => _Follower_ScreenState();
}

class _Follower_ScreenState extends State<Follower_Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Follower'),
      ),
      body: Column(
        children: [
          Text('Trang follower'),
        ],
      ),
    );
  }
}
