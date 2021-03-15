import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
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

  final _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<String> signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential authResult =
          await _auth.signInWithCredential(credential);
      final User user = authResult.user;

      if (user != null) {
        assert(!user.isAnonymous);
        assert(await user.getIdToken() != null);

        final User currentUser = _auth.currentUser;
        assert(user.uid == currentUser.uid);

        print('signInWithGoogle succeeded: $user');

        return '$user';
      }
      return null;
    } catch (e) {
      return null;
    }
  }

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
              ClipPath(
                clipper: BezierClipper(2),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  color: Color.fromRGBO(254, 101, 65, 1),
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Image(
                        image: AssetImage('assets/students.png'),
                        height: MediaQuery.of(context).size.height * 0.1,
                      ),
                      Text(
                        'Show(MyGPA)',
                        style: TextStyle(
                          fontFamily: 'Ubuntu',
                          fontSize: 35 * curScaleFactor,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
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
                                  activeColor: Color.fromRGBO(254, 101, 65, 1),
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
                                  activeColor: Color.fromRGBO(254, 101, 65, 1),
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
                            signInWithGoogle().then((value) {
                              if (value != null) {
                                _mainController.setDepartment(_dep);
                                _mainController.setLogin(true);
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            ScreenSelector()));
                              }
                            });
                          }
                        },
                        color: Color.fromRGBO(254, 101, 65, 1),
                        height: MediaQuery.of(context).size.height * 0.09,
                        child: Text(
                          "I'm ready !",
                          style: TextStyle(
                              fontSize: 20 * curScaleFactor,
                              color: Colors.white),
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

class BezierClipper extends CustomClipper<Path> {
  final int state;
  BezierClipper(this.state);

  Path _getFinalClip(Size size) {
    Path path = Path();
    final double _xScaling = size.width / 414;
    final double _yScaling = size.height / 301.69;
    path.lineTo(-0.003999999999997783 * _xScaling, 217.841 * _yScaling);
    path.cubicTo(
      -0.003999999999997783 * _xScaling,
      217.841 * _yScaling,
      19.14 * _xScaling,
      265.91999999999996 * _yScaling,
      67.233 * _xScaling,
      265.91999999999996 * _yScaling,
    );
    path.cubicTo(
      115.326 * _xScaling,
      265.91999999999996 * _yScaling,
      112.752 * _xScaling,
      234.611 * _yScaling,
      173.83299999999997 * _xScaling,
      241.635 * _yScaling,
    );
    path.cubicTo(
      234.914 * _xScaling,
      248.659 * _yScaling,
      272.866 * _xScaling,
      301.691 * _yScaling,
      328.608 * _xScaling,
      301.691 * _yScaling,
    );
    path.cubicTo(
      384.34999999999997 * _xScaling,
      301.691 * _yScaling,
      413.99600000000004 * _xScaling,
      201.977 * _yScaling,
      413.99600000000004 * _xScaling,
      201.977 * _yScaling,
    );
    path.cubicTo(
      413.99600000000004 * _xScaling,
      201.977 * _yScaling,
      413.99600000000004 * _xScaling,
      0 * _yScaling,
      413.99600000000004 * _xScaling,
      0 * _yScaling,
    );
    path.cubicTo(
      413.99600000000004 * _xScaling,
      0 * _yScaling,
      -0.003999999999976467 * _xScaling,
      0 * _yScaling,
      -0.003999999999976467 * _xScaling,
      0 * _yScaling,
    );
    path.cubicTo(
      -0.003999999999976467 * _xScaling,
      0 * _yScaling,
      -0.003999999999997783 * _xScaling,
      217.841 * _yScaling,
      -0.003999999999997783 * _xScaling,
      217.841 * _yScaling,
    );
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;

  @override
  Path getClip(Size size) => _getFinalClip(size);
}
