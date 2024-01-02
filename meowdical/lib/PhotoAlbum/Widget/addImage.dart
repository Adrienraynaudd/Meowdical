import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import 'package:meowdical/PhotoAlbum/Model/modelPhoto.dart';
import 'package:meowdical/PhotoAlbum/Service/photoController.dart';

class AddButton extends StatefulWidget {
  @override
  _AddButton createState() => _AddButton();
}

class _AddButton extends State<AddButton> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  PlatformFile? pickedFile;
  UploadTask? uploadTask;

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    setState(() {
      pickedFile = result.files.first;
    });
  }

  Future<String> uploadFile() async {
    if (pickedFile == null) return '';

    // final Uint8List fileBytes = await file.readAsBytes();

    final path = 'files/${pickedFile!.name}';
    // final file = File(pickedFile!.path!);

    final file = pickedFile!.bytes!;

    final ref = FirebaseStorage.instance.ref().child(path);
    setState(() {
      uploadTask = ref.putData(file);
    });

    final snapshot = await uploadTask!.whenComplete(() {});

    final urlDownload = await snapshot.ref.getDownloadURL();

    print('Download-Link: $urlDownload');

    // print("hello");

    setState(() {
      pickedFile = null;
    });

    return urlDownload;
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
                  child: Image.memory(
                    pickedFile!.bytes!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
            TextButton(
              onPressed: selectFile,
              child: Text('Select Image'),
            ),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Nom de la photo',
              ),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Description',
              ),
            ),
            
            TextButton(
              onPressed: () async {
                final url = await uploadFile();

                final photo = ModelPhoto(
                  nomDeLaPhoto : titleController.text ,
                  description : descriptionController.text,
                  lienPhoto : url,
                  // uid : ,
                );

                await PhotoController().upload(photo);

                Navigator.pop(context);
              },
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
