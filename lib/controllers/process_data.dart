import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    final gpvList = await _firestore.collection('/ucsc/').doc('gpv').get();
    final creditList =
    await _firestore.collection('/ucsc/').doc('${dep}Credits').get();
    final rankList = await _firestore
        .collection('/ucsc/batch$batch/$dep/')
        .orderBy('gpa', descending: true)
        .get();

    ranks = rankList.docs;
    results = resultList.data();
    gpvs = gpvList.data();
    credits = creditList.data();
  }

  Future<Null> getCourses(index, batch, dep) async {

    final resultList = await _firestore
        .collection('/ucsc/batch$batch/$dep/')
        .doc('$index')
        .get();
    final coursesList = await _firestore.collection('/ucsc/').doc('${dep}Courses').get();
    final creditList =
    await _firestore.collection('/ucsc/').doc('${dep}Credits').get();

    results = resultList.data();
    courses = coursesList.data();
    credits = creditList.data();
  }

  Future<Null> getRanks(batch, dep) async {

    final rankList = await _firestore
        .collection('/ucsc/batch$batch/$dep/')
        .orderBy('gpa', descending: true)
        .get();

    ranks = rankList.docs;
  }
}