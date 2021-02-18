import 'package:shared_preferences/shared_preferences.dart';

class MainController {
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

  Future<void> setUsername(String name) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('username', name);
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

  Future<String> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  void deleteAll() async{
  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.clear();
}

}
