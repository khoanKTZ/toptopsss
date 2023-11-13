import 'package:flutter/material.dart';
import 'package:tiktok_app_poly/database/models/video_model.dart';
import 'package:tiktok_app_poly/database/services/shearch_service.dart';
import 'package:tiktok_app_poly/views/pages/home/shearch/grildview_item.dart';

class ShearchVideo extends StatefulWidget {
  const ShearchVideo({Key? key}) : super(key: key);

  @override
  State<ShearchVideo> createState() => _ShearchVideoState();
}

class _ShearchVideoState extends State<ShearchVideo> {
  String searchQuery = '';
  List<Video> searchResults = [];
  String avatar = '';
  late final Video video;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Tìm kiếm...',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    if (searchQuery.isNotEmpty) {
                      SearchService()
                          .searchVideosByCaption(searchQuery)
                          .listen((videos) {
                        setState(() {
                          searchResults = videos;
                          if (searchResults.isEmpty) {
                            // Hiển thị thông báo nếu không tìm thấy video
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Không tìm thấy video'),
                                  content: Text(
                                      'Không có video nào trùng khớp với từ khóa.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        });
                      });
                    } else {
                      // Hiển thị thông báo nếu ô tìm kiếm trống
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Chưa nhập'),
                            content: Text('Vui lòng nhập từ khóa để tìm kiếm.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: const Text(
                    'search',
                    style: TextStyle(fontSize: 20, color: Colors.pink),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: Container(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20.0, bottom: 10.0),
                    child: searchResults.isEmpty
                        ? Center(
                            child: Text(
                              'Không tìm thấy video',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.pink,
                              ),
                            ),
                          )
                        : GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 20.0,
                              mainAxisSpacing: 50.0,
                            ),
                            itemCount: searchResults.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: EdgeInsets.all(8.0),
                                child: GridTile(
                                  child: LoadGridView(
                                    video: searchResults[index],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
