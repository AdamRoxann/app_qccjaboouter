import 'package:flutter/material.dart';
import 'package:qccjaboouter/in_app/Dihapuskan/forms.dart';
import 'package:qccjaboouter/in_app/Kondisi_site/forms.dart';
import 'package:qccjaboouter/in_app/Waktu_close/forms.dart';
import 'package:qccjaboouter/in_app/forms.dart';

class JenisPage extends StatefulWidget {
  final String id;
  JenisPage(this.id);
  @override
  _JenisPageState createState() => _JenisPageState();
}

class _JenisPageState extends State<JenisPage> {
  List data = [
    {"title": "Waktu Close"},
    {"title": "Kondisi Site"},
    {"title": "Dihapuskan"}
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/jenis_background.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: ListView(
                shrinkWrap: true,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10, bottom: 10, right: 20.0, left: 20.0),
                    child: Container(
                      height: 60,
                      width: double.infinity,
                      // ignore: deprecated_member_use
                      child: FlatButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  FormPage(widget.id.toString(), "Waktu Close"),
                            ),
                          );
                          // check();
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        color: Colors.yellow[900],
                        child: Container(
                          alignment: Alignment.center,
                          constraints: BoxConstraints(
                            maxWidth: double.infinity,
                            minHeight: 50,
                          ),
                          child: Text(
                            "Waktu Close",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: 'Poppins Medium',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10, bottom: 10, right: 20.0, left: 20.0),
                    child: Container(
                      height: 60,
                      width: double.infinity,
                      // ignore: deprecated_member_use
                      child: FlatButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FormPage(
                                  widget.id.toString(), "Kondisi Site"),
                            ),
                          );
                          // check();
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        color: Colors.yellow[900],
                        child: Container(
                          alignment: Alignment.center,
                          constraints: BoxConstraints(
                            maxWidth: double.infinity,
                            minHeight: 50,
                          ),
                          child: Text(
                            "Kondisi Site",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: 'Poppins Medium',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10, bottom: 10, right: 20.0, left: 20.0),
                    child: Container(
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
                          // check();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  FormPage(widget.id.toString(), "Dihapuskan"),
                            ),
                          );
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        color: Colors.yellow[900],
                        child: Container(
                          alignment: Alignment.center,
                          constraints: BoxConstraints(
                            maxWidth: double.infinity,
                            minHeight: 50,
                          ),
                          child: Text(
                            "Dihapuskan",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: 'Poppins Medium',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
            // Center(
            //     child: ListView.builder(
            //         shrinkWrap: true,
            //         itemCount: data.length,
            //         itemBuilder: (context, i) {
            //           return Padding(
            //             padding: const EdgeInsets.only(
            //                 top: 10, bottom: 10, right: 20.0, left: 20.0),
            //             child: Container(
            //               height: 60,
            //               width: double.infinity,
            //               // ignore: deprecated_member_use
            //               child: FlatButton(
            //                 onPressed: () {
            //                   // Navigator.push(
            //                   //   context,
            //                   //   MaterialPageRoute(
            //                   //     builder: (context) => JenisPage(),
            //                   //   ),
            //                   // );
            //                   // check();
            //                 },
            //                 shape: RoundedRectangleBorder(
            //                   borderRadius: BorderRadius.circular(10),
            //                 ),
            //                 color: Colors.yellow[900],
            //                 child: Container(
            //                   alignment: Alignment.center,
            //                   constraints: BoxConstraints(
            //                     maxWidth: double.infinity,
            //                     minHeight: 50,
            //                   ),
            //                   child: Text(
            //                     "Masuk",
            //                     style: TextStyle(
            //                       color: Colors.white,
            //                       fontSize: 18,
            //                       fontFamily: 'Poppins Medium',
            //                     ),
            //                   ),
            //                 ),
            //               ),
            //             ),
            //           );
            //         })),
            ));
  }
}
