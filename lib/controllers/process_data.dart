import 'package:cloud_firestore/cloud_firestore.dart';

class ProcessData {
  final _firestore = FirebaseFirestore.instance;

  Map<String, dynamic> results;
  Map<String, dynamic> gpvs;
  Map<String, dynamic> courses;
  Map<String, dynamic> credits;
  List<QueryDocumentSnapshot> ranks = [];

  Future<Null> getResults(index, batch, dep) async {
    final resultList = await _firestore
        .collection('/ucsc/batch$batch/$dep/')
        .doc('$index')
        .get();
    results = resultList.data();
  }
}
