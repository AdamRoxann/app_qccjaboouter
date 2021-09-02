import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qccjaboouter/admin/admin_forms_view.dart';
import 'package:qccjaboouter/auth/login.dart';
import 'package:qccjaboouter/in_app/forms.dart';
import 'package:qccjaboouter/in_app/jenisPage.dart';
import 'package:qccjaboouter/model/data_penalty.dart';
import 'package:qccjaboouter/url.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class DataPage extends StatefulWidget {
  @override
  _DataPageState createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  String mitra, id;

  bool admin = false;
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      mitra = preferences.getString("mitra");
      id = preferences.getString("id");
      // token = preferences.getString("token");
    });
  }

  isAdmin() async {
    await getPref();
    final response =
        await http.post(Uri.parse(AuthUrl.isAdmin), body: {"id": id});

    final data = jsonDecode(response.body);
    int value = data['value'];
    if (value == 1) {
      setState(() {
        admin = true;
      });
      // _showToast(message);
    } else {}
  }

  var loading = false;
  final list = new List<DataPenalty>();
  Future<void> _allData() async {
    list.clear();
    await getPref();
    setState(() {
      loading = true;
    });
    final response = await http.post(DataUrl.showData, body: {"mitra": mitra});
    if (response.contentLength == 2) {
      //   await getPref();
      // final response =
      //     await http.post("https://dipena.com/flutter/api/updateProfile.php");
      // await http.post("https://dipena.com/flutter/api/updateProfile.php");
      //   "user_id": user_id,
      //   "location_country": location_country,
      //   "location_city": location_city,
      //   "location_user_id": user_id
      // });
      print('No Data');
      // final data = jsonDecode(response.body);
      // int value = data['value'];
      // String message = data['message'];
      // String changeProf = data['changeProf'];
    } else {
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final ab = new DataPenalty(
          api['id'],
          api['id_tiket'],
          api['siteid'],
          api['kondisi_site'],
          api['jenis_status_v1'],
          api['tgl_close'],
          api['estimasidenda_original'],
          api['created_at'],
        );
        list.add(ab);
      });
      if (this.mounted) {
        setState(() {
          loading = false;
          // print(list);
        });
      }
    }
  }

  Future onGoBack(dynamic value) {
    _allData();
  }

  @override
  void initState() {
    super.initState();
    getPref();
    isAdmin();
    _allData();
  }

  LoginStatus loginStatus = LoginStatus.notSignIn;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0F233D),
      appBar: AppBar(
        backgroundColor: Colors.white10,
        title: Text("Data Toti Overdue"),
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 20.0, top: 20),
              child: Text("Total: " + list.length.toString())),
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: InkWell(
              onTap: () async {
                SharedPreferences preferences =
                    await SharedPreferences.getInstance();
                setState(() {
                  preferences.setInt('value', 0);
                  preferences.commit();
                  loginStatus = LoginStatus.notSignIn;
                });
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext ctx) => LoginPage()));
              },
              child: Icon(Icons.login),
            ),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _allData,
        key: _refresh,
        child: ListView(
          children: [
            Container(
                // decoration: BoxDecoration(
                //   image: DecorationImage(
                //     image: AssetImage("assets/images/jenis_background.jpg"),
                //     fit: BoxFit.cover,
                //   ),
                // ),
                child: Column(
              children: [
                SizedBox(
                  height: 10.0,
                ),
                list.isEmpty
                    ? Align(
                        alignment: Alignment.center,
                        child: Center(
                          child: Text(
                            "Tidak ada data OPEN",
                            style: TextStyle(color: Colors.white),
                          ),
                        ))
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: list.length,
                        itemBuilder: (context, i) {
                          final x = list[i];
                          DateTime date = DateTime.parse(x.tgl_close);
                          DateTime newDate = date.add(const Duration(days: 5));
                          ;
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 1, horizontal: 10),
                            child: InkWell(
                              onTap: () {
                                //   print(x.id);
                                // Navigator.push(
                                // context,
                                // MaterialPageRoute(
                                //     builder: (context) =>
                                //       FormPage(x.id.toString())));
                                // Navigator.push(
                                // context,
                                // MaterialPageRoute(
                                //     builder: (context) =>
                                //       JenisPage(x.id.toString())));
                                if (admin == true) {
                                  Route route = MaterialPageRoute(
                                      builder: (context) =>
                                          AdminFormsView(x.id.toString()));
                                  Navigator.push(context, route).then(onGoBack);
                                } else {
                                  Route route = MaterialPageRoute(
                                      builder: (context) =>
                                          JenisPage(x.id.toString()));
                                  Navigator.push(context, route).then(onGoBack);
                                }
                              },
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: 180,
                                child: Card(
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: Colors.white38, width: 0.5),
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    color: Color(0xff232D4E),
                                    elevation: 3,
                                    child: Column(
                                      children: [
                                        Stack(
                                          children: [
                                            ListTile(
                                              title: Text(
                                                "ID Tiket : " +
                                                    x.id_tiket.toString(),
                                                style: TextStyle(
                                                    color: Colors.white70,
                                                    fontSize: 16.0),
                                              ),
                                              // subtitle: Text(
                                              //   'Secondary Text',
                                              //   style: TextStyle(color: Colors.black.withOpacity(0.6)),
                                              // ),
                                            ),
                                            Positioned(
                                              top: 0.0,
                                              right: 0.0,
                                              child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 20.0, right: 20),
                                                  child: Text(
                                                    DateFormat(
                                                            'EEEE, d MMM, yyyy')
                                                        .format(newDate),
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  )
                                                  // new IconButton(
                                                  //   icon: Icon(Icons.cancel,color: Colors.red,),
                                                  //   onPressed: () {}),
                                                  ),
                                            )
                                          ],
                                        ),
                                        Divider(color: Colors.black),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 16.0, top: 10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(
                                                  "Site ID : " + x.siteid,
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  "Kondisi : " + x.kondisi_site,
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 20.0),
                                                  child: Align(
                                                      alignment:
                                                          Alignment.bottomRight,
                                                      child: Text(
                                                          NumberFormat.currency(
                                                                  locale: 'id',
                                                                  symbol:
                                                                      "Rp. ")
                                                              .format(x
                                                                  .estimasidenda_original),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red))),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 20.0,
                                                          top: 5.0),
                                                  child: Align(
                                                      alignment:
                                                          Alignment.bottomRight,
                                                      child: Text(
                                                          x.tgl_close
                                                              .substring(0, 10),
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white))),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
                              ),
                            ),
                          );
                        },
                        // padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
                        // children: <Widget>[
                        // NotifList(
                        //   nama_pembeli: "Taye",
                        //   jumlah: '2',
                        //   alamat:
                        //       "Jalan Swadaya 2 no.36, rt 002/ rw 011, Cijantung, Pasar Rebo, Jakarta Timur",
                        // ),
                        // NotifList(
                        //   nama_pembeli: "Nurmala",
                        //   jumlah: '4',
                        //   alamat:
                        //       "Jalan Kalisari no.50, rt 002/ rw 011, Kalisari, Pasar Rebo, Jakarta Timur",
                        // ),
                        // NotifList(
                        //   nama_pembeli: "Taehyung",
                        //   jumlah: '1',
                        //   alamat:
                        //       "Jalan Pesona no.275, rt 006/ rw 07, Kalisari, Pasar Rebo, Jakarta Timur",
                        // ),
                        // NotifList(
                        //   nama_pembeli: "Jungkook",
                        //   jumlah: '2',
                        //   alamat:
                        //       "Jalan Tebet Raya no.50, rt 002/ rw 002, Tebet, Jakarta Selatan",
                        // ),
                        // ],
                      ),
              ],
            )),
          ],
        ),
      ),
    );
  }
}
