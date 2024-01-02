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
  final _nameController = TextEditingController();
  final _dateController = TextEditingController();
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
                  // Container(
                  //   child: Row(children: [
                  //     Text("Vaccines : "),
                  //     Column(children: [
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
                      }), 
                  //     FloatingActionButton(onPressed: ()async => showDialog(context: context, builder: (BuildContext context) => AlertDialog(
                  //       title: const Text("Add a vaccine"),
                  //       content: Column(children: [
                  //         TextField(
                  //         decoration: const InputDecoration(
                  //             hintText: "Name",
                  //             filled: true,
                  //             enabledBorder: OutlineInputBorder(
                  //                 borderSide: BorderSide.none),
                  //             focusedBorder: OutlineInputBorder(
                  //                 borderSide: BorderSide(color: Colors.green))),
                  //         controller: _nameController,
                  //       ),TextField(
                  //         decoration: const InputDecoration(
                  //             hintText: "Vaccine date",
                  //             filled: true,
                  //             prefixIcon: Icon(Icons.calendar_today),
                  //             enabledBorder: OutlineInputBorder(
                  //                 borderSide: BorderSide.none),
                  //             focusedBorder: OutlineInputBorder(
                  //                 borderSide: BorderSide(color: Colors.green))),
                  //         controller: _dateController,
                  //         readOnly: true,
                  //         onTap: () => selectDate(_dateController),
                  //       ),
                  //       ]),
                  //       actions: <Widget>[
                  //       TextButton(
                  //           onPressed: () => Navigator.pop(context, 'cancel'),
                  //           child: const Text('Cancel')),
                  //       TextButton(
                  //           onPressed: () => setState(() {
                  //             Map<String, dynamic> vaccine = (_nameController.text, DateTime.parse(_dateController.text)) as Map<String, dynamic>;
                  //             dbRequest().modifyCat(widget.catID, data["name"], data["race"], data["birthDate"], data["isCastrated"], data["isChipped"], data["medicalHistory"], vaccine);
                  //           }),
                  //           child: const Text('Add vaccine')),
                  //     ],
                  //     )),child: const Icon(Icons.add))],)
                  //   ]),
                  // )
                  
                ]));
              })),
    );
  }
  // Future<void> selectDate(TextEditingController controller) async {
  //   DateTime? _picked = await showDatePicker(
  //       context: context,
  //       initialDate: DateTime.now(),
  //       firstDate: DateTime(1950),
  //       lastDate: DateTime.now());
  //   if (_picked != null) {
  //     setState(() {
  //       controller.text = _picked.toString().split(" ")[0];
  //     });
  //   }
  // }
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

// class CatVaccineDisplay extends StatelessWidget {
//   CatVaccineDisplay(
//       {super.key, required this.dataName, required this.dataContent});
//   var dataName;
//   var dataContent;
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Text("$dataName : ${dataContent}"),
//     )
//   }
// }
