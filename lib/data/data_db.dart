import 'package:cloud_firestore/cloud_firestore.dart';

class DataDb {
  static final DataDb _singleton = DataDb._internal();
  DataDb._internal();

  factory DataDb() {
    return _singleton;
  }

  final _firestore = FirebaseFirestore.instance;

  Future<Data> getResults() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String index = prefs.getString('index');
      String batch = prefs.getString('batch');
      String dep = prefs.getString('dep');
      final resultList = await _firestore.collection('/ucsc/batch$batch/$dep/').doc('$index').get();
      // Map<String, dynamic> results = resultList.data();
      final data = Data.fromDataDb(resultList.data());
      return data;
    }
    catch(e) {
      print(e);
    }
  }
}