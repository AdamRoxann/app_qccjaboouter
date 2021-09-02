import 'package:flutter/material.dart';
import 'package:qccjaboouter/auth/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Navigation extends StatefulWidget {
  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  LoginStatus loginStatus = LoginStatus.notSignIn;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlatButton(
        onPressed: () async {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          setState(() {
            preferences.setInt('value', 0);
            preferences.commit();
            loginStatus = LoginStatus.notSignIn;
          });
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (BuildContext ctx) => LoginPage()));
        },
        child: Text("press me"),
      ),
    );
  }
}
