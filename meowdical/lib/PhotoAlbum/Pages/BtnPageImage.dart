import 'package:flutter/material.dart';
import 'package:meowdical/PhotoAlbum/Pages/AddPicPage.dart';
import 'package:meowdical/PhotoAlbum/Pages/ShowImagesPage.dart';



class BtnImagesPages extends StatefulWidget {
  @override
  _BtnImagesPagesState createState() => _BtnImagesPagesState();
}

class _BtnImagesPagesState extends State<BtnImagesPages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Album'),
      ),
      body: Center(
        child: Column(

          children: [

            const Padding(padding: EdgeInsets.all(30)),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddPic()),
                );
              },
              child: const Text('Add Image'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ShowImages()),
                );
              },
              child: const Text('Show Images'),
            ),
          ],
        ),
      ),

      

    );
  }
}


