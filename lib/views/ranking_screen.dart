import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gpa_analyzer/controllers/main_controller.dart';
import 'package:gpa_analyzer/controllers/process_data.dart';

class Ranking extends StatefulWidget {
  @override
  _RankingState createState() => _RankingState();
}

class _RankingState extends State<Ranking> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  final _processData = ProcessData();
  final _mainController = MainController();

  String _batch;
  String _dep;
  String _index;
  List<QueryDocumentSnapshot> ranks = [];
  var no;

  Future<Null> getResults() async {
    _index = await _mainController.getIndex();
    _batch = await _mainController.getBatch();
    _dep = await _mainController.getDepartment();
    await _processData.getRanks(_batch, _dep);

    setState(() {
      ranks = _processData.ranks;
    });
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
    int prevNo = 1;
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: getResults,
      child: ListView.builder(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),
          itemCount: ranks.length,
          itemBuilder: (BuildContext context, int index) {
            no = index + 1;
            if (index > 0 &&
                ranks[index].data()['gpa'] == ranks[index - 1].data()['gpa']) {
              no = prevNo;
            } else
              prevNo = no;

            return new Column(
              children: <Widget>[
                new ListTile(
                  leading: Text(no.toString()),
                  title: new Text(ranks[index].id),
                  subtitle: new Text(ranks[index].data()['gpa'].toString()),
                  tileColor: ranks[index].id == _index
                      ? Colors.amber[800]
                      : Colors.white,
                ),
                new Divider(
                  height: 2.0,
                ),
              ],
            );
          }),
    );
  }
}
