import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = "welcome_screen";

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    final curScaleFactor = MediaQuery.of(context).textScaleFactor;

    return SafeArea(
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Image(
                          image: AssetImage('assets/student.png'),
                        height: MediaQuery.of(context).size.height*0.1,
                      ),
                      Text('GPA Analyzer',
                        style: TextStyle(
                            fontSize: 20 * curScaleFactor,
                          fontWeight: FontWeight.w700
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal:30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MaterialButton(
                        onPressed: () {
                          Navigator.pushNamed(context, 'register_screen');
                        },
                        color: Colors.yellow,
                        height: MediaQuery.of(context).size.height*0.09,
                        child: Text(
                          "I'm new here",
                          style: TextStyle(
                            fontSize: 15 * curScaleFactor
                          ),
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                      MaterialButton(
                        onPressed: () {},
                        color: Colors.grey,
                        height: MediaQuery.of(context).size.height*0.09,
                        child: Text(
                          "Login",
                          style: TextStyle(
                              fontSize: 15 * curScaleFactor
                          ),
                        ),
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
