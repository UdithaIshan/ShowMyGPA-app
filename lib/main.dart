import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gpa_analyzer/screens/register.dart';
import 'package:gpa_analyzer/screens/welcome_screen.dart';

import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(GPAAnalyzer());
}

class GPAAnalyzer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id : (context) => WelcomeScreen(),
        Register.id : (context) => Register(),
        // Login.id : (context) => Login(),
        Home.id : (context) => Home(),
      },
    );
  }
}
