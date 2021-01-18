import 'package:flutter/material.dart';

class Register extends StatelessWidget {
  static const String id = "register_screen";
  String email;
  String index;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                onChanged: (value) {
                  value = email;
                },
                decoration: InputDecoration(
                  hintText: "Enter your email",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                ),
              ),
              TextField(
                onChanged: (value) {
                  value = index;
                },
                decoration: InputDecoration(
                  hintText: "Enter your index number",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                ),
              ),
              MaterialButton(
                onPressed: () {},
                color: Colors.grey,
                height: MediaQuery.of(context).size.height*0.09,
                child: Text(
                  "Login",
                  style: TextStyle(
                      fontSize: 15
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }
}
