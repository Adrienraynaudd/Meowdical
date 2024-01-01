import 'package:flutter/material.dart';
import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:meowdical/calendar/model/Event.dart';

class Calendar_Controleur {

  final CollectionReference eventsCollection = FirebaseFirestore.instance.collection('events');

  Stream<Map<DateTime, List<Event>>> getEvents() async* {
  await for (var querySnapshot in eventsCollection.where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid).snapshots()) {
    Map<DateTime, List<Event>> events = {};
    querySnapshot.docs.forEach((doc) {
      DateTime date = doc['date'].toDate();
      date = DateTime(date.year, date.month, date.day);
      if (events[date] == null) {
        events[date] = [];
      }
      events[date]!.add(Event(title: doc['title'], id: doc.id, uid: doc['uid'], time: doc['time']));
    });
    yield events;
  }
}

  Future<void> addEvent(Event event, DateTime date) async {
    await eventsCollection.add({
      'title': event.title,
      'uid': event.uid,
      'date': date,
      'time': event.time,
    });
  }

  Future<void> deleteEvent(Event event) async {
    await eventsCollection.doc(event.id).delete();
  }

  Future<void> updateEvent(Event event, DateTime date) async {
    await eventsCollection.doc(event.id).update({
      'title': event.title,
      'uid': event.uid,
      'date': date,
      'time': event.time,
    });
  }


}