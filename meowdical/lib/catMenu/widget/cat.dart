import 'package:flutter/material.dart';
import 'package:tp_firebase/catProfile/widget/catProfile.dart';

class Cat extends StatelessWidget {
  Cat({super.key, required this.name, required this.catID});
  var name;
  var catID;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("$name"),
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => CatProfile(catID: catID)));
      },
    );
  }
}
