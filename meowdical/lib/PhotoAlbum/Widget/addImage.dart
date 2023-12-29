import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class AddButton extends StatefulWidget {
  @override
  _AddButton createState() => _AddButton();
}

class _AddButton extends State<AddButton> {
  PlatformFile? pickedFile;
  UploadTask? uploadTask;

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    setState(() {
      pickedFile = result.files.first;
    });
  }

  Future uploadFile() async {
    final path = 'files/${pickedFile!.name}';
    final file = File(pickedFile!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    setState(() {
      uploadTask = ref.putFile(file);
    });

    final snapshot = await uploadTask!.whenComplete(() {});

    final urlDownload = await snapshot.ref.getDownloadURL();
    print('Download-Link: $urlDownload');

    setState(() {
      pickedFile = null;
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
                  color: Colors.greenAccent,
                  child: Image.file(
                    File(pickedFile!.path!),
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
            TextButton(
              onPressed: selectFile,
              child: Text('Select Image'),
            ),
            TextButton(
              onPressed: uploadFile,
              child: Text('Upload Image'),
            ),
            const SizedBox(height: 20),
            builProgress(),
          ],
        )),
      );

  Widget builProgress() => StreamBuilder<TaskSnapshot>(
      stream: uploadTask?.snapshotEvents,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;
          double progress = data.bytesTransferred / data.totalBytes;

          return SizedBox(
              height: 50,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey,
                    color: Colors.greenAccent,
                  ),
                  Center(
                      child: Text(
                    '${(100 * progress).toStringAsFixed(2)} %',
                    style: const TextStyle(color: Colors.white),
                  ))
                ],
              ));
        } else {
          return const SizedBox(height: 50);
        }
      });
}
