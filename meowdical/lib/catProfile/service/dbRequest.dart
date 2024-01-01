import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tp_firebase/catProfile/modele/Vaccine.dart';

class dbRequest {
  void addCat(CollectionReference<Object?> collectionName, String name, String race,
  DateTime birthDate, Bool isCastrated, Bool isChipped, String medicalHistory, List<Vaccine> vaccines, DateTime lastVisit ) async {
    if (FirebaseAuth.instance.currentUser == null) return;
    await collectionName.add({
      'catID': UniqueKey().toString(),
      'UID': FirebaseAuth.instance.currentUser!.uid,
      'birthDate': birthDate,
      'Castrated': isCastrated,
      'chip': isChipped,
      'lastVisit' : lastVisit,
      'medicalHistory': medicalHistory,
      'name': name,
      'race': race,
      'vaccine': vaccines,
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

  void modifyCat(CollectionReference<Object?> collectionName, Int id, String name, String race,
  DateTime birthDate, Bool isCastrated, Bool isChipped, String medicalHistory, List<Vaccine> vaccines) async {
    DocumentReference doc;
    await collectionName.where('id', isEqualTo: id).get().then((value) {
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
            'vaccine': vaccines,
          }, SetOptions(merge: true))
          .timeout(const Duration(seconds: 3))
          .catchError((onError) {});
    });
  }
}

