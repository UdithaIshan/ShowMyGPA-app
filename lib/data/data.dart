class Data {
  Data(this.gpa, this.classType, this.rank, this.totalCredits, this.results);

  double gpa;
  String classType;
  String rank;
  int totalCredits;
  Map<String, dynamic> results;

  static Data fromDataDb(Map<String, dynamic> dbData) {
    return Data(dbData['gpa'], dbData['classType'], dbData['rank'], dbData['totalCredits'], dbData['results']);
  }

}