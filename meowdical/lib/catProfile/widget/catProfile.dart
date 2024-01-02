import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tp_firebase/catProfile/service/dbRequest.dart';

class CatProfile extends StatefulWidget {
  CatProfile({super.key, required this.catID});
  var catID;
  @override
  CatProfileState createState() => CatProfileState();
}

class CatProfileState extends State<CatProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cat"),
      ),
      body: Center(
          child: StreamBuilder<QuerySnapshot>(
              stream: cat.where("catID", isEqualTo: widget.catID).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                Map<String, dynamic> data =
                    snapshot.data!.docs[0].data()! as Map<String, dynamic>;
                return Container(
                    child: Column(children: [
                  CatInfoDisplay(dataName: "name", dataContent: data["name"]),
                  CatInfoDisplay(dataName: "race", dataContent: data["race"]),
                  CatInfoDisplay(
                      dataName: "last visit",
                      dataContent: (data["lastVisit"] as Timestamp).toDate()),
                  CatInfoDisplay(
                      dataName: "has a chip",
                      dataContent: data["chip"] == true ? "yes" : "no"),
                  CatInfoDisplay(
                      dataName: "is castrated",
                      dataContent: data["castrated"] == true ? "yes" : "no"),
                  CatInfoDisplay(
                      dataName: "medical history",
                      dataContent: data["medicalHistory"]),
                  ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount:
                          (data["vaccine"] as Map<String, dynamic>).length,
                      itemBuilder: (context, index) {
                        var vaccineName =
                            (data["vaccine"] as Map<String, dynamic>)["name"];
                        var vaccineDate = ((data["vaccine"]
                                as Map<String, dynamic>)["date"] as Timestamp)
                            .toDate();
                        return CatInfoDisplay(
                            dataName: vaccineName, dataContent: vaccineDate);
                      })
                ]));
              })),
    );
  }
}

class CatInfoDisplay extends StatelessWidget {
  CatInfoDisplay(
      {super.key, required this.dataName, required this.dataContent});
  var dataName;
  var dataContent;
  @override
  Widget build(BuildContext context) {
    if (dataContent.runtimeType == DateTime) {
      dataContent = DateFormat('dd-MM-yyyy').format(dataContent);
    }
    return Container(
      child: Text("$dataName : ${dataContent.toString()}"),
    );
  }
}
