import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'Auth/widgets/auth_page.dart' as Register;
import 'Auth/widgets/login_page.dart';
import 'Geoloc/widgets/geoloc_page.dart';
import 'Commu/widgets/Chat_Page.dart';
import 'calendar/widget/Calendar_Page.dart';
import 'PhotoAlbum/Pages/BtnPageImage.dart';
import 'catMenu/widget/catMenu.dart';

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
      onGenerateRoute: (settings) {
        return null;
      },
      title: 'Meowdical',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Meowdical'),
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
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Register.AuthPage()),
    );
  }

  // Function to navigate to the login page
  void _navigateToLoginPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  void _navigateToChatPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChatPage()),
    );
  }

  void _navigateToCalendarPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Calendar_Page()),
    );
  }

  void _navigateToCatMenuPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CatMenu()),
    );
  }

  // Function to sign out the user
  void _signOut() async {
    await FirebaseAuth.instance.signOut();
    setState(() {});
  }

  void _navigateToGeolocPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GeolocPage()),
    );
  }

  void _navigateToPhotoAlbumPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BtnImagesPages()),
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
          if (FirebaseAuth.instance.currentUser == null)
            IconButton(
              icon: Icon(Icons.person),
              onPressed: _navigateToLoginPage,
            ),
          // Show logout icon if the user is logged in
          if (FirebaseAuth.instance.currentUser != null)
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: _signOut,
            ),
          if (FirebaseAuth.instance.currentUser != null)
            IconButton(
              icon: Icon(Icons.menu),
              onPressed: _navigateToCatMenuPage,
            ),
          if (FirebaseAuth.instance.currentUser != null)
            IconButton(
              icon: Icon(Icons.gps_fixed),
              onPressed: _navigateToGeolocPage,
            ),
          if (FirebaseAuth.instance.currentUser != null)
            IconButton(
              icon: Icon(Icons.chat),
              onPressed: _navigateToChatPage,
            ),
          if (FirebaseAuth.instance.currentUser != null)
            IconButton(
              icon: Icon(Icons.calendar_today),
              onPressed: () {
                _navigateToCalendarPage();
              },
            ),
          if (FirebaseAuth.instance.currentUser != null)
            IconButton(
              icon: Icon(Icons.photo_album),
              onPressed: () {
                _navigateToPhotoAlbumPage();
              },
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
                    style: const TextStyle(
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
              const Text(
                'Log in to access to Meowdical',
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
