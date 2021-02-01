import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gpa_analyzer/screens/home_screen.dart';
import 'package:gpa_analyzer/screens/ranking_screen.dart';
import 'screens/settings_screen.dart';
import 'package:gpa_analyzer/screens/semester_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScreenSelector extends StatefulWidget {
  static const String id = 'screen_selector';

  @override
  _ScreenSelectorState createState() => _ScreenSelectorState();
}

class _ScreenSelectorState extends State<ScreenSelector> {

  int _currentIndex = 0;
  List<Widget> _screenContainer = [
    Home(),
    Ranking(),
    UserSettings(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            bottomNavigationBar: BottomNavigationBar(
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.school_outlined), label: "GPA"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.filter_frames_outlined), label: "Results"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.info_outline_rounded), label: "More"),
                // BottomNavigationBarItem(
                //     icon: Icon(Icons.home),
                //     label: "Home"
                // ),
              ],
              currentIndex: _currentIndex,
              selectedItemColor: Colors.amber[800],
              unselectedItemColor: Colors.grey,
              onTap: _onItemTapped,
            ),
            body: IndexedStack(index: _currentIndex,children: _screenContainer)),
      ),
    );
  }
}
