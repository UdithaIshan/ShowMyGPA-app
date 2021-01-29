import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();

  final _firestore = FirebaseFirestore.instance;
  String _index;
  String _batch;
  String _dep;
  Map<String, dynamic> results;
  Map<String, dynamic> gpvs;
  Map<String, dynamic> credits;
  double gpa;
  // void getUserData() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   _index = prefs.getString('index');
  //   _batch = prefs.getString('batch');
  //   _dep = prefs.getString('dep');
  //   print(_index + _dep + _batch);
  // }

  Future<Null> getResults() async {
    final prefs = await SharedPreferences.getInstance();
    _index = prefs.getString('index');
    _batch = prefs.getString('batch');
    _dep = prefs.getString('dep');

    final resultList = await _firestore.collection('/ucsc/batch$_batch/$_dep/').doc('$_index').get();
    final gpvList = await _firestore.collection('/ucsc/').doc('gpv').get();
    final creditList = await _firestore.collection('/ucsc/').doc('${_dep}Credits').get();

    results = resultList.data();
    gpvs = gpvList.data();
    credits = creditList.data();

    gpa = getGPA(results, gpvs, credits);
  }

  double getGPA(results, gpvs, credits) {

    var totGPV =0.0 ;
    var totCREDITS =0 ;
    var totGPA =0.0 ;

    results.forEach((key, value) {
      if (gpvs[value]!=null) {
        var gpv = gpvs[value];
        var credit = credits[key];
        totCREDITS += credit;
        totGPV += gpv*credit;
      }
    });

    return totGPA = totGPV/totCREDITS;
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
      child: ListView(
        children: [TextButton(
          child: Text('get'),
          onPressed: () {
            getResults();
          },
        ),],
      ),
    );
  }
}
