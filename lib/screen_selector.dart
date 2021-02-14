import 'package:flutter/material.dart';
import 'package:gpa_analyzer/views/home_screen.dart';
import 'package:gpa_analyzer/views/ranking_screen.dart';
import 'package:gpa_analyzer/views/semester_screen.dart';

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
                  icon: Icon(Icons.school_outlined), label: "Overview"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.filter_frames_outlined), label: "Results"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.trending_up), label: "Ranking"),
            ],
            currentIndex: _currentIndex,
            selectedItemColor: Color.fromRGBO(254, 101, 65, 1),
            unselectedItemColor: Colors.grey,
            onTap: _onItemTapped,
          ),
          body: IndexedStack(index: _currentIndex, children: _screenContainer)),
    );
  }
}
