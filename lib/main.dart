import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gpa_analyzer/screen_selector.dart';
import 'package:gpa_analyzer/screens/home_screen.dart';
import 'package:gpa_analyzer/welcome_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('autologin')?? false;
  runApp(GPAAnalyzer(flag: isLoggedIn,));
}

class GPAAnalyzer extends StatelessWidget {

  GPAAnalyzer({@required this.flag});
  bool flag;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: flag?ScreenSelector():WelcomeScreen(),
    );
  }
}


// class GPAAnalyzer extends StatefulWidget {
//
//   @override
//   _GPAAnalyzerState createState() => _GPAAnalyzerState();
// }
//
// class _GPAAnalyzerState extends State<GPAAnalyzer> {
//
//   bool isLoggedIn = false;
//   Widget root = WelcomeScreen();
//
//   void autoLogIn() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     isLoggedIn = prefs.getBool('autologin');
//     if(isLoggedIn) root = ScreenSelector();
//     print(isLoggedIn);
//     }
//
//   @override
//   Widget build(BuildContext context) {
//     autoLogIn();
//     return M
//   }
//   }
