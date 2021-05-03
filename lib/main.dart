import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gpa_analyzer/controllers/main_controller.dart';
import 'package:gpa_analyzer/views/screen_selector.dart';
import 'package:gpa_analyzer/views/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final _auth = FirebaseAuth.instance;
  var mainController = MainController();
  bool isLoggedIn = await mainController.getLogin() == true  &&  _auth.currentUser != null ? true: false;
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
      theme: ThemeData(primaryColor: Colors.white, fontFamily: 'Ubuntu'),
      home: flag ? ScreenSelector() : WelcomeScreen(),
    );
  }
}
