import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainController extends ChangeNotifier{

  Future<void> setIndex(String index) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('index', index);
  }

  Future<void> setBatch(String batch) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('batch', batch);
  }

  Future<void> setDepartment(String dep) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('dep', dep);
  }

  Future<void> setLogin(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('autologin', value);
  }

  Future<String> getIndex() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('index');
  }

  Future<String> getBatch() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('batch');
  }

  Future<String> getDepartment() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('dep');
  }

  Future<bool> getLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('autologin');
  }

}