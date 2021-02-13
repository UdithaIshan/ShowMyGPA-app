import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gpa_analyzer/controllers/main_controller.dart';
import 'package:gpa_analyzer/screen_selector.dart';
import 'package:gpa_analyzer/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  var mainController = MainController();
  bool isLoggedIn = await mainController.getLogin() ?? false;
  runApp(GPAAnalyzer(
    flag: isLoggedIn,
  ));
}

class GPAAnalyzer extends StatelessWidget {
  GPAAnalyzer({@required this.flag});
  bool flag;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Show(MyGPA)',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: flag ? ScreenSelector() : WelcomeScreen(),
    );
  }
}
