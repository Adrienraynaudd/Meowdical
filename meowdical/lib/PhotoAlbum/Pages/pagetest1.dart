import 'package:flutter/material.dart';


class PageTest1 extends StatefulWidget {
  @override
  _PageTest1State createState() => _PageTest1State();
}

class _PageTest1State extends State<PageTest1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('PageTest1'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Go back!'),
        ),
      ),
    );
  }
}