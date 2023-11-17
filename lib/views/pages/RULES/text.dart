import 'package:flutter/material.dart';

class TestAnimation extends StatefulWidget {
  const TestAnimation({Key? key}) : super(key: key);

  @override
  State<TestAnimation> createState() => _TestAnimationState();
}

class _TestAnimationState extends State<TestAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration:
          Duration(seconds: 5), // Thay đổi thời gian để hiệu ứng chạy chậm
    );

    _offsetAnimation = Tween<Offset>(
      begin: Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.linear, // Sử dụng Curves.linear để hiệu ứng chạy liên tục
    ));

    _animationController.repeat(); // Lặp lại hiệu ứng
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đây là trang TestAnimation'),
      ),
      body: Column(
        children: [
          SizedBox(height: 100),
          Center(
            child: SlideTransition(
              position: _offsetAnimation,
              child: Text(
                'kHOAN BIẾTBATTTTTTTTTTTTTTT',
                style: TextStyle(fontSize: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
