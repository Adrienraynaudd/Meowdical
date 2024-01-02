import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meowdical/catMenu/widget/cat.dart';
import 'package:meowdical/catMenu/widget/catAdder.dart';
import 'package:meowdical/catProfile/service/dbRequest.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CatMenu extends StatefulWidget {
  const CatMenu({super.key});
  @override
  CatMenuState createState() => CatMenuState();
}

class CatMenuState extends State<CatMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cat"),
      ),
      body: Center(
        child: StreamBuilder<QuerySnapshot>(
          stream: cat
              .where("UID",
                  isEqualTo: "ahru" /*FirebaseAuth.instance.currentUser!.uid*/)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            return Container(
                child: ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return Container(
                    child: Cat(name: data["name"], catID: data["catID"]));
              }).toList(),
            ));
          },
        ),
      ),
      floatingActionButton: CatAdder(),
    );
  }
}
