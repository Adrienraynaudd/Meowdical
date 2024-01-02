import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:meowdical/PhotoAlbum/Service/photoController.dart';
import 'package:meowdical/PhotoAlbum/Model/modelPhoto.dart';

class ShowImage extends StatefulWidget {
  @override
  _ShowImage createState() => _ShowImage();
}

class _ShowImage extends State<ShowImage> {
  late Future<List<ModelPhoto>> futureList;
  final PageController _controller = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    futureList = PhotoController().recuperationModel();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ModelPhoto>>(
      future: futureList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final list = snapshot.data!;
          return PageView.builder(
            controller: _controller,
            itemCount: list.length,
            itemBuilder: (context, index) {
              return Center(
                child: Column(
                  children: [
                    Expanded(
                      child: Image.network(list[index].lienPhoto),
                    ),
                    Text(list[index].nomDeLaPhoto),
                    Text(list[index].description),
                    ElevatedButton(
                      child: Text('Next'),
                      onPressed: () {
                        _controller.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        );
                      },
                    ),
                    ElevatedButton(
                      child: Text('Previous'),
                      onPressed: () {
                        _controller.previousPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        );
                      },


                    )
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }
}
