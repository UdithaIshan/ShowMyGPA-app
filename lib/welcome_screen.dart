import 'package:flutter/material.dart';
import 'package:gpa_analyzer/screen_selector.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatefulWidget {

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool isIndexSet = false;
  bool isBatchSet = false;

  int _value;
  List<DropdownMenuItem<int>> batchList = [];

  Future<SharedPreferences> setUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs;
  }

  void loadList() {
    batchList = [];

    batchList.add(DropdownMenuItem(
      child: Text('16 th batch'),
      value: 0,
    ));
    batchList.add(DropdownMenuItem(
      child: Text('17 th batch'),
      value: 1,
    ));
  }

  @override
  Widget build(BuildContext context) {
    loadList();
    final curScaleFactor = MediaQuery.of(context).textScaleFactor;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          height: MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top -
              MediaQuery.of(context).padding.bottom,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Image(
                        image: AssetImage('assets/student.png'),
                        height: MediaQuery.of(context).size.height * 0.1,
                      ),
                      Text(
                        'GPA Analyzer',
                        style: TextStyle(
                            fontSize: 20 * curScaleFactor,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.15,
                      ),
                      TextField(
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setUserData().then((val) => {
                                if (val != null) {val.setString('index', value)}
                              });
                          isIndexSet = true;
                        },
                        decoration: InputDecoration(
                          hintText: "Your index number",
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red, //this has no effect
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      DropdownButtonFormField(
                        isExpanded: true,
                        items: batchList,
                        value: _value,
                        onChanged: (value) {
                          _value = value;
                          setUserData().then((val) => {
                                if (val != null)
                                  {
                                    val.setString(
                                        'batch', 'batch\'${value + 16}\'')    //if value = 0; then batch = "batch16"
                                  }
                              });
                          isBatchSet = true;
                        },
                        decoration: InputDecoration(
                          hintText: "Select your batch",
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red, //this has no effect
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1,
                      ),
                      MaterialButton(
                        onPressed: () async {
                          if (isBatchSet && isIndexSet) {
                            final prefs = await SharedPreferences.getInstance();
                            prefs.setBool('autologin', true);
                            print('autologin true');
                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ScreenSelector()));
                          }

                          // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ScreenSelector()));
                        },
                        color: Colors.yellow,
                        height: MediaQuery.of(context).size.height * 0.09,
                        child: Text(
                          "I'm ready !",
                          style: TextStyle(fontSize: 15 * curScaleFactor),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
