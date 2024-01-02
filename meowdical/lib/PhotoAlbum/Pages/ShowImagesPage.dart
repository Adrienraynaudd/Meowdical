import 'package:flutter/material.dart';

import 'package:meowdical/PhotoAlbum/Widget/album.dart';
import 'package:meowdical/PhotoAlbum/Model/modelPhoto.dart';

class ShowImages extends StatefulWidget {
  @override
  _ShowImagesState createState() => _ShowImagesState();
}

class _ShowImagesState extends State<ShowImages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('ShowImages'),
      ),
      body: Column(
        children : [
          const Padding(padding: EdgeInsets.all(30)),
          Expanded(
            child: Container(
              height: 500,
              child: ShowImage(),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Go back!'),
          ),
        ],
      ),
    );
  }
}