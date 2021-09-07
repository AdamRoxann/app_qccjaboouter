import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qccjaboouter/admin/admin_jenis_page.dart';
import 'package:qccjaboouter/in_app/Class/dihapuskan_class.dart';
import 'package:qccjaboouter/in_app/Class/kondisi_site_class.dart';
import 'package:qccjaboouter/in_app/dataPage.dart';
import 'package:qccjaboouter/model/data_forms.dart';
import 'package:qccjaboouter/model/data_penalty.dart';
import 'package:http/http.dart' as http;
import 'package:qccjaboouter/url.dart';
import 'package:path/path.dart' as path;
import 'package:async/async.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminFormsView extends StatefulWidget {
  final String id;
  AdminFormsView(this.id);
  @override
  _AdminFormsViewState createState() => _AdminFormsViewState();
}

class _AdminFormsViewState extends State<AdminFormsView> {
  final key = new GlobalKey<FormState>();
  String keterangan;
  var keterangan_solusi = TextEditingController();

  String _mySelection, _mySelection1, _mySelection2;
  File _imageFile1,
      _imageFile2,
      _imageFile3,
      _imageFile4,
      _imageFile5,
      _imageFile6;

  DateTime selectedDateOpen = DateTime.now();
  DateTime selectedDateClose = DateTime.now();
  DateTime selectedDateShareCover = DateTime.now();

