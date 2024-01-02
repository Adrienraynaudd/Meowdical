import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import 'package:meowdical/calendar/model/Event.dart';
import 'package:meowdical/calendar/service/Calendar_Controller.dart';

class Edit_event extends StatelessWidget {
  TextEditingController _eventController = TextEditingController();
  TextEditingController _timeinput = TextEditingController();
  Function setState;
  late DateTime _selectedDay;
  Event? event;

  Edit_event(this.setState, this._selectedDay, this.event);

  @override
  Widget build(BuildContext context) {
    Calendar_Controleur calendatController = Calendar_Controleur();

    if (event != null) {
      _eventController.text = event!.title;
      _timeinput.text = event!.time;
    }

    return AlertDialog(
      scrollable: true,
      title: const Text('Add Event'),
      content: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            TextFormField(
              controller: _eventController,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Event Name',
              ),
            ),
            TextField(
              controller: _timeinput, //editing controller of this TextField
              decoration: const InputDecoration(
                  icon: Icon(Icons.timer), //icon of text field
                  labelText: "Enter Time" //label text of field
                  ),
              readOnly:
                  true, //set it true, so that user will not able to edit text
              onTap: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  // wait for time picker popup
                  context: context,
                  initialTime: TimeOfDay.now(),
                );

                if (pickedTime != null) {
                  DateTime now = DateTime.now();
                  DateTime parsedTime = DateTime(now.year, now.month, now.day,
                      pickedTime.hour, pickedTime.minute);
                  // DateTime parsedTime = DateFormat.jm().parse(pickedTime.format(context).toString());
                  //converting to DateTime so that we can further format on different pattern.
                  String formattedTime = DateFormat('HH:mm').format(parsedTime);
                  //DateFormat() is from intl package, you can format the time on any pattern you need.

                  setState(() {
                    _timeinput.text =
                        formattedTime; //set the value of text field.
                  });
                } else {
                  print("Time is not selected");
                }
              },
            )
          ])),
      actions: [
        ElevatedButton(
            onPressed: () {
              if (event == null) {
                Event event = Event(
                    title: _eventController.text,
                    uid: FirebaseAuth.instance.currentUser!.uid,
                    time: _timeinput.text);
                Navigator.of(context).pop();
                _eventController.clear();
                _timeinput.clear();
                calendatController.addEvent(event, _selectedDay);
              }
              else {
                event!.title = _eventController.text;
                event!.time = _timeinput.text;
                calendatController.updateEvent(event!, _selectedDay);
                Navigator.of(context).pop();
              }
            },
            child: Text('Save')),
      ],
    );
  }
}
