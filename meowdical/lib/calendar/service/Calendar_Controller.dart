import 'package:flutter/material.dart';
import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/Event.dart';

class Calendar_Controleur {

  Future<Map<DateTime, List<Event>>> getEvents() async {
    Map<DateTime, List<Event>> events = {};
    await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('events').get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if (events[doc['date'].toDate()] == null) {
          events[doc['date'].toDate()] = [];
        }
        events[doc['date'].toDate()]!.add(Event(title : doc['title'], id : doc.id));
      });
    });
    return events;
  }

  Future<void> addEvent(Event event, DateTime date) async {
    FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('events').add({
      'title': event.title,
      'date': date,
    });
  }

  Future<void> deleteEvent(Event event) async {
    FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('events').doc(event.id).delete();
  }

  Future<void> updateEvent(Event event, DateTime date) async {
    FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('events').doc(event.id).update({
      'title': event.title,
      'date': date,
    });
  }


}