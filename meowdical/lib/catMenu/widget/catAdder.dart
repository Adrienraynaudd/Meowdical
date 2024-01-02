import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tp_firebase/catProfile/modele/Vaccine.dart';
import 'package:tp_firebase/catProfile/service/dbRequest.dart';

class CatAdder extends StatefulWidget {
  const CatAdder({super.key});
  @override
  CatAdderState createState() => CatAdderState();
}

class CatAdderState extends State<CatAdder> {
  final _nameController = TextEditingController();
  final _raceController = TextEditingController();
  final _birthDateController = TextEditingController();
  var _chipController = false;
  var _castratedController = false;
  final _lastVisitController = TextEditingController();
  final _historyController = TextEditingController();
  final _vaccinesController = TextEditingController();

  void reload() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        onPressed: () async => showDialog(
            context: context,
            builder: (BuildContext context) => StatefulBuilder(
                builder: ((context, setState) => AlertDialog(
                      title: const Text("Add your note"),
                      content: Column(children: [
                        TextField(
                          decoration: const InputDecoration(
                              hintText: "Name",
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green))),
                          controller: _nameController,
                        ),
                        TextField(
                          decoration: const InputDecoration(
                              hintText: "Race",
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green))),
                          controller: _raceController,
                        ),
                        TextField(
                          decoration: const InputDecoration(
                              hintText: "BirthDate",
                              filled: true,
                              prefixIcon: Icon(Icons.calendar_today),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green))),
                          controller: _birthDateController,
                          readOnly: true,
                          onTap: () => _selectDate(_birthDateController),
                        ),
                        Container(
                            child: Row(children: [
                          const Text("Has a chip"),
                          IconButton(
                              onPressed: () => setState(
                                  () => _chipController = !_chipController),
                              icon: Icon(_chipController == true
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank))
                        ])),
                        Container(
                            child: Row(children: [
                          const Text("Is castrated"),
                          IconButton(
                              onPressed: () => setState(() =>
                                  _castratedController = !_castratedController),
                              icon: Icon(_castratedController == true
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank))
                        ])),
                        TextField(
                          decoration: const InputDecoration(
                              hintText: "Last visit",
                              filled: true,
                              prefixIcon: Icon(Icons.calendar_today),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green))),
                          controller: _lastVisitController,
                          readOnly: true,
                          onTap: () => _selectDate(_lastVisitController),
                        ),
                        TextField(
                          decoration: const InputDecoration(
                              hintText: "Medical History",
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green))),
                          controller: _historyController,
                        ),
                        // TextField(
                        //   decoration:
                        //       const InputDecoration(hintText: "vaccine"),
                        //   controller: _vaccinesController,
                        // ),
                      ]),
                      actions: <Widget>[
                        TextButton(
                            onPressed: () => Navigator.pop(context, 'cancel'),
                            child: const Text('Cancel')),
                        TextButton(
                            onPressed: () => dbRequest().addCat(
                                _nameController.text,
                                _raceController.text,
                                DateTime.parse(_birthDateController.text),
                                _castratedController,
                                _chipController,
                                _historyController.text,
                                // _vaccinesController.text as List<Vaccine>,
                                DateTime.parse(_lastVisitController.text)),
                            child: const Text('Add')),
                      ],
                    )))),
        child: const Icon(Icons.add));
  }

  Future<void> _selectDate(TextEditingController controller) async {
    DateTime? _picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1950),
        lastDate: DateTime.now());
    if (_picked != null) {
      setState(() {
        controller.text = _picked.toString().split(" ")[0];
      });
    }
  }
}
