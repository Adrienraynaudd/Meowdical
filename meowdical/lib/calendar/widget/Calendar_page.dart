import 'package:flutter/material.dart';

import 'package:meowdical/calendar/model/Event.dart';
import 'package:meowdical/calendar/service/Calendar_Controller.dart';
import 'Calendar.dart';

class Calendar_Page extends StatefulWidget {
  const Calendar_Page({Key? key}) : super(key: key);

  @override
  State<Calendar_Page> createState() => _Calendar_PageState();
}

class _Calendar_PageState extends State<Calendar_Page> {
  Map<DateTime, List<Event>> events = {};

  @override
  Widget build(BuildContext context) {
    Calendar_Controleur calendatController = Calendar_Controleur();
    return StreamBuilder(
        stream: calendatController.getEvents(),
        builder: (BuildContext context,
            AsyncSnapshot<Map<DateTime, List<Event>>> snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(
        title: const Text('Calendar'),
      ),
              body: const Text('Something went wrong'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Calendar'),
              ),
              body: const Center(
                child: CircularProgressIndicator(),
              ),
              
            );
          }
          events = snapshot.data!;
          return Calendar(events: events);
        });
  }
}
