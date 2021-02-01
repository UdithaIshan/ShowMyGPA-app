import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Ranking extends StatefulWidget {
  @override
  _RankingState createState() => _RankingState();
}

class _RankingState extends State<Ranking> {

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();

  final _firestore = FirebaseFirestore.instance;
  String _batch;
  String _dep;
  List<QueryDocumentSnapshot> ranks = [];

  Future<Null> getResults() async {
    final prefs = await SharedPreferences.getInstance();
    _batch = prefs.getString('batch');
    _dep = prefs.getString('dep');


    final rankList = await _firestore
        .collection('/ucsc/batch$_batch/$_dep/')
        .orderBy('gpa', descending: true)
        .get();


    ranks = rankList.docs;

    setState(() {
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
          var no = index + 1;
          if (index > 0 &&
              ranks[index].data()['gpa'] == ranks[index - 1].data()['gpa']) {
            no = prevNo;
          } else
            prevNo = no;

          // String key = ranks.keys.elementAt(index);
          return new Column(
            children: <Widget>[
              new ListTile(
                leading: Text(no.toString()),
                title: new Text(ranks[index].id),
                subtitle: new Text(ranks[index].data()['gpa'].toString()),
              ),
              new Divider(
                height: 2.0,
              ),
            ],
          );
        },
      ),
    );
  }
}
