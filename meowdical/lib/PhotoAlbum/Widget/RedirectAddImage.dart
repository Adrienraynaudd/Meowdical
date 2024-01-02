import 'package:flutter/material.dart';

class RedirectAddImage extends StatefulWidget {
  @override
  _RedirectAddImage createState() => _RedirectAddImage();
}

class _RedirectAddImage extends State<RedirectAddImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

