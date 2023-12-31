import 'package:flutter/material.dart';
import '../Widget/addImage.dart';



class AddPic extends StatefulWidget {
  @override
  _AddPicState createState() => _AddPicState();
}

class _AddPicState extends State<AddPic> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Upload/select image'),
      ),
      body: Center(

        child: Column(
          children: [
            const Padding(padding: EdgeInsets.all(30)),
            Expanded(
              
             child :  AddButton()
            )
            
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Icon(Icons.arrow_back),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      )
      

    );
  }
}


