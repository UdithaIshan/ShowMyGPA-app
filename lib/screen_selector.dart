import 'package:flutter/material.dart';
import 'package:gpa_analyzer/screens/home_screen.dart';
import 'package:gpa_analyzer/screens/ranking_screen.dart';
import 'package:gpa_analyzer/screens/semester_screen.dart';
import 'package:gpa_analyzer/screens/settings_screen.dart';

class ScreenSelector extends StatefulWidget {
  static const String id = 'screen_selector';

  @override
  _ScreenSelectorState createState() => _ScreenSelectorState();
}

class _ScreenSelectorState extends State<ScreenSelector> {

  int _currentIndex = 0;
  List<Widget> _screenContainer = [
    Home(),
    Semester(),
    Settings(),
    Ranking(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: "Home"
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: "Home"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: "Home"
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: "Home"
              ),
            ],
            currentIndex: _currentIndex,
            selectedItemColor: Colors.amber[800],
            unselectedItemColor: Colors.grey,
            onTap: _onItemTapped,
          ),
          body: _screenContainer[_currentIndex]
      ),
    );
  }
}
