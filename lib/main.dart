import 'package:flutter/material.dart';
import 'package:gpa_analyzer/screen_selector.dart';
import 'package:gpa_analyzer/welcome_screen.dart';

void main() async {
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
        ScreenSelector.id : (context) => ScreenSelector(),
      },
    );
  }
}
