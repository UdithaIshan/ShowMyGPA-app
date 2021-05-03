import 'package:flutter/material.dart';
import 'package:gpa_analyzer/bloc/data_bloc.dart';
import 'package:gpa_analyzer/data/data.dart';
import 'dart:collection';

class Semester extends StatefulWidget {
  @override
  _SemesterState createState() => _SemesterState();
}

class _SemesterState extends State<Semester> {
  TextEditingController _searchController = TextEditingController();

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  Map<String, dynamic> allResults = {};
  Map<String, dynamic> results = {};
  Map<String, dynamic> courses;
  Map<String, dynamic> newCourses = {};
  Map<String, dynamic> credits;
  var sortedResults = new SplayTreeMap<String, dynamic>();
  var showResults;
  int length = 0;

  DataBloc dataBloc;

  Future<Null> getResults() async {
    if (results != null) {
      length = results.length;

      sortedResults =
          SplayTreeMap<String, dynamic>.from(results, (a, b) => a.compareTo(b));

      sortedResults.forEach((key, value) {
        newCourses[key] = courses[key];
      });

      setState(() {
        allResults = sortedResults;
      });
    }
  }

  void setData(Data data) {
    results = data.results;
    courses = data.courses;
    credits = data.credits;
    getResults();
  }

  @override
  void initState() {
    dataBloc = DataBloc();
    dataBloc.data.listen((data) => setData(data));
    _searchController.addListener(_onSearchChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
    super.initState();
  }

  @override
  void dispose() {
    dataBloc.dispose();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  _onSearchChanged() {
    searchResultsList();
  }

  searchResultsList() {
    showResults = SplayTreeMap<String, dynamic>();

    if (_searchController.text != "") {
      newCourses.forEach((key, value) {
        if (value != null) {
          var title = value.toLowerCase();
          if (title.contains(_searchController.text.toLowerCase())) {
            showResults.putIfAbsent(key, () => value);
          }
        }
      });
    } else {
      showResults = allResults;
    }
    setState(() {
      sortedResults = showResults;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: () async {
        await getResults();
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(75, 20, 75, 20),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(hintText: 'Search'),
            ),
          ),
          Expanded(
            child: ListView.builder(
                padding: EdgeInsets.fromLTRB(
                    0, MediaQuery.of(context).size.height * 0.05, 0, 0),
                itemCount: sortedResults.length,
                itemBuilder: (BuildContext context, int index) {
                  String key = sortedResults.keys.elementAt(index);
                  if (key != 'gpa' && key != null && courses[key] != null) {
                    return ListTile(
                      contentPadding: EdgeInsets.fromLTRB(50, 0, 50, 20),
                      title: Text(
                        courses[key],
                        style: TextStyle(fontSize: 15),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            key,
                            style: TextStyle(fontSize: 15),
                          ),
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
