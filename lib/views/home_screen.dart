import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:gpa_analyzer/controllers/main_controller.dart';
import 'package:gpa_analyzer/controllers/process_data.dart';
import 'package:circular_custom_loader/circular_custom_loader.dart';

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
  Map<String, dynamic> _results;
  Map<String, dynamic> _gpvs;
  Map<String, dynamic> _credits;
  List<QueryDocumentSnapshot> _ranks = [];
  double _gpa;
  int _totCREDITS = 0;
  double _coveredPercent = 0;
  String _classType = 'N/A';
  String _value = 'N/A';

  Future<Null> getResults() async {
    _index = await _mainController.getIndex();
    _batch = await _mainController.getBatch();
    _dep = await _mainController.getDepartment();

    await _processData.getResults(_index, _batch, _dep);

    _ranks = _processData.ranks;

    _results = _processData.results;
    _gpvs = _processData.gpvs;
    _credits = _processData.credits;

    if (_results != null && _gpvs != null && _credits != null) {
      _gpa = getGPA(_results, _gpvs, _credits);
      _value = getRank(_ranks, _index);

      if (!mounted) {
        return; // Just do nothing if the widget is disposed.
      }

      setState(() {
        _coveredPercent = _gpa * 25;
        _classType = getClass(_gpa);
      });
    }
  }

  double getGPA(results, gpvs, credits) {
    var totGPV = 0.0;
    _totCREDITS = 0;

    results.forEach((key, value) {
      if (gpvs[value] != null) {
        var gpv = gpvs[value];
        var credit = credits[key];
        _totCREDITS += credit;
        totGPV += gpv * credit;
      }
    });
    return (totGPV / _totCREDITS * 100).truncateToDouble() / 100;
  }

  String getClass(gpa) {
    if (gpa >= 3.70)
      return 'First Class';
    else if (gpa < 3.70 && gpa >= 3.30)
      return 'Second Upper Class';
    else if (gpa < 3.30 && gpa >= 3.00)
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
                      fontSize: 20,
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
                coveredCircleColor: Color.fromRGBO(254, 101, 65, 1),
                circleHeader: 'GPA',
                unit: '/4.00',
                coveredPercentStyle: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(
                        fontSize: 41.0,
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
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.01),
                width: MediaQuery.of(context).size.width * 0.7,
                child: Divider(
                  thickness: 1,
                  color: Color.fromRGBO(255, 91, 53, 1),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RowItem(title: 'Rank', value: _value),
                  Container(
                      height: MediaQuery.of(context).size.height * 0.15,
                      child: VerticalDivider(
                        color: Color.fromRGBO(255, 91, 53, 1),
                        thickness: 1,
                      )),
                  RowItem(title: 'Credits', value: _totCREDITS.toString()),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
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
            style: TextStyle(fontSize: 20),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 17),
          )
        ],
      ),
    );
  }
}
