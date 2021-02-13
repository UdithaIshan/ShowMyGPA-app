import 'package:flutter/material.dart';
import 'package:gpa_analyzer/screen_selector.dart';
import 'controllers/main_controller.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  final _mainController = MainController();

  bool isIndexSet = false;
  bool isBatchSet = false;

  String _dep = 'cs';
  int _value;
  List<DropdownMenuItem<int>> batchList = [];

  void loadList() {
    batchList = [];

    batchList.add(DropdownMenuItem(
      child: Text('16th Batch'),
      value: 0,
    ));
    batchList.add(DropdownMenuItem(
      child: Text('17th Batch'),
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
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Image(
                        image: AssetImage('assets/students.png'),
                        height: MediaQuery.of(context).size.height * 0.1,
                      ),
                      Text(
                        'Show(MyGPA)',
                        style: TextStyle(
                          fontFamily: 'Archivo Black',
                          fontSize: 30 * curScaleFactor,
                          fontWeight: FontWeight.w700,
                          color: Colors.amber[700],
                        ),
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
                          _mainController.setIndex(value);
                          isIndexSet = true;
                        },
                        decoration: InputDecoration(
                          hintText: "My index number is...",
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red, //this has no effect
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical:
                                  MediaQuery.of(context).size.height * 0.01,
                              horizontal: 20.0),
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
                          _mainController.setBatch('${value + 16}');
                          isBatchSet = true;
                        },
                        decoration: InputDecoration(
                          hintText: "I'm in ...",
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
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: [
                                Text('Studying '),
                                Radio(
                                  value: 'cs',
                                  groupValue: _dep,
                                  onChanged: (value) {
                                    setState(() {
                                      _dep = value;
                                    });
                                  },
                                ),
                                Text('CS'),
                                Radio(
                                  value: 'is',
                                  groupValue: _dep,
                                  onChanged: (value) {
                                    setState(() {
                                      _dep = value;
                                    });
                                  },
                                ),
                                Text('IS'),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),
                      MaterialButton(

                        onPressed: () async {
                          if (isBatchSet && isIndexSet) {
                            _mainController.setDepartment(_dep);
                            _mainController.setLogin(true);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        ScreenSelector()));
                          }
                        },
                        color: Colors.yellow,
                        height: MediaQuery.of(context).size.height * 0.09,
                        child: Text(
                          "I'm ready !",
                          style: TextStyle(fontSize: 20 * curScaleFactor,  fontFamily: 'Archivo Black',color: Colors.grey[800]),
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
