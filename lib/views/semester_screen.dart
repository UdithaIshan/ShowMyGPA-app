import 'package:flutter/material.dart';
import 'package:gpa_analyzer/controllers/process_data.dart';
import 'package:gpa_analyzer/controllers/main_controller.dart';
import 'dart:collection';

class Semester extends StatefulWidget {
  @override
  _SemesterState createState() => _SemesterState();
}

class _SemesterState extends State<Semester> {
  TextEditingController _searchController = TextEditingController();

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  final _processData = ProcessData();
  final _mainController = MainController();

  String _batch;
  String _dep;
  String _index;
  int length = 0;
  var sortedResults = new SplayTreeMap<String, dynamic>();
  Map<String, dynamic> newSortedResults = {};

  Map<String, dynamic> allResults = {};
  Map<String, dynamic> showResults;

  Map<String, dynamic> results = {};
  Map<String, dynamic> courses;
  Map<String, dynamic> newCourses = {};
  Map<String, dynamic> credits;

  Future<Null> getResults() async {
    _index = await _mainController.getIndex();
    _batch = await _mainController.getBatch();
    _dep = await _mainController.getDepartment();

    await _processData.getCourses(_index, _batch, _dep);
    results = _processData.results;

    if (results != null) {
      length = results.length;
      courses = _processData.courses;
      credits = _processData.credits;
      sortedResults =
          SplayTreeMap<String, dynamic>.from(results, (a, b) => a.compareTo(b));

      for (var i = sortedResults.length - 1; i >= 0; i--) {
        String key = sortedResults.keys.elementAt(i);
        newSortedResults[key] = sortedResults[key];
      }

      newSortedResults.forEach((key, value) {
        newCourses[key] = courses[key];
      });

      setState(() {
        allResults = newSortedResults;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  _onSearchChanged() {
    searchResultsList();
  }

  searchResultsList() {
    showResults = {};

    if (_searchController.text != "") {
      newCourses.forEach((key, value) {
        if (value != null) {
          var title = value.toLowerCase();
          if (title.contains(_searchController.text.toLowerCase())) {
            showResults[key] = value;
          }
        }
      });
    } else {
      showResults = allResults;
    }
    setState(() {
      newSortedResults = showResults;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: getResults,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(50, 20, 50, 20),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(hintText: 'Search'),
            ),
          ),
          Expanded(
            child: ListView.builder(
                padding: EdgeInsets.fromLTRB(
                    20, MediaQuery.of(context).size.height * 0.05, 20, 0),
                itemCount: newSortedResults.length,
                itemBuilder: (BuildContext context, int index) {
                  String key = newSortedResults.keys.elementAt(index);
                  if (key != null) {
                    return ListTile(
                      contentPadding: EdgeInsets.fromLTRB(50, 0, 50, 20),
                      title: Text(courses[key]),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(key),
                          Text('${credits[key].toString()} Credits'),
                        ],
                      ),
                      trailing: Text(allResults[key]),
                    );
                  }
                  return null;
                }),
          ),
        ],
      ),
    );
  }
}
