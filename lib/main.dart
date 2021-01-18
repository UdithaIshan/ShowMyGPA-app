import 'package:flutter/material.dart';
import 'package:gpa_analyzer/screens/register.dart';
import 'package:gpa_analyzer/screens/welcome_screen.dart';

void main() => runApp(GPAAnalyzer());

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
        'welcome_screen' : (context) => WelcomeScreen(),
        'register_screen' : (context) => Register(),
        // 'login_screen' : (context) => Login(),
        // 'home_screen' : (context) => Home(),
      },
    );
  }
}
