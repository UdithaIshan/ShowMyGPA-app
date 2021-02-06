import 'package:flutter/material.dart';
import 'package:gpa_analyzer/controllers/process_data.dart';
import 'package:gpa_analyzer/controllers/main_controller.dart';

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

      results.forEach((key, value) {
        newCourses[key] = courses[key];
      });
      setState(() {
        allResults = results;
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
      results = showResults;
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
                    10, MediaQuery.of(context).size.height * 0.05, 10, 0),
                itemCount: results.length,
                itemBuilder: (BuildContext context, int index) {
                  String key = results.keys.elementAt(index);
                  if (key != 'gpa') {
                    return ListTile(
                      // leading: Text((index+1).toString()),
                      title: Text(courses[key]),
                      subtitle: Text(key),
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
