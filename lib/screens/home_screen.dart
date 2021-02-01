import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:circular_custom_loader/circular_custom_loader.dart';

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
  List<QueryDocumentSnapshot> ranks = [];
  double gpa;
  double _coveredPercent = 0;
  String _class = 'N/A';

  Future<Null> getResults() async {
    final prefs = await SharedPreferences.getInstance();
    _index = prefs.getString('index');
    _batch = prefs.getString('batch');
    _dep = prefs.getString('dep');

    final resultList = await _firestore
        .collection('/ucsc/batch$_batch/$_dep/')
        .doc('$_index')
        .get();
    final gpvList = await _firestore.collection('/ucsc/').doc('gpv').get();
    final creditList =
        await _firestore.collection('/ucsc/').doc('${_dep}Credits').get();
    // final rankList = await _firestore.collection('/ucsc/batch$_batch/ranks/').doc('${_dep}Rank').get();
    final rankList = await _firestore
        .collection('/ucsc/batch$_batch/$_dep/')
        .orderBy('gpa', descending: true)
        .get();

    results = resultList.data();
    gpvs = gpvList.data();
    credits = creditList.data();
    ranks = rankList.docs;

    gpa = getGPA(results, gpvs, credits);

    if (!mounted) {
      return; // Just do nothing if the widget is disposed.
    }

    setState(() {
      _coveredPercent = gpa * 25;
      _class = getClass(gpa);
    });
  }

  double getGPA(results, gpvs, credits) {
    var totGPV = 0.0;
    var totCREDITS = 0;
    var totGPA = 0.0;

    results.forEach((key, value) {
      if (gpvs[value] != null) {
        var gpv = gpvs[value];
        var credit = credits[key];
        totCREDITS += credit;
        totGPV += gpv * credit;
      }
    });

    return totGPA = totGPV / totCREDITS;
  }

  String getClass(gpa) {
    if (gpa >= 3.50)
      return 'First Class';
    else if (gpa < 3.50 && gpa >= 3.25)
      return 'Second Upper Class';
    else if (gpa < 3.25 && gpa >= 3.00) return 'Second Lower Class';
    return 'N/A';
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
        padding:
            EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),
        children: [
          Align(
            alignment: Alignment.center,
            child: CircularLoader(
              coveredPercent: _coveredPercent,
              width: MediaQuery.of(context).size.width * .6,
              height: MediaQuery.of(context).size.width * .6,
              circleWidth: 12.0,
              circleColor: Colors.grey[300],
              coveredCircleColor: Colors.amber[800],
              circleHeader: 'GPA',
              unit: '/4.00',
              coveredPercentStyle: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .copyWith(
                      fontSize: 44.0,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.0,
                      color: Colors.black87),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(_class),
          ),
          Container(
            child: Table(
              children: [
                TableRow(
                  children: [
                    TableCell(child: Text('1')),
                    TableCell(child: Text('1')),
                    TableCell(child: Text('1'))
                  ]
                )
              ],
            ),
          )
        ],



      ),
    );
  }
}