  Future<void> _selectDateOpen(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDateOpen,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDateOpen)
      setState(() {
        selectedDateOpen = picked;
      });
  }

  Future<void> _selectDateClose(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDateClose,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDateClose)
      setState(() {
        selectedDateClose = picked;
      });
  }

  DateTime tanggal_close_revisi;

  Future<void> _selectDateShareCover(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDateShareCover,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDateShareCover)
      setState(() {
        selectedDateShareCover = picked;
        tanggal_close_revisi = picked;
      });
  }

  var loading = false;
  String jenis;
  final list = new List<DataFormsView>();
  Future<void> _allData() async {
    list.clear();
    setState(() {
      loading = true;
    });
    final response = await http.post(DataUrl.showForm, body: {"id": widget.id});
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
        final ab = new DataFormsView(
          api['id'],
          api['id_tiket'],
          api['siteid'],
          api['kondisi_site'],
          api['jenis_recon_v1'],
          api['tgl_request'],
          api['tgl_close'],
          api['tanggalclose_afterrecon'],
          api['estimasidenda_original'],
          api['status_recon_v2'],
          api['alasan_submitrecon'],
          api['kondisisite_afterrecon_v1'],
          api['solusi'],
          api['created_at'],
        );
        list.add(ab);
      });
      if (this.mounted) {
        setState(() {
          loading = false;
          for (var i = 0; i < list.length; i++) {
            jenis = list[i].jenis_recon_v1;
            keterangan_solusi.text = list[i].solusi;
          }
          // print(list);
        });
      }
    }
  }

  String image1, image2, image3, image4, image5, image6;

  isImages() async {
    final response = await http
        .post(Uri.parse(DataUrl.showImages), body: {"data_id": widget.id});

    final data = jsonDecode(response.body);
    int value = data['value'];
    String image_name1API = data['image_name1'];
    String image_name2API = data['image_name2'];
    String image_name3API = data['image_name3'];
    String image_name4API = data['image_name4'];
    String image_name5API = data['image_name5'];
    String image_name6API = data['image_name6'];
    if (response.contentLength == 2) {
      // _showToast(message);
    } else {
      setState(() {
        image1 = image_name1API;
        image2 = image_name2API;
        image3 = image_name3API;
        image4 = image_name4API;
        image5 = image_name5API;
        image6 = image_name6API;
      });
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

  reject() async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => _loading(context),
    );
    final response = await http
        .post(Uri.parse(DataUrl.rejectData), body: {"data_id": widget.id});

    final data = jsonDecode(response.body);
    int value = data['value'];
    String message = data['message'];
    if (value == 1) {
      int count = 0;
      Navigator.of(context).popUntil((_) => count++ >= 2);
      print(message);
      // _showToast(message);
    } else {}
  }

  _pilihGallery(File imagenya) async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 1920.0, maxWidth: 1080.0);
    setState(() {
      if (imagenya == _imageFile1) {
        _imageFile1 = image;
      } else if (imagenya == _imageFile2) {
        _imageFile2 = image;
      } else if (imagenya == _imageFile3) {
        _imageFile3 = image;
      } else if (imagenya == _imageFile4) {
        _imageFile4 = image;
      } else if (imagenya == _imageFile5) {
        _imageFile5 = image;
      } else if (imagenya == _imageFile6) {
        _imageFile6 = image;
      }
    });
  }

  _pilihCamera(File imagenya) async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 1920.0, maxWidth: 1080.0);
    setState(() {
      if (imagenya == _imageFile1) {
        _imageFile1 = image;
      } else if (imagenya == _imageFile2) {
        _imageFile2 = image;
      } else if (imagenya == _imageFile3) {
        _imageFile3 = image;
      } else if (imagenya == _imageFile4) {
        _imageFile4 = image;
      } else if (imagenya == _imageFile5) {
        _imageFile5 = image;
      } else if (imagenya == _imageFile6) {
        _imageFile6 = image;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _allData();
    isImages();
  }

  Widget _popUpImage(BuildContext context, File imagenya) {
    return new Transform.scale(
      scale: 1,
      child: Opacity(
        opacity: 1,
        child: CupertinoAlertDialog(
            content: Text("Choose Method"),
            actions: <Widget>[
              Container(
                color: Colors.white,
                child: CupertinoDialogAction(
                  child: Text(
                    'Camera',
                    style: new TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    _pilihCamera(imagenya);
                    Navigator.of(context).pop();
                  },
                ),
              ),
              Container(
                color: Colors.white,
                child: CupertinoDialogAction(
                  child: Text(
                    'Gallery',
                    style: new TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    _pilihGallery(imagenya);
                    // delete();
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ]),
      ),
    );
  }

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0F233D),
      appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white10,
          title: jenis == null
              ? Text("Form Jenis : belum ada")
              : Text("Form Jenis " + jenis)),
      body: Form(
          key: key,
          child: list.isEmpty
              ? Center(
                  child: Text("No Data"),
                )
              : ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, i) {
                    final x = list[i];
                    return Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(25.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  // Container(
                                  //   child:
                                  // Padding(
                                  //   padding:
                                  //       const EdgeInsets.only(top: 8.0, bottom: 20.0),
                                  //   child: Text(
                                  //     "Forms Jenis "+x.jenis_recon_v1 ?? "Kosong",
                                  //     style: TextStyle(
                                  //         fontFamily: "Poppins Bold", fontSize: 20.0),
                                  //   ),
                                  // ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text("ID Tiket : " +
                                            x.id_tiket.toString() +
                                            " - " +
                                            x.siteid.toString())),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  x.jenis_recon_v1 == "Waktu Close"
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10.0),
                                          child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text("Alasan : " +
                                                  x.alasan_submitrecon)),
                                        )
                                      // ButtonTheme(
                                      //     alignedDropdown: true,
                                      //     child: DropdownButtonHideUnderline(
                                      //         child: Container(
                                      //       width: double.infinity,
                                      //       child: DropdownButton<String>(
                                      //         value: _mySelection2,
                                      //         hint: new Text("Alasan"),
                                      //         // items: <String>['Terlambat Cover']
                                      //         //     .map((String value) {
                                      //         //   return DropdownMenuItem<String>(
                                      //         //     value: _mySelection,
                                      //         //     child: new Text(value),
                                      //         //   );
                                      //         // }).toList(),
                                      //         items: <String>[
                                      //           'Terlambat Cover',
                                      //           'Sistem Error'
                                      //         ].map((String value) {
                                      //           return DropdownMenuItem<String>(
                                      //             value: value,
                                      //             child: new Text(value),
                                      //           );
                                      //         }).toList(),
                                      //         onChanged: (newVal) {
                                      //           setState(() {
                                      //             _mySelection2 = newVal;
                                      //           });
                                      //         },
                                      //       ),
                                      //     )),
                                      //   )
                                      : x.jenis_recon_v1 == "Kondisi Site"
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10.0),
                                              child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text("Alasan : " +
                                                      x.alasan_submitrecon)),
                                            )
                                          : x.jenis_recon_v1 == "Dihapuskan"
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10.0),
                                                  child: Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text("Alasan : " +
                                                          x.alasan_submitrecon)),
                                                )
                                              : Container(),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  // TextFormField(
                                  //   validator: (e) {
                                  //     if (e.isEmpty) {
                                  //       return "Field tidak boleh kosong";
                                  //     }
                                  //   },
                                  //   // onSaved: (e) => nama_jalan = e,
                                  //   // controller: catResi,
                                  //   keyboardType: TextInputType.multiline,
                                  //   maxLines: null,
                                  //   decoration: InputDecoration(
                                  //       // labelText: 'Contoh: Sambalnya dipisah ya!',
                                  //       labelStyle: TextStyle(
                                  //         color: Color(0xFFBDC3C7),
                                  //         fontSize: 15,
                                  //         fontFamily: 'Poppins Regular',
                                  //       ),
                                  //       // border: InputBorder.none,
                                  //       // focusedBorder: InputBorder.none,
                                  //       // enabledBorder: InputBorder.none,
                                  //       // errorBorder: InputBorder.none,
                                  //       // disabledBorder: InputBorder.none,
                                  //       hintText: "Alasan Lebih Lanjut :"
                                  //       // enabledBorder: OutlineInputBorder(
                                  //       //   borderRadius: BorderRadius.circular(10),
                                  //       //   borderSide: BorderSide(
                                  //       //     color: Color(0xFF7F8C8D),
                                  //       //   ),
                                  //       // ),
                                  //       // focusedBorder: OutlineInputBorder(
                                  //       //   borderRadius: BorderRadius.circular(10),
                                  //       //   borderSide: BorderSide(color: Colors.black),
                                  //       // ),
                                  //       ),
                                  // ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 20.0),
                                      child: Text(
                                          "File Bukti (Harap masukan berurutan)"),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 0.0),
                                    child: Column(
                                      children: [
                                        Text("Foto Pekerjaan Lapangan :"),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            image1 == null
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 8.0),
                                                    child: Container(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            3.8,
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height /
                                                            7,
                                                        color: Colors.grey,
                                                        // foregroundDecoration: BoxDecoration(
                                                        //   image: DecorationImage(
                                                        //     image: AssetImage(
                                                        //       "assets/img/post_two.jpg",
                                                        //     ),
                                                        //     fit: BoxFit.fill,
                                                        //   ),
                                                        // ),
                                                        child: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child:
                                                              Text("No Image"),
                                                        )),
                                                  )
                                                : Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 8.0),
                                                    child: Container(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            3.8,
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height /
                                                            7,
                                                        color: Colors.grey,
                                                        // foregroundDecoration: BoxDecoration(
                                                        //   image: DecorationImage(
                                                        //     image: AssetImage(
                                                        //       "assets/img/post_two.jpg",
                                                        //     ),
                                                        //     fit: BoxFit.fill,
                                                        //   ),
                                                        // ),
                                                        child: Image.network(
                                                            ImageUrl.image +
                                                                image1)),
                                                  ),
                                            image2 == null
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 8.0),
                                                    child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            3.8,
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height /
                                                            7,
                                                        color: Colors.grey,
                                                        // foregroundDecoration: BoxDecoration(
                                                        //   image: DecorationImage(
                                                        //     image: AssetImage(
                                                        //       "assets/img/post_two.jpg",
                                                        //     ),
                                                        //     fit: BoxFit.fill,
                                                        //   ),
                                                        // ),
                                                        child: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child:
                                                              Text("No Image"),
                                                        )),
                                                  )
                                                : Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 8.0),
                                                    child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            3.8,
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height /
                                                            7,
                                                        color: Colors.grey,
                                                        // foregroundDecoration: BoxDecoration(
                                                        //   image: DecorationImage(
                                                        //     image: AssetImage(
                                                        //       "assets/img/post_two.jpg",
                                                        //     ),
                                                        //     fit: BoxFit.fill,
                                                        //   ),
                                                        // ),
                                                        child: Image.network(
                                                            ImageUrl.image +
                                                                image2)),
                                                  ),
                                            image3 == null
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 8.0),
                                                    child: Container(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            3.8,
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height /
                                                            7,
                                                        color: Colors.grey,
                                                        // foregroundDecoration: BoxDecoration(
                                                        //   image: DecorationImage(
                                                        //     image: AssetImage(
                                                        //       "assets/img/post_two.jpg",
                                                        //     ),
                                                        //     fit: BoxFit.fill,
                                                        //   ),
                                                        // ),
                                                        child: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child:
                                                              Text("No Image"),
                                                        )),
                                                  )
                                                : Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 8.0),
                                                    child: Container(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            3.8,
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height /
                                                            7,
                                                        color: Colors.grey,
                                                        // foregroundDecoration: BoxDecoration(
                                                        //   image: DecorationImage(
                                                        //     image: AssetImage(
                                                        //       "assets/img/post_two.jpg",
                                                        //     ),
                                                        //     fit: BoxFit.fill,
                                                        //   ),
                                                        // ),
                                                        child: Image.network(
                                                            ImageUrl.image +
                                                                image3)),
                                                  ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Divider(
                                            height: 2.0,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text("Foto Konfirmasi Operator :"),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            image4 == null
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 8.0),
                                                    child: Container(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            3.8,
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height /
                                                            7,
                                                        color: Colors.grey,
                                                        // foregroundDecoration: BoxDecoration(
                                                        //   image: DecorationImage(
                                                        //     image: AssetImage(
                                                        //       "assets/img/post_two.jpg",
                                                        //     ),
                                                        //     fit: BoxFit.fill,
                                                        //   ),
                                                        // ),
                                                        child: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child:
                                                              Text("No Image"),
                                                        )),
                                                  )
                                                : Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 8.0),
                                                    child: Container(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            3.8,
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height /
                                                            7,
                                                        color: Colors.grey,
                                                        // foregroundDecoration: BoxDecoration(
                                                        //   image: DecorationImage(
                                                        //     image: AssetImage(
                                                        //       "assets/img/post_two.jpg",
                                                        //     ),
                                                        //     fit: BoxFit.fill,
                                                        //   ),
                                                        // ),
                                                        child: Image.network(
                                                            ImageUrl.image +
                                                                image4)),
                                                  ),
                                            image5 == null
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 8.0),
                                                    child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            3.8,
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height /
                                                            7,
                                                        color: Colors.grey,
                                                        // foregroundDecoration: BoxDecoration(
                                                        //   image: DecorationImage(
                                                        //     image: AssetImage(
                                                        //       "assets/img/post_two.jpg",
                                                        //     ),
                                                        //     fit: BoxFit.fill,
                                                        //   ),
                                                        // ),
                                                        child: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child:
                                                              Text("No Image"),
                                                        )),
                                                  )
                                                : Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 8.0),
                                                    child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            3.8,
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height /
                                                            7,
                                                        color: Colors.grey,
                                                        // foregroundDecoration: BoxDecoration(
                                                        //   image: DecorationImage(
                                                        //     image: AssetImage(
                                                        //       "assets/img/post_two.jpg",
                                                        //     ),
                                                        //     fit: BoxFit.fill,
                                                        //   ),
                                                        // ),
                                                        child: Image.network(
                                                            ImageUrl.image +
                                                                image5)),
                                                  ),
                                            image6 == null
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 8.0),
                                                    child: Container(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            3.8,
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height /
                                                            7,
                                                        color: Colors.grey,
                                                        // foregroundDecoration: BoxDecoration(
                                                        //   image: DecorationImage(
                                                        //     image: AssetImage(
                                                        //       "assets/img/post_two.jpg",
                                                        //     ),
                                                        //     fit: BoxFit.fill,
                                                        //   ),
                                                        // ),
                                                        child: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child:
                                                              Text("No Image"),
                                                        )),
                                                  )
                                                : Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 8.0),
                                                    child: Container(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            3.8,
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height /
                                                            7,
                                                        color: Colors.grey,
                                                        // foregroundDecoration: BoxDecoration(
                                                        //   image: DecorationImage(
                                                        //     image: AssetImage(
                                                        //       "assets/img/post_two.jpg",
                                                        //     ),
                                                        //     fit: BoxFit.fill,
                                                        //   ),
                                                        // ),
                                                        child: Image.network(
                                                            ImageUrl.image +
                                                                image6)),
                                                  ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  x.jenis_recon_v1 == "Kondisi Site"
                                      ? Container(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 20.0, bottom: 10.0),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Awal",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                      fontFamily:
                                                          'Poppins Regular',
                                                    ),
                                                  ),
                                                  Text(
                                                    " * Kondisi Site",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                      fontFamily:
                                                          'Poppins Regular',
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10.0,
                                                            bottom: 10.0),
                                                    child: Text(x.kondisi_site,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    // InkWell(
                                                    //     onTap: () {
                                                    //       _selectDateOpen(context);
                                                    //     },
                                                    //     child: Container(
                                                    //         width: double.infinity,
                                                    //         decoration: BoxDecoration(
                                                    //             border: Border.all(
                                                    //                 color:
                                                    //                     Colors.black)),
                                                    //         child: Text(
                                                    //             "${selectedDateOpen.toLocal()}"
                                                    //                 .split(' ')[0]))),
                                                  ),
                                                  Divider(
                                                    height: 2,
                                                    color: Colors.black,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10.0),
                                                    child: Text(
                                                      "Revisi",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 15,
                                                        fontFamily:
                                                            'Poppins Regular',
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    " * Kondisi Site",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                      fontFamily:
                                                          'Poppins Regular',
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10.0,
                                                            bottom: 10.0),
                                                    child: Text(
                                                        x.kondisisite_afterrecon_v1 ??
                                                            "",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ),
                                                  Divider(
                                                    height: 2,
                                                    color: Colors.black,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 15.0),
                                                    child: Text("Keterangan :"),
                                                  ),
                                                  FocusScope(
                                                      node:
                                                          new FocusScopeNode(),
                                                      child: new TextFormField(
                                                        readOnly: true,
                                                        controller:
                                                            keterangan_solusi,
                                                        decoration:
                                                            new InputDecoration(
                                                          hintText:
                                                              'You cannot focus me',
                                                        ),
                                                      )),
                                                  // TextFormField(
                                                  //   onSaved: (e) =>
                                                  //       keterangan = e,
                                                  //   controller: keterangan_solusi,
                                                  //   keyboardType:
                                                  //       TextInputType.multiline,
                                                  //   maxLines: null,
                                                  //   decoration: InputDecoration(
                                                  //       // labelText: 'Contoh: Sambalnya dipisah ya!',
                                                  //       labelStyle: TextStyle(
                                                  //         color:
                                                  //             Color(0xFFBDC3C7),
                                                  //         fontSize: 15,
                                                  //         fontFamily:
                                                  //             'Poppins Regular',
                                                  //       ),
                                                  //       // border: InputBorder.none,
                                                  //       // focusedBorder: InputBorder.none,
                                                  //       // enabledBorder: InputBorder.none,
                                                  //       // errorBorder: InputBorder.none,
                                                  //       // disabledBorder: InputBorder.none,
                                                  //       hintText: "Optional"
                                                  //       // enabledBorder: OutlineInputBorder(
                                                  //       //   borderRadius: BorderRadius.circular(10),
                                                  //       //   borderSide: BorderSide(
                                                  //       //     color: Color(0xFF7F8C8D),
                                                  //       //   ),
                                                  //       // ),
                                                  //       // focusedBorder: OutlineInputBorder(
                                                  //       //   borderRadius: BorderRadius.circular(10),
                                                  //       //   borderSide: BorderSide(color: Colors.black),
                                                  //       // ),
                                                  //       ),
                                                  // ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      : x.jenis_recon_v1 == "Dihapuskan"
                                          ? Container(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 20.0, bottom: 10.0),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                bottom: 10.0),
                                                        child: Text(
                                                          "Awal",
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 15,
                                                            fontFamily:
                                                                'Poppins Regular',
                                                          ),
                                                        ),
                                                      ),
                                                      Divider(
                                                        height: 2,
                                                        color: Colors.black,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 10.0,
                                                                bottom: 10.0),
                                                        child: Text(
                                                          "Revisi",
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 15,
                                                            fontFamily:
                                                                'Poppins Regular',
                                                          ),
                                                        ),
                                                      ),
                                                      Divider(
                                                        height: 2,
                                                        color: Colors.black,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 15.0),
                                                        child: Text(
                                                            "Keterangan :"),
                                                      ),
                                                      FocusScope(
                                                          node:
                                                              new FocusScopeNode(),
                                                          child:
                                                              new TextFormField(
                                                            readOnly: true,
                                                            controller:
                                                                keterangan_solusi,
                                                            decoration:
                                                                new InputDecoration(
                                                              hintText:
                                                                  'You cannot focus me',
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Container(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 20.0, bottom: 10.0),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        "Tanggal Open",
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 15,
                                                          fontFamily:
                                                              'Poppins Regular',
                                                        ),
                                                      ),
                                                      Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 20.0,
                                                                  bottom: 20.0),
                                                          child: Text(
                                                              x.tgl_request)
                                                          // InkWell(
                                                          //     onTap: () {
                                                          //       _selectDateOpen(context);
                                                          //     },
                                                          //     child: Container(
                                                          //         width: double.infinity,
                                                          //         decoration: BoxDecoration(
                                                          //             border: Border.all(
                                                          //                 color:
                                                          //                     Colors.black)),
                                                          //         child: Text(
                                                          //             "${selectedDateOpen.toLocal()}"
                                                          //                 .split(' ')[0]))),
                                                          ),
                                                      Text(
                                                        "Tanggal Close Awal",
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 15,
                                                          fontFamily:
                                                              'Poppins Regular',
                                                        ),
                                                      ),
                                                      Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 20.0,
                                                                  bottom: 20.0),
                                                          child:
                                                              Text(x.tgl_close)
                                                          // InkWell(
                                                          //     onTap: () {
                                                          //       _selectDateClose(
                                                          //           context);
                                                          //     },
                                                          //     child: Container(
                                                          //         width: double.infinity,
                                                          //         decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                                                          //         child: Padding(
                                                          //           padding:
                                                          //               const EdgeInsets.all(
                                                          //                   8.0),
                                                          //           child: Text(
                                                          //               "${selectedDateClose.toLocal()}"
                                                          //                   .split(' ')[0]),
                                                          //         ))),
                                                          ),
                                                      Text(
                                                        "Tanggal Close Revisi",
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 15,
                                                          fontFamily:
                                                              'Poppins Regular',
                                                        ),
                                                      ),
                                                      Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 20.0,
                                                                  bottom: 20.0),
                                                          child: Text(x
                                                              .tanggalclose_afterrecon)),
                                                      Divider(
                                                        height: 2,
                                                        color: Colors.black,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 15.0),
                                                        child: Text(
                                                            "Keterangan :"),
                                                      ),
                                                      FocusScope(
                                                          node:
                                                              new FocusScopeNode(),
                                                          child:
                                                              new TextFormField(
                                                            readOnly: true,
                                                            controller:
                                                                keterangan_solusi,
                                                            decoration:
                                                                new InputDecoration(
                                                              hintText:
                                                                  'You cannot focus me',
                                                            ),
                                                          )),
                                                      // Text(
                                                      //   "Tanggal Pengajuan",
                                                      //   style: TextStyle(
                                                      //     color: Colors.black,
                                                      //     fontSize: 15,
                                                      //     fontFamily: 'Poppins Regular',
                                                      //   ),
                                                      // ),
                                                      // Padding(
                                                      //   padding: const EdgeInsets.only(
                                                      //       top: 20.0, bottom: 20.0),
                                                      //   child: InkWell(
                                                      //       onTap: () {
                                                      //         _selectDateShareCover(
                                                      //             context);
                                                      //       },
                                                      //       child: Container(
                                                      //           width: double.infinity,
                                                      //           decoration: BoxDecoration(
                                                      //               border: Border.all(
                                                      //                   color:
                                                      //                       Colors.black)),
                                                      //           child: Text(
                                                      //               "${selectedDateShareCover.toLocal()}"
                                                      //                   .split(' ')[0]))),
                                                      // ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                  // ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 8.0, top: 15.0),
                                    child: Container(
                                      alignment: Alignment.bottomCenter,
                                      child: FlatButton(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(3),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 0, horizontal: 25),
                                        onPressed: () {
                                          // Navigator.pop(context);
                                          // if (totalPrices.isEmpty) {
                                          //   _showToast("Keranjang Kosong");
                                          // } else {
                                          reject();
                                          // }
                                          // orderNow();
                                          // Navigator.push(
                                          //   context,
                                          //   new MaterialPageRoute(
                                          //     builder: (context) =>
                                          //         OrderPlaced(totalPrices[0].total_price.toString()),
                                          //   ),
                                          // );
                                        },
                                        color: Colors.red,
                                        child: Text("Reject",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 17,
                                              fontFamily: "Poppins Regular",
                                            )),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 8.0, top: 15.0),
                                    child: Container(
                                      alignment: Alignment.bottomCenter,
                                      child: FlatButton(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(3),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 0, horizontal: 25),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          // if (totalPrices.isEmpty) {
                                          //   _showToast("Keranjang Kosong");
                                          // } else {
                                          //   check();
                                          // }
                                          // orderNow();
                                          Navigator.push(
                                            context,
                                            new MaterialPageRoute(
                                              builder: (context) =>
                                                  AdminJenisPage(
                                                      x.id.toString()),
                                            ),
                                          );
                                        },
                                        color: Colors.green[400],
                                        child: Text("Edit",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 17,
                                              fontFamily: "Poppins Regular",
                                            )),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 15.0),
                                    child: Container(
                                      alignment: Alignment.bottomCenter,
                                      child: FlatButton(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(3),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 0, horizontal: 25),
                                        onPressed: () {
                                          // check();
                                          setState(() {
                                            _launchInBrowser(PDFUrl.export +
                                                x.id_tiket.toString() +
                                                x.siteid.toString() +
                                                "/" +
                                                x.id.toString());
                                          });
                                        },
                                        color: Color(0xffe3724b),
                                        child: Text("Lihat PDF",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 17,
                                              fontFamily: "Poppins Regular",
                                            )),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  })),
    );
  }
}
