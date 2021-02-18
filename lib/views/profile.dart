import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gpa_analyzer/controllers/main_controller.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  MainController _mainController = MainController();

  bool isUsernameSet = false;

  bool isIndexSet = false;

  String username;
  String index;

  TextEditingController one = TextEditingController();
  TextEditingController two = TextEditingController();

  void _showToast(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Updated. Refresh the app!'),
        action: SnackBarAction(
            label: 'HIDE',
            onPressed: ScaffoldMessenger.of(context).hideCurrentSnackBar),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.1,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 0.5,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'User Profile',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.07,
                    ),
                    TextField(
                      controller: one,
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        username = value;
                        isUsernameSet = true;
                      },
                      decoration: InputDecoration(
                        hintText: "Change user name",
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red, //this has no effect
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: MediaQuery.of(context).size.height * 0.01,
                            horizontal: 20.0),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    TextField(
                      controller: two,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        index = value;
                        isIndexSet = true;
                      },
                      decoration: InputDecoration(
                        hintText: "Change index number",
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red, //this has no effect
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: MediaQuery.of(context).size.height * 0.01,
                            horizontal: 20.0),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    MaterialButton(
                      onPressed: () async {
                        if (index != null && index != "") {
                          await _mainController.setIndex(index);
                          setState(() {
                            one.clear();
                            two.clear();
                            _showToast(context);
                          });
                        } else if (username != null && username != "") {
                          await _mainController.setUsername(username);
                          setState(() {
                            one.clear();
                            two.clear();
                            _showToast(context);
                          });
                        } else if (index != null &&
                            username != null &&
                            index != "" &&
                            username != "") {
                          await _mainController.setIndex(index);
                          await _mainController.setUsername(username);
                          setState(() {
                            one.clear();
                            two.clear();
                            _showToast(context);
                          });
                        }
                      },
                      color: Color.fromRGBO(254, 101, 65, 1),
                      height: MediaQuery.of(context).size.height * 0.07,
                      child: Text(
                        "Update",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.19,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MaterialButton(
                    onPressed: () async {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Log Out',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Color.fromRGBO(254, 101, 65, 1))),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    Text('Are you sure?'),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('Yes',
                                      style: TextStyle(
                                          color:
                                              Color.fromRGBO(254, 101, 65, 1))),
                                  onPressed: () {
                                    _mainController.deleteAll();
                                    SystemChannels.platform
                                        .invokeMethod('SystemNavigator.pop');
                                  },
                                ),
                              ],
                            );
                          });
                      //
                    },
                    color: Color.fromRGBO(254, 101, 65, 1),
                    height: MediaQuery.of(context).size.height * 0.07,
                    child: Text(
                      "Log Out",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
