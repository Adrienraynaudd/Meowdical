import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:meowdical/catProfile/modele/Vaccine.dart';

CollectionReference cat = FirebaseFirestore.instance.collection('cat');

class dbRequest {
  var uid;
  void addCat(String name, String race, DateTime birthDate, bool isCastrated,
      bool isChipped, String medicalHistory, DateTime lastVisit) async {
    if (FirebaseAuth.instance.currentUser == null) {
      uid = "ahru";
    } else {
      uid = FirebaseAuth.instance.currentUser;
    }
    await cat.add({
      'catID': UniqueKey().toString(),
      'UID': uid,
      'birthDate': birthDate,
      'Castrated': isCastrated,
      'chip': isChipped,
      'lastVisit': lastVisit,
      'medicalHistory': medicalHistory,
      'name': name,
      'race': race,
      // 'image': image,
      // 'vaccine': null
    });
  }

  void delete(CollectionReference<Object?> collectionName, id) async {
    DocumentReference doc;
    await collectionName.where('id', isEqualTo: id).get().then((value) {
      doc = value.docs[0].reference;
      doc.delete().then(
            (doc) => print("Document deleted"),
            onError: (e) => print("Error updating document $e"),
          );
    });
  }

  void modifyCat(
      Int id,
      String name,
      String race,
      DateTime birthDate,
      Bool isCastrated,
      Bool isChipped,
      String medicalHistory,
      Map<String,dynamic> vaccine) async {
    DocumentReference doc;
    await cat.where('id', isEqualTo: id).get().then((value) {
      doc = value.docs[0].reference;
      doc
          .set({
            'UID': FirebaseAuth.instance.currentUser!.uid,
            'birthDate': birthDate,
            'Castrated': isCastrated,
            'chip': isChipped,
            'medicalHistory': medicalHistory,
            'name': name,
            'race': race,
            'vaccine': vaccine,
          }, SetOptions(merge: true))
          .timeout(const Duration(seconds: 3))
          .catchError((onError) {});
    });
  }
}
