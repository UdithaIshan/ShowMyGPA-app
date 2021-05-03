import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../values.dart';
import 'data.dart';

class DataDb {
  static final DataDb _singleton = DataDb._internal();
  DataDb._internal();

  factory DataDb() {
    return _singleton;
  }

  final _firestore = FirebaseFirestore.instance;

  Map<String, dynamic> results;
  Map<String, dynamic> _gpvs;
  Map<String, dynamic> _credits;
  double _gpa;
  int _totCREDITS = 0;
  String _classType = 'N/A';
  String _value = 'N/A';
  Map<String, dynamic> courses;

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

  Future<Data> getDataFromFirestore() async {

    final prefs = await SharedPreferences.getInstance();
    String index = prefs.getString('index');
    String username = prefs.getString('username');
    String batch = prefs.getString('batch');
    String dep = prefs.getString('dep');


      Map<String, dynamic> dbData = {};
      _gpvs = gpvs;
      if(dep == 'cs') {
        courses = csCourses;
        _credits = creditCs;
      }
      else if(dep == 'is') {
        courses = isCourses;
        _credits = creditIs;
      }

      final resultList = await _firestore.collection('/ucsc/batch$batch/$dep/')
          .doc('$index')
          .get();
      results = resultList.data();

      if (results != null && _gpvs != null && _credits != null) {
        _gpa = getGPA(results, _gpvs, _credits);
        _value = results['rank'].toString();
        _classType = getClass(_gpa);

        dbData['username'] = username;
        dbData['index'] = index;
        dbData['rank'] = _value;
        dbData['gpa'] = _gpa;
        dbData['classType'] = _classType;
        dbData['totalCredits'] = _totCREDITS;
        dbData['results'] = results;
        dbData['courses'] = courses;
        dbData['credits'] = _credits;

        final data = Data.fromDataDb(dbData);
        return data;
      }
    }
    
    Map search(query) {
      Map<String, dynamic> result = courses;
      result.map((key, value) {
        if (value.contains(RegExp(query, caseSensitive: false)))
        return  MapEntry(key, value);
        }
      );
      return result;
    }
}
