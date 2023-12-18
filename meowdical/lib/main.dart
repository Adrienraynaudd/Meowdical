import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'Geoloc/widgets/geoloc_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Notes Application with Firebase'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Function to navigate to the authentication page
  void _navigateToAuthPage() {
    Navigator.pushNamed(context, '/auth');
  }

  void _navigateToGeolocPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GeolocPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          // Show login icon if the user is not logged in
          if (FirebaseAuth.instance.currentUser == null)
            IconButton(
              icon: Icon(Icons.login),
              onPressed: _navigateToAuthPage,
            ),
          // Show user icon if the user is not logged in
          if (FirebaseAuth.instance.currentUser != null)
            IconButton(
              icon: Icon(Icons.gps_fixed),
              onPressed: _navigateToGeolocPage,
            ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Show a welcome message and user details if logged in
            if (FirebaseAuth.instance.currentUser != null)
              Column(
                children: [
                  CircleAvatar(
                    // You can display user's profile picture here
                    radius: 40,
                    backgroundColor: Colors.grey[300],
                    // Placeholder or user's profile picture
                    child: Icon(Icons.person, size: 60, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Welcome ${FirebaseAuth.instance.currentUser!.displayName ?? ''}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Email: ${FirebaseAuth.instance.currentUser!.email ?? ''}',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            if (FirebaseAuth.instance.currentUser == null)
              Text(
                'Log in to access notes',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
