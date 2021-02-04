import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Semester extends StatefulWidget {
  @override
  _SemesterState createState() => _SemesterState();
}

class _SemesterState extends State<Semester> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();

  final _firestore = FirebaseFirestore.instance;
  String _batch;
  String _dep;
  String _index;
  Map<String, dynamic> results;
  Map<String, dynamic> credits;

  Future<Null> getResults() async {
    final prefs = await SharedPreferences.getInstance();
    _index = prefs.getString('index');
    _batch = prefs.getString('batch');
    _dep = prefs.getString('dep');



    final resultList = await _firestore
        .collection('/ucsc/batch$_batch/$_dep/')
        .doc('$_index')
        .get();
    final creditList =
    await _firestore.collection('/ucsc/').doc('${_dep}Credits').get();

    results = resultList.data();
    credits = creditList.data();

    setState(() {});
  }


  @override
  void initState() {
    super.initState();
    // refresh when widget id build
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: getResults,
      child: ListView.builder(
          padding:
          EdgeInsets.only(top: MediaQuery
              .of(context)
              .size
              .height * 0.05),
          itemCount: results.length,
          itemBuilder: (BuildContext context, int index) {

            return new Card(
              color: Colors.amber,
              child: Text(index.toString()),
            );
          }
      ),
    );
  }
}
