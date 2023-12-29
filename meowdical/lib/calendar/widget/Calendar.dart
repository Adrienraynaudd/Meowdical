import 'dart:math';

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:collection';

import '../model/Event.dart';
import '../service/Calendar_Controller.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  late CalendarFormat _calendarFormat;
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  TextEditingController _eventController = TextEditingController();
  Map<DateTime, List<Event>> events = {};
  late final ValueNotifier<List<Event>> _selectedEvents;

  @override
  void initState() {
    super.initState();
    _calendarFormat = CalendarFormat.month;
    _focusedDay = DateTime.now();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay));
  }

  List<Event> _getEventsForDay(DateTime day) {
    return events[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    Calendar_Controleur calendatController = Calendar_Controleur();

    return Scaffold(
        body: Center(
            child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                if (!isSameDay(_selectedDay, selectedDay)) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                    _selectedEvents.value = _getEventsForDay(selectedDay);
                  });
                }
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              locale: 'en_US',
              eventLoader: _getEventsForDay,
            ),
            SizedBox(
              height: 8.0,
            ),
            Expanded(
                child: StreamBuilder(
                    stream: calendatController.getEvents().asStream(),
                    builder: (BuildContext context,
                        AsyncSnapshot<Map<DateTime, List<Event>>> snapshot) {
                      if (snapshot.hasError) {
                        return const Text('Something went wrong');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text("Loading");
                      }

                      events = snapshot.data!;
                      _selectedEvents.value = _getEventsForDay(_selectedDay);
                      return ValueListenableBuilder<List<Event>>(
                          valueListenable: _selectedEvents,
                          builder: (context, value, _) {
                            return ListView.builder(
                                itemCount: value.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 12.0, vertical: 4.0),
                                    decoration: BoxDecoration(
                                      border: Border.all(),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    child: ListTile(
                                      title: Text(value[index].title),
                                    ),
                                  );
                                });
                          });
                    }))

            //     ListView(
            //       children: snapshot.data!.docs.map((DocumentSnapshot document) {
            //         Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
            //         return NoteWidget(
            //           titre: data['title'],
            //           description: data['content'],
            //           id: document.id,
            //           image_link : data['image'],
            //           reload: () {
            //             setState(() {});
            //           },
            //         );
            //       }).toList(),
            //     );
            //   },
            // );
            // child: ValueListenableBuilder<List<Event>>(
            //     valueListenable: _selectedEvents,
            //     builder: (context, value, _) {
            //       return ListView.builder(
            //           itemCount: value.length,
            //           itemBuilder: (context, index) {
            //             return Container(
            //               margin: const EdgeInsets.symmetric(
            //                   horizontal: 12.0, vertical: 4.0),
            //               decoration: BoxDecoration(
            //                 border: Border.all(),
            //                 borderRadius: BorderRadius.circular(12.0),
            //               ),
            //               child: ListTile(
            //                 title: Text(value[index].title),
            //               ),
            //             );
            //           });
            //     }))
          ],
        )),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        scrollable: true,
                        title: const Text('Add Event'),
                        content: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _eventController,
                            autofocus: true,
                            decoration: const InputDecoration(
                              labelText: 'Event Name',
                            ),
                          ),
                        ),
                        actions: [
                          ElevatedButton(
                              onPressed: () {
                                Event event =
                                    Event(title: _eventController.text);
                                calendatController.addEvent(
                                    event, _selectedDay);
                                Navigator.of(context).pop();
                                _eventController.clear();
                              },
                              child: Text('Save')),
                        ],
                      ));
            }));
  }
}
