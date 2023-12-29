import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class SelectButton extends StatefulWidget {
  @override
  _SelectButton createState() => _SelectButton();
}

class _SelectButton extends State<SelectButton> {
  PlatformFile? pickedFile;

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;
    setState(() {
      pickedFile = result.files.first;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
            child: Column(
          children: [
            if (pickedFile != null)
              Expanded(
                child: Container(
                  child: Image.file(
                    File(pickedFile!.path!),
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            TextButton(
              onPressed: selectFile,
              child: Text('Select Image'),
            ),
          ],
        )),
      );
}
