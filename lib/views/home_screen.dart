import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:gpa_analyzer/controllers/main_controller.dart';
import 'package:gpa_analyzer/controllers/process_data.dart';
import 'package:circular_custom_loader/circular_custom_loader.dart';
import 'package:gpa_analyzer/values.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  final _processData = ProcessData();
  final _mainController = MainController();

  var _index = 'N/A';
  var _batch;
  var _dep;
  final Map<String, dynamic> gpvsForClass = gpvForClass;
  Map<String, dynamic> results;
  Map<String, dynamic> gpvs;
  Map<String, dynamic> credits;
  List<QueryDocumentSnapshot> ranks = [];
  double gpa;
  double gpaForClass;
  int totCREDITS = 0;
  double _coveredPercent = 0;
  String _classType = 'N/A';
  String _value = 'N/A';

  Future<Null> getResults() async {
    _index = await _mainController.getIndex();
    _batch = await _mainController.getBatch();
    _dep = await _mainController.getDepartment();

    await _processData.getResults(_index, _batch, _dep);

    ranks = _processData.ranks;

    results = _processData.results;
    gpvs = _processData.gpvs;
    credits = _processData.credits;

    if (results != null && gpvs != null && credits != null) {
      gpa = getGPA(results, gpvs, credits);
      gpaForClass = getGPAForClass(results, gpvsForClass, credits);
      _value = getRank(ranks, _index);

      if (!mounted) {
        return; // Just do nothing if the widget is disposed.
      }

      setState(() {
        _coveredPercent = gpa * 25;
        _classType = getClass(gpaForClass);
      });
    }
  }

  double getGPA(results, gpvs, credits) {
    var totGPV = 0.0;
    totCREDITS = 0;

    results.forEach((key, value) {
      if (gpvs[value] != null) {
        var gpv = gpvs[value];
        var credit = credits[key];
        totCREDITS += credit;
        totGPV += gpv * credit;
      }
    });
    // var n = totGPV / totCREDITS;
    return (totGPV / totCREDITS * 100).truncateToDouble() / 100;
  }

  double getGPAForClass(results, gpvsForClass, credits) {
    var totGPV = 0.0;
    var totalCREDITS = 0;

    results.forEach((key, value) {
      if (gpvsForClass[value] != null) {
        var gpv = gpvsForClass[value];
        var credit = credits[key];
        totalCREDITS += credit;
        totGPV += gpv * credit;
      }
    });

    return (totGPV / totalCREDITS * 100).truncateToDouble() / 100;
  }

  String getClass(gpa) {
    if (gpa >= 3.50)
      return 'First Class';
    else if (gpa < 3.50 && gpa >= 3.25)
      return 'Second Upper Class';
    else if (gpa < 3.25 && gpa >= 3.00)
      return 'Second Lower Class';
    else if (gpa < 3.00) return 'Normal Degree';
    return 'N/A';
  }

  String getRank(ranks, index) {
    int prevNo = 1;
    for (int i = 0; i <= ranks.length; i++) {
      int no = i + 1;
      if (i > 0 && ranks[i].data()['gpa'] == ranks[i - 1].data()['gpa']) {
        no = prevNo;
      } else
        prevNo = no;
      if (ranks[i].id == index) return no.toString();
    }
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
        padding: EdgeInsets.fromLTRB(
            30, MediaQuery.of(context).size.height * 0.03, 30, 0),
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Welcome $_index!',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w700,
                    ),
                  )),
              Align(
                  alignment: Alignment.topLeft,
                  child: Text('You have obtained,',
                      style: TextStyle(fontSize: 17))),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.08,
              ),
              CircularLoader(
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
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.07,
              ),
              Column(
                children: [
                  Text(
                    _classType,
                    style: TextStyle(fontSize: 23),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.01),
                width: MediaQuery.of(context).size.width * 0.7,
                child: Divider(
                  thickness: 1,
                  color: Colors.amber[800],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RowItem(title: 'Rank', value: _value),
                  Container(
                      height: MediaQuery.of(context).size.height * 0.15,
                      child: VerticalDivider(
                        color: Colors.amber[800],
                        thickness: 1,
                      )),
                  RowItem(title: 'Credits', value: totCREDITS.toString()),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}

class RowItem extends StatelessWidget {
  RowItem({@required this.title, this.value});
  String title;
  String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.25,
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 23),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 20),
          )
        ],
      ),
    );
  }
}
