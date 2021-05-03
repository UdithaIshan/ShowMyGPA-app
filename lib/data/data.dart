class Data {
  Data(this.index, this.username, this.gpa, this.classType, this.rank, this.totalCredits, this.results, this.courses, this.credits);

  String username;
  String index;
  double gpa;
  String classType;
  String rank;
  int totalCredits;
  Map<String, dynamic> results;
  Map<String, dynamic> courses;
  Map<String, dynamic> credits;

  static Data fromDataDb(Map<String, dynamic> dbData) {
    return Data(dbData['index'], dbData['username'], dbData['gpa'], dbData['classType'], dbData['rank'], dbData['totalCredits'], dbData['results'], dbData['courses'], dbData['credits']);
  }

}