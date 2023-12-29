import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';


class UploadButton extends StatefulWidget {
  
  @override
  _UploadButton createState() => _UploadButton();
}

class _UploadButton extends State<UploadButton> {
  PlatformFile? pickedFile;

  Future uploadFile() async {
    final path = 'files/${pickedFile!.name}';
    final file = File(pickedFile!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    ref.putFile(file);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
            child: Column(
          children: [
            const Padding(padding: EdgeInsets.all(10)),
            TextButton(
              onPressed: uploadFile,
              child: Text('Upload Image'),
            ),
            const Padding(padding: EdgeInsets.all(30)),
          ],
        )),
      );
}
