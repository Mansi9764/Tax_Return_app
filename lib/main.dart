// lib/main.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screenss/welcome_screen.dart';

// void main() {
//   runApp(MyApp());
// }

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// } 

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Retail Tax Filing App',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: WelcomeScreen(),
//     );
//   }
// }


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
    runApp(MyApp());
  } catch (e) {
    runApp(MyAppWithError(e.toString())); // Pass error message to the app.
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Retail Tax Filing App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WelcomeScreen(),  // Your initial screen for the app
    );
  }
}

class MyAppWithError extends StatelessWidget {
  final String errorMessage;

  MyAppWithError(this.errorMessage);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Retail Tax Filing App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: Center(
          child: Text('Failed to initialize Firebase: $errorMessage'),
        ),
      ),
    );
  }
}

