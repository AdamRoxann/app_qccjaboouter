import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qccjaboouter/in_app/dataPage.dart';
import 'package:qccjaboouter/in_app/jenisPage.dart';
import 'package:http/http.dart' as http;
import 'package:qccjaboouter/in_app/navbar.dart';
import 'package:qccjaboouter/url.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

enum LoginStatus { notSignIn, signIn }

class _LoginPageState extends State<LoginPage> {
  LoginStatus loginStatus = LoginStatus.notSignIn;
  String email, password;
  final key = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldkey = new GlobalKey<ScaffoldState>();

  check() {
    final form = key.currentState;
    if (form.validate()) {
      form.save();
      login();
    }
  }

  Widget _loading(BuildContext context) {
    return new Transform.scale(
      scale: 1,
      child: Opacity(
        opacity: 1,
        child: CupertinoAlertDialog(
          title: Text("Please Wait..."),
          content: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: SizedBox(
                // height: 50,
                // width: 50,
                child: Center(child: CircularProgressIndicator())),
          ),
        ),
      ),
    );
  }

  login() async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => _loading(context),
    );
    final response = await http.post(Uri.parse(AuthUrl.login), body: {
      "email": email,
      "password": password,
    });

    final data = jsonDecode(response.body);
    int value = data['value'];
    String message = data['message'];
    String emailAPI = data['email'];
    String usernameAPI = data['username'];
    String idAPI = data['id'];
    String mitraAPI = data['mitra'];

    if (value == 1) {
      Navigator.pop(context);
      setState(() {
        loginStatus = LoginStatus.signIn;
        savePref(value, idAPI, emailAPI, usernameAPI, mitraAPI);
      });
      print(message);
      print(data);
      // _showToast(message);
    } else {
      Navigator.pop(context);
      print("fail");
      print(message);
      _showToast(message);
    }
  }

  _showToast(String toast) {
    final snackbar = SnackBar(
      content: new Text(toast),
      backgroundColor: Colors.red,
    );
    scaffoldkey.currentState.showSnackBar(snackbar);
  }

  savePref(
      int value, String id, String email, String username, String mitra) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", value);
      preferences.setString("id", id);
      preferences.setString("username", username);
      preferences.setString("email", email);
      preferences.setString("mitra", mitra);
      preferences.commit();
    });
  }

  var value;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value = preferences.getInt("value");

      loginStatus = value == 1 ? LoginStatus.signIn : LoginStatus.notSignIn;
    });
  }

  signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", null);
      preferences.commit();
      loginStatus = LoginStatus.notSignIn;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  bool _isObscure = true;
  @override
  Widget build(BuildContext context) {
    switch (loginStatus) {
      case LoginStatus.notSignIn:
        return Scaffold(
            key: scaffoldkey,
            body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/background.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Image.asset(
                      "assets/images/logo.png",
                      height: 175,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            color: Colors.white.withOpacity(0.8),
                            child: Container(
                              // color: Colors.white,
                              child: Form(
                                key: key,
                                child: Padding(
                                  padding: const EdgeInsets.all(40),
                                  child: Column(
                                    children: [
                                      SizedBox(height: 40),
                                      TextFormField(
                                        validator: validateEmail,
                                        onSaved: (e) => email = e,
                                        decoration: InputDecoration(
                                          labelText: 'Email',
                                          labelStyle: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontFamily: 'Poppins Regular',
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                              color: Colors.black,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide:
                                                BorderSide(color: Colors.black),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 16),
                                      TextFormField(
                                        validator: (e) {
                                          if (e.isEmpty) {
                                            return "Password Can't be Empty";
                                          }
                                        },
                                        onSaved: (e) => password = e,
                                        obscureText: _isObscure,
                                        decoration: InputDecoration(
                                          labelText: 'Password',
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              _isObscure
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                              color: Color(0xFF7F8C8D),
                                            ),
                                            onPressed: () {
                                              setState(
                                                () {
                                                  _isObscure = !_isObscure;
                                                },
                                              );
                                            },
                                          ),
                                          labelStyle: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontFamily: 'Poppins Regular',
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                              color: Colors.black,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide:
                                                BorderSide(color: Colors.black),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: TextButton(
                                          onPressed: () {},
                                          child: Text(
                                            'Lupa Password?',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontFamily: 'Poppins Regular',
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      Container(
                                        height: 60,
                                        width: double.infinity,
                                        // ignore: deprecated_member_use
                                        child: FlatButton(
                                          onPressed: () {
                                            // Navigator.push(
                                            //   context,
                                            //   MaterialPageRoute(
                                            //     builder: (context) => JenisPage(),
                                            //   ),
                                            // );
                                            check();
                                          },
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          color: Colors.blue[500],
                                          child: Container(
                                            alignment: Alignment.center,
                                            constraints: BoxConstraints(
                                              maxWidth: double.infinity,
                                              minHeight: 50,
                                            ),
                                            child: Text(
                                              'Masuk',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontFamily: 'Poppins Medium',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ));
        break;
      case LoginStatus.signIn:
        return DataPage();
        break;
    }
  }
}
