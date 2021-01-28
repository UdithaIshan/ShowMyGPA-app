import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final _firestore = FirebaseFirestore.instance;
  String _index;
  String _batch;

  void getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    _index = prefs.getString('index');
    _batch = prefs.getString('batch');
  }

  void getResults() async {
    final results = await _firestore.collection('/ucsc/batch16/cs/').doc('18000681').get();

      print(results.data());
      
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextButton(
        child: Text('get'),
        onPressed: () {
          getResults();
        },
      ),
    );
  }
}
