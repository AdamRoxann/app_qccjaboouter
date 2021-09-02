import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qccjaboouter/in_app/Class/dihapuskan_class.dart';
import 'package:qccjaboouter/in_app/Class/kondisi_site_class.dart';
import 'package:qccjaboouter/in_app/dataPage.dart';
import 'package:qccjaboouter/model/data_forms.dart';
import 'package:qccjaboouter/model/data_penalty.dart';
import 'package:http/http.dart' as http;
import 'package:qccjaboouter/url.dart';
import 'package:path/path.dart' as path;
import 'package:async/async.dart';

class AdminForms extends StatefulWidget {
  final String id, jenis;
  AdminForms(this.id, this.jenis);
  @override
  _AdminFormsState createState() => _AdminFormsState();
}

class _AdminFormsState extends State<AdminForms> {
  final key = new GlobalKey<FormState>();
  String keterangan;

  check() {
    final form = key.currentState;
    if (form.validate()) {
      form.save();
      submit()();
    }
  }

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

  String old_value, old_value_revisi;
  var loading = false;
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
            keterangan_solusi.text = list[i].solusi;
            old_value = list[i].alasan_submitrecon;
            old_value_revisi = list[i].kondisisite_afterrecon_v1;
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

  submit() async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => _loading(context),
    );
    if (_imageFile1 == null) {
      if (widget.jenis == "Kondisi Site") {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) => _loading(context),
        );
        final response = await http.post(DataUrl.editData, body: {
          "id": widget.id,
          "jenis_recon_v1": widget.jenis,
          "alasan": _mySelection,
          "kondisi_site": _mySelection1,
          "keterangan": keterangan,
          "type": "Without Image"
        });

        final data = jsonDecode(response.body);
        int value = data['value'];
        String message = data['message'];
        // String messageEnglish = data['messageEnglish'];
        if (value == 1) {
          Navigator.push(
            context,
            new MaterialPageRoute(
              builder: (context) => DataPage(),
            ),
          );
          // registerToast(message);

        } else {
          Navigator.push(
            context,
            new MaterialPageRoute(
              builder: (context) => DataPage(),
            ),
          );
          // print(message);
          // registerToast(message);
        }
      } else if (widget.jenis == "Dihapuskan") {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) => _loading(context),
        );
        final response = await http.post(DataUrl.editData, body: {
          "id": widget.id,
          "jenis_recon_v1": widget.jenis,
          "alasan": _mySelection,
          "keterangan": keterangan,
          "type": "Without Image"
        });

        final data = jsonDecode(response.body);
        int value = data['value'];
        String message = data['message'];
        // String messageEnglish = data['messageEnglish'];
        if (value == 1) {
          Navigator.push(
            context,
            new MaterialPageRoute(
              builder: (context) => DataPage(),
            ),
          );
          // registerToast(message);

        } else {
          Navigator.push(
            context,
            new MaterialPageRoute(
              builder: (context) => DataPage(),
            ),
          );
          // print(message);
          // registerToast(message);
        }
      } else {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) => _loading(context),
        );
        final response = await http.post(DataUrl.editData, body: {
          "id": widget.id,
          "jenis_recon_v1": widget.jenis,
          "alasan": _mySelection2,
          "type": "Without Image",
          "tanggal_close_revisi": tanggal_close_revisi.toString()
        });

        final data = jsonDecode(response.body);
        int value = data['value'];
        String message = data['message'];
        // String messageEnglish = data['messageEnglish'];
        if (value == 1) {
          Navigator.push(
            context,
            new MaterialPageRoute(
              builder: (context) => DataPage(),
            ),
          );
          // registerToast(message);

        } else {
          Navigator.push(
            context,
            new MaterialPageRoute(
              builder: (context) => DataPage(),
            ),
          );
          // print(message);
          // registerToast(message);
        }
      }
    } else {
      if (widget.jenis == "Kondisi Site") {
        try {
          var stream1 =
              http.ByteStream(DelegatingStream.typed(_imageFile1.openRead()));
          var length1 = await _imageFile1.length();

          var stream2 =
              http.ByteStream(DelegatingStream.typed(_imageFile2.openRead()));
          var length2 = await _imageFile2.length();

          var stream3 =
              http.ByteStream(DelegatingStream.typed(_imageFile3.openRead()));
          var length3 = await _imageFile3.length();

          var stream4 =
              http.ByteStream(DelegatingStream.typed(_imageFile4.openRead()));
          var length4 = await _imageFile4.length();

          var stream5 =
              http.ByteStream(DelegatingStream.typed(_imageFile5.openRead()));
          var length5 = await _imageFile5.length();

          var stream6 =
              http.ByteStream(DelegatingStream.typed(_imageFile6.openRead()));
          var length6 = await _imageFile6.length();

          var uri = Uri.parse(DataUrl.editData);
          final request = http.MultipartRequest("POST", uri);
          request.fields['id'] = widget.id;
          request.fields['jenis_recon_v1'] = widget.jenis;
          request.fields['alasan'] = _mySelection;
          request.fields['kondisi_site'] = _mySelection1;
          request.fields['keterangan'] = keterangan;
          // request.fields['post_title'] = post_title;
          // request.fields['post_location'] = post_location;

          request.files.add(http.MultipartFile("image_name1", stream1, length1,
              filename: path.basename(_imageFile1.path)));
          request.files.add(http.MultipartFile("image_name2", stream2, length2,
              filename: path.basename(_imageFile2.path)));
          request.files.add(http.MultipartFile("image_name3", stream3, length3,
              filename: path.basename(_imageFile3.path)));
          request.files.add(http.MultipartFile("image_name4", stream4, length4,
              filename: path.basename(_imageFile4.path)));
          request.files.add(http.MultipartFile("image_name5", stream5, length5,
              filename: path.basename(_imageFile5.path)));
          request.files.add(http.MultipartFile("image_name6", stream6, length6,
              filename: path.basename(_imageFile6.path)));
          var response = await request.send();
          var responseData = await response.stream.toBytes();
          var responseString = String.fromCharCodes(responseData);
          print(responseString);
          if (response.statusCode > 2) {
            print("Image uploaded");
            setState(() {
              int count = 0;
              Navigator.of(context).popUntil((_) => count++ >= 3);
              // Navigator.pop(context);
            });
          } else {
            print("Image failed to be upload");
          }
        } catch (e) {
          debugPrint("Error $e");
        }
      } else if (widget.jenis == "Dihapuskan") {
        try {
          var stream1 =
              http.ByteStream(DelegatingStream.typed(_imageFile1.openRead()));
          var length1 = await _imageFile1.length();

          var stream2 =
              http.ByteStream(DelegatingStream.typed(_imageFile2.openRead()));
          var length2 = await _imageFile2.length();

          var stream3 =
              http.ByteStream(DelegatingStream.typed(_imageFile3.openRead()));
          var length3 = await _imageFile3.length();

          var stream4 =
              http.ByteStream(DelegatingStream.typed(_imageFile4.openRead()));
          var length4 = await _imageFile4.length();

          var stream5 =
              http.ByteStream(DelegatingStream.typed(_imageFile5.openRead()));
          var length5 = await _imageFile5.length();

          var stream6 =
              http.ByteStream(DelegatingStream.typed(_imageFile6.openRead()));
          var length6 = await _imageFile6.length();

          var uri = Uri.parse(DataUrl.editData);
          final request = http.MultipartRequest("POST", uri);
          request.fields['id'] = widget.id;
          request.fields['jenis_recon_v1'] = widget.jenis;
          request.fields['alasan'] = _mySelection;
          request.fields['keterangan'] = keterangan;
          // request.fields['post_title'] = post_title;
          // request.fields['post_location'] = post_location;

          request.files.add(http.MultipartFile("image_name1", stream1, length1,
              filename: path.basename(_imageFile1.path)));
          request.files.add(http.MultipartFile("image_name2", stream2, length2,
              filename: path.basename(_imageFile2.path)));
          request.files.add(http.MultipartFile("image_name3", stream3, length3,
              filename: path.basename(_imageFile3.path)));
          request.files.add(http.MultipartFile("image_name4", stream4, length4,
              filename: path.basename(_imageFile4.path)));
          request.files.add(http.MultipartFile("image_name5", stream5, length5,
              filename: path.basename(_imageFile5.path)));
          request.files.add(http.MultipartFile("image_name6", stream6, length6,
              filename: path.basename(_imageFile6.path)));
          var response = await request.send();
          var responseData = await response.stream.toBytes();
          var responseString = String.fromCharCodes(responseData);
          print(responseString);
          if (response.statusCode > 2) {
            print("Image uploaded");
            setState(() {
              int count = 0;
              Navigator.of(context).popUntil((_) => count++ >= 3);
              // Navigator.pop(context);
            });
          } else {
            print("Image failed to be upload");
          }
        } catch (e) {
          debugPrint("Error $e");
        }
      } else {
        try {
          var stream1 =
              http.ByteStream(DelegatingStream.typed(_imageFile1.openRead()));
          var length1 = await _imageFile1.length();

          var stream2 =
              http.ByteStream(DelegatingStream.typed(_imageFile2.openRead()));
          var length2 = await _imageFile2.length();

          var stream3 =
              http.ByteStream(DelegatingStream.typed(_imageFile3.openRead()));
          var length3 = await _imageFile3.length();

          var stream4 =
              http.ByteStream(DelegatingStream.typed(_imageFile4.openRead()));
          var length4 = await _imageFile4.length();

          var stream5 =
              http.ByteStream(DelegatingStream.typed(_imageFile5.openRead()));
          var length5 = await _imageFile5.length();

          var stream6 =
              http.ByteStream(DelegatingStream.typed(_imageFile6.openRead()));
          var length6 = await _imageFile6.length();

          var uri = Uri.parse(DataUrl.editData);
          final request = http.MultipartRequest("POST", uri);
          request.fields['id'] = widget.id;
          request.fields['jenis_recon_v1'] = widget.jenis;
          request.fields['alasan'] = _mySelection2;
          request.fields['tanggal_close_revisi'] =
              tanggal_close_revisi.toString();
          // request.fields['post_title'] = post_title;
          // request.fields['post_location'] = post_location;

          request.files.add(http.MultipartFile("image_name1", stream1, length1,
              filename: path.basename(_imageFile1.path)));
          request.files.add(http.MultipartFile("image_name2", stream2, length2,
              filename: path.basename(_imageFile2.path)));
          request.files.add(http.MultipartFile("image_name3", stream3, length3,
              filename: path.basename(_imageFile3.path)));
          request.files.add(http.MultipartFile("image_name4", stream4, length4,
              filename: path.basename(_imageFile4.path)));
          request.files.add(http.MultipartFile("image_name5", stream5, length5,
              filename: path.basename(_imageFile5.path)));
          request.files.add(http.MultipartFile("image_name6", stream6, length6,
              filename: path.basename(_imageFile6.path)));
          var response = await request.send();
          var responseData = await response.stream.toBytes();
          var responseString = String.fromCharCodes(responseData);
          print(responseString);
          if (response.statusCode > 2) {
            print("Image uploaded");
            setState(() {
              int count = 0;
              Navigator.of(context).popUntil((_) => count++ >= 3);
              // Navigator.pop(context);
            });
          } else {
            print("Image failed to be upload");
          }
        } catch (e) {
          debugPrint("Error $e");
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0F233D),
      appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white10,
          title: Text("Form Jenis " + widget.jenis)),
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
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                            "Alasan (Harap pilih kembali (wajib))")),
                                  ),
                                  widget.jenis == "Waktu Close"
                                      ?
                                      // Padding(
                                      //     padding:
                                      //         const EdgeInsets.only(top: 10.0),
                                      //     child: Align(
                                      //         alignment: Alignment.centerLeft,
                                      //         child: Text(
                                      //             "Alasan : Terlambat Cover")),
                                      //   )
                                      ButtonTheme(
                                          alignedDropdown: true,
                                          child: DropdownButtonHideUnderline(
                                              child: Container(
                                            width: double.infinity,
                                            child: DropdownButton<String>(
                                              value: _mySelection2,
                                              hint: Text(old_value ?? "Alasan"),
                                              // items: <String>['Terlambat Cover']
                                              //     .map((String value) {
                                              //   return DropdownMenuItem<String>(
                                              //     value: _mySelection,
                                              //     child: new Text(value),
                                              //   );
                                              // }).toList(),
                                              items: <String>[
                                                'Terlambat Cover',
                                                'Sistem Error'
                                              ].map((String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: new Text(value),
                                                );
                                              }).toList(),
                                              onChanged: (newVal) {
                                                setState(() {
                                                  _mySelection2 = newVal;
                                                });
                                              },
                                            ),
                                          )),
                                        )
                                      : widget.jenis == "Kondisi Site"
                                          ? ButtonTheme(
                                              alignedDropdown: true,
                                              child:
                                                  DropdownButtonHideUnderline(
                                                      child: Container(
                                                width: double.infinity,
                                                child: DropdownButton<String>(
                                                  value: _mySelection,
                                                  hint: Text(
                                                      old_value ?? "Alasan"),
                                                  // items: <String>['Terlambat Cover']
                                                  //     .map((String value) {
                                                  //   return DropdownMenuItem<String>(
                                                  //     value: _mySelection,
                                                  //     child: new Text(value),
                                                  //   );
                                                  // }).toList(),
                                                  items: <String>[
                                                    'Kondisi Site Hidup',
                                                    'Tidak Terkena Service Impact'
                                                  ].map((String value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value,
                                                      child: new Text(value),
                                                    );
                                                  }).toList(),
                                                  onChanged: (newVal) {
                                                    setState(() {
                                                      _mySelection = newVal;
                                                    });
                                                  },
                                                ),
                                              )),
                                            )
                                          : widget.jenis == "Dihapuskan"
                                              ? ButtonTheme(
                                                  alignedDropdown: true,
                                                  child:
                                                      DropdownButtonHideUnderline(
                                                          child: Container(
                                                    width: double.infinity,
                                                    child:
                                                        DropdownButton<String>(
                                                      value: _mySelection,
                                                      hint: Text(old_value ??
                                                          "Alasan"),
                                                      items: <String>[
                                                        'Double Ticket',
                                                        'RTPO Salah Create Ticket',
                                                        'Bukan SOW Mitra'
                                                      ].map((String value) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value: value,
                                                          child:
                                                              new Text(value),
                                                        );
                                                      }).toList(),
                                                      onChanged: (newVal) {
                                                        setState(() {
                                                          _mySelection = newVal;
                                                        });
                                                      },
                                                    ),
                                                  )),
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
                                            _imageFile1 != null
                                                ? InkWell(
                                                    onTap: () {
                                                      showDialog(
                                                        // barrierDismissible: false,
                                                        context: context,
                                                        builder: (BuildContext
                                                                context) =>
                                                            _popUpImage(context,
                                                                _imageFile1),
                                                      );
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 8.0),
                                                      child: Container(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          width:
                                                              MediaQuery.of(
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
                                                          child: Image.file(
                                                              _imageFile1)),
                                                    ),
                                                  )
                                                : image1 == null
                                                    ? InkWell(
                                                        onTap: () {
                                                          showDialog(
                                                            // barrierDismissible: false,
                                                            context: context,
                                                            builder: (BuildContext
                                                                    context) =>
                                                                _popUpImage(
                                                                    context,
                                                                    _imageFile1),
                                                          );
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
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
                                                              color:
                                                                  Colors.grey,
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
                                                                    Alignment
                                                                        .center,
                                                                child: Text(
                                                                    "No Image"),
                                                              )),
                                                        ),
                                                      )
                                                    : InkWell(
                                                        onTap: () {
                                                          showDialog(
                                                            // barrierDismissible: false,
                                                            context: context,
                                                            builder: (BuildContext
                                                                    context) =>
                                                                _popUpImage(
                                                                    context,
                                                                    _imageFile1),
                                                          );
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
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
                                                              color:
                                                                  Colors.grey,
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
                                                      ),
                                            _imageFile2 != null
                                                ? InkWell(
                                                    onTap: () {
                                                      showDialog(
                                                        // barrierDismissible: false,
                                                        context: context,
                                                        builder: (BuildContext
                                                                context) =>
                                                            _popUpImage(context,
                                                                _imageFile2),
                                                      );
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 8.0),
                                                      child: Container(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          width:
                                                              MediaQuery.of(
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
                                                          child: Image.file(
                                                              _imageFile2)),
                                                    ),
                                                  )
                                                : image2 == null
                                                    ? InkWell(
                                                        onTap: () {
                                                          showDialog(
                                                            // barrierDismissible: false,
                                                            context: context,
                                                            builder: (BuildContext
                                                                    context) =>
                                                                _popUpImage(
                                                                    context,
                                                                    _imageFile2),
                                                          );
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 8.0),
                                                          child: Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              width: MediaQuery
                                                                          .of(
                                                                              context)
                                                                      .size
                                                                      .width /
                                                                  3.8,
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height /
                                                                  7,
                                                              color:
                                                                  Colors.grey,
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
                                                                    Alignment
                                                                        .center,
                                                                child: Text(
                                                                    "No Image"),
                                                              )),
                                                        ),
                                                      )
                                                    : InkWell(
                                                        onTap: () {
                                                          showDialog(
                                                            // barrierDismissible: false,
                                                            context: context,
                                                            builder: (BuildContext
                                                                    context) =>
                                                                _popUpImage(
                                                                    context,
                                                                    _imageFile2),
                                                          );
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 8.0),
                                                          child: Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              width: MediaQuery
                                                                          .of(
                                                                              context)
                                                                      .size
                                                                      .width /
                                                                  3.8,
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height /
                                                                  7,
                                                              color:
                                                                  Colors.grey,
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
                                                      ),
                                            _imageFile3 != null
                                                ? InkWell(
                                                    onTap: () {
                                                      showDialog(
                                                        // barrierDismissible: false,
                                                        context: context,
                                                        builder: (BuildContext
                                                                context) =>
                                                            _popUpImage(context,
                                                                _imageFile3),
                                                      );
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 8.0),
                                                      child: Container(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          width:
                                                              MediaQuery.of(
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
                                                          child: Image.file(
                                                              _imageFile3)),
                                                    ),
                                                  )
                                                : image3 == null
                                                    ? InkWell(
                                                        onTap: () {
                                                          showDialog(
                                                            // barrierDismissible: false,
                                                            context: context,
                                                            builder: (BuildContext
                                                                    context) =>
                                                                _popUpImage(
                                                                    context,
                                                                    _imageFile3),
                                                          );
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
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
                                                              color:
                                                                  Colors.grey,
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
                                                                    Alignment
                                                                        .center,
                                                                child: Text(
                                                                    "No Image"),
                                                              )),
                                                        ),
                                                      )
                                                    : InkWell(
                                                        onTap: () {
                                                          showDialog(
                                                            // barrierDismissible: false,
                                                            context: context,
                                                            builder: (BuildContext
                                                                    context) =>
                                                                _popUpImage(
                                                                    context,
                                                                    _imageFile3),
                                                          );
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
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
                                                              color:
                                                                  Colors.grey,
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
                                            _imageFile4 != null
                                                ? InkWell(
                                                    onTap: () {
                                                      showDialog(
                                                        // barrierDismissible: false,
                                                        context: context,
                                                        builder: (BuildContext
                                                                context) =>
                                                            _popUpImage(context,
                                                                _imageFile4),
                                                      );
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 8.0),
                                                      child: Container(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          width:
                                                              MediaQuery.of(
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
                                                          child: Image.file(
                                                              _imageFile4)),
                                                    ),
                                                  )
                                                : image4 == null
                                                    ? InkWell(
                                                        onTap: () {
                                                          showDialog(
                                                            // barrierDismissible: false,
                                                            context: context,
                                                            builder: (BuildContext
                                                                    context) =>
                                                                _popUpImage(
                                                                    context,
                                                                    _imageFile4),
                                                          );
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
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
                                                              color:
                                                                  Colors.grey,
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
                                                                    Alignment
                                                                        .center,
                                                                child: Text(
                                                                    "No Image"),
                                                              )),
                                                        ),
                                                      )
                                                    : InkWell(
                                                        onTap: () {
                                                          showDialog(
                                                            // barrierDismissible: false,
                                                            context: context,
                                                            builder: (BuildContext
                                                                    context) =>
                                                                _popUpImage(
                                                                    context,
                                                                    _imageFile4),
                                                          );
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
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
                                                              color:
                                                                  Colors.grey,
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
                                                      ),
                                            _imageFile5 != null
                                                ? InkWell(
                                                    onTap: () {
                                                      showDialog(
                                                        // barrierDismissible: false,
                                                        context: context,
                                                        builder: (BuildContext
                                                                context) =>
                                                            _popUpImage(context,
                                                                _imageFile5),
                                                      );
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 8.0),
                                                      child: Container(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          width:
                                                              MediaQuery.of(
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
                                                          child: Image.file(
                                                              _imageFile5)),
                                                    ),
                                                  )
                                                : image5 == null
                                                    ? InkWell(
                                                        onTap: () {
                                                          showDialog(
                                                            // barrierDismissible: false,
                                                            context: context,
                                                            builder: (BuildContext
                                                                    context) =>
                                                                _popUpImage(
                                                                    context,
                                                                    _imageFile5),
                                                          );
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 8.0),
                                                          child: Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              width: MediaQuery
                                                                          .of(
                                                                              context)
                                                                      .size
                                                                      .width /
                                                                  3.8,
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height /
                                                                  7,
                                                              color:
                                                                  Colors.grey,
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
                                                                    Alignment
                                                                        .center,
                                                                child: Text(
                                                                    "No Image"),
                                                              )),
                                                        ),
                                                      )
                                                    : InkWell(
                                                        onTap: () {
                                                          showDialog(
                                                            // barrierDismissible: false,
                                                            context: context,
                                                            builder: (BuildContext
                                                                    context) =>
                                                                _popUpImage(
                                                                    context,
                                                                    _imageFile5),
                                                          );
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 8.0),
                                                          child: Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              width: MediaQuery
                                                                          .of(
                                                                              context)
                                                                      .size
                                                                      .width /
                                                                  3.8,
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height /
                                                                  7,
                                                              color:
                                                                  Colors.grey,
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
                                                      ),
                                            _imageFile6 != null
                                                ? InkWell(
                                                    onTap: () {
                                                      showDialog(
                                                        // barrierDismissible: false,
                                                        context: context,
                                                        builder: (BuildContext
                                                                context) =>
                                                            _popUpImage(context,
                                                                _imageFile6),
                                                      );
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 8.0),
                                                      child: Container(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          width:
                                                              MediaQuery.of(
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
                                                          child: Image.file(
                                                              _imageFile6)),
                                                    ),
                                                  )
                                                : image6 == null
                                                    ? InkWell(
                                                        onTap: () {
                                                          showDialog(
                                                            // barrierDismissible: false,
                                                            context: context,
                                                            builder: (BuildContext
                                                                    context) =>
                                                                _popUpImage(
                                                                    context,
                                                                    _imageFile6),
                                                          );
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
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
                                                              color:
                                                                  Colors.grey,
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
                                                                    Alignment
                                                                        .center,
                                                                child: Text(
                                                                    "No Image"),
                                                              )),
                                                        ),
                                                      )
                                                    : InkWell(
                                                        onTap: () {
                                                          showDialog(
                                                            // barrierDismissible: false,
                                                            context: context,
                                                            builder: (BuildContext
                                                                    context) =>
                                                                _popUpImage(
                                                                    context,
                                                                    _imageFile6),
                                                          );
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
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
                                                              color:
                                                                  Colors.grey,
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
                                                      ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  widget.jenis == "Kondisi Site"
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
                                                      "Revisi (Harap Pilih Kembali (WAJIB))",
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
                                                  // Padding(
                                                  //   padding:
                                                  //       const EdgeInsets.only(
                                                  //           top: 10.0,
                                                  //           bottom: 10.0),
                                                  //   child: Text(
                                                  //       x
                                                  //           .kondisisite_afterrecon_v1,
                                                  //       style: TextStyle(
                                                  //           fontWeight:
                                                  //               FontWeight
                                                  //                   .bold)),
                                                  // ),
                                                  ButtonTheme(
                                                    alignedDropdown: true,
                                                    child:
                                                        DropdownButtonHideUnderline(
                                                            child: Container(
                                                      width: double.infinity,
                                                      child: DropdownButton<
                                                          String>(
                                                        value: _mySelection1,
                                                        hint: Text(
                                                            old_value_revisi ??
                                                                "Kondisi Site"),
                                                        // items: <String>['Terlambat Cover']
                                                        //     .map((String value) {
                                                        //   return DropdownMenuItem<String>(
                                                        //     value: _mySelection,
                                                        //     child: new Text(value),
                                                        //   );
                                                        // }).toList(),
                                                        items: <String>[
                                                          'Mati',
                                                          'Akan Mati',
                                                          'Potential Mati',
                                                          'No Impact',
                                                        ].map((String value) {
                                                          return DropdownMenuItem<
                                                              String>(
                                                            value: value,
                                                            child:
                                                                new Text(value),
                                                          );
                                                        }).toList(),
                                                        onChanged: (newVal) {
                                                          setState(() {
                                                            _mySelection1 =
                                                                newVal;
                                                          });
                                                        },
                                                      ),
                                                    )),
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
                                                        validator: (e) {
                                                          if (e.isEmpty) {
                                                            return "Field tidak boleh kosong";
                                                          }
                                                        },
                                                        onSaved: (e) =>
                                                            keterangan = e,
                                                        // readOnly: true,
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
                                      : widget.jenis == "Dihapuskan"
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
                                                            validator: (e) {
                                                              if (e.isEmpty) {
                                                                return "Field tidak boleh kosong";
                                                              }
                                                            },
                                                            onSaved: (e) =>
                                                                keterangan = e,
                                                            // readOnly: true,
                                                            controller:
                                                                keterangan_solusi,
                                                            decoration:
                                                                new InputDecoration(
                                                              hintText:
                                                                  'Wajib Diisi',
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
                                                      // Padding(
                                                      //     padding:
                                                      //         const EdgeInsets
                                                      //                 .only(
                                                      //             top: 20.0,
                                                      //             bottom: 20.0),
                                                      //     child:
                                                      //     Text(x
                                                      //         .tanggalclose_afterrecon)),
                                                      // Text(
                                                      //   "Tanggal Pengajuan",
                                                      //   style: TextStyle(
                                                      //     color: Colors.black,
                                                      //     fontSize: 15,
                                                      //     fontFamily: 'Poppins Regular',
                                                      //   ),
                                                      // ),
                                                      // Padding(
                                                      //   padding:
                                                      //       const EdgeInsets
                                                      //               .only(
                                                      //           top: 20.0,
                                                      //           bottom: 20.0),
                                                      //   child: InkWell(
                                                      //       onTap: () {
                                                      //         _selectDateShareCover(
                                                      //             context);
                                                      //       },
                                                      //       child: Container(
                                                      //           width: double
                                                      //               .infinity,
                                                      //           decoration: BoxDecoration(
                                                      //               border: Border.all(
                                                      //                   color: Colors
                                                      //                       .black)),
                                                      //           child: Padding(
                                                      //             padding:
                                                      //                 const EdgeInsets
                                                      //                         .all(
                                                      //                     8.0),
                                                      //             child: Text(
                                                      //                 "${selectedDateShareCover.toLocal()}"
                                                      //                     .split(
                                                      //                         ' ')[0]),
                                                      //           ))),
                                                      // ),

                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 10.0,
                                                                left: 2),
                                                        child: Text(
                                                          "Before : " +
                                                              x.tanggalclose_afterrecon,
                                                        ),
                                                      ),
                                                      tanggal_close_revisi !=
                                                              null
                                                          ? Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 8.0),
                                                              child: InkWell(
                                                                  onTap: () {
                                                                    DatePicker.showDateTimePicker(
                                                                        context,
                                                                        showTitleActions:
                                                                            true,
                                                                        onChanged:
                                                                            (date) {
                                                                      print(
                                                                          '$date');
                                                                    }, onConfirm:
                                                                            (date) {
                                                                      setState(
                                                                          () {
                                                                        tanggal_close_revisi =
                                                                            date;
                                                                      });
                                                                    },
                                                                        currentTime:
                                                                            DateTime
                                                                                .now(),
                                                                        locale:
                                                                            LocaleType.id);
                                                                  },
                                                                  child: Text(
                                                                    "To : " +
                                                                        tanggal_close_revisi
                                                                            .toString(),
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .blue),
                                                                  )),
                                                            )
                                                          : TextButton(
                                                              onPressed: () {
                                                                DatePicker.showDateTimePicker(
                                                                    context,
                                                                    showTitleActions:
                                                                        true,
                                                                    onChanged:
                                                                        (date) {
                                                                  print(
                                                                      '$date');
                                                                }, onConfirm:
                                                                        (date) {
                                                                  setState(() {
                                                                    tanggal_close_revisi =
                                                                        date;
                                                                  });
                                                                },
                                                                    currentTime:
                                                                        DateTime
                                                                            .now(),
                                                                    locale:
                                                                        LocaleType
                                                                            .id);
                                                              },
                                                              child: Text(
                                                                'Ubah tanggal',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .blue),
                                                              )),
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
                                          Navigator.pop(context);
                                          // if (totalPrices.isEmpty) {
                                          //   _showToast("Keranjang Kosong");
                                          // } else {
                                          //   check();
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
                                        child: Text("Cancel",
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
                                          // if (totalPrices.isEmpty) {
                                          //   _showToast("Keranjang Kosong");
                                          // } else {
                                          check();
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
                                        color: Colors.green[400],
                                        child: Text("Save",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 17,
                                              fontFamily: "Poppins Regular",
                                            )),
                                      ),
                                    ),
                                  ),
                                  // Padding(
                                  //   padding: const EdgeInsets.only(top: 15.0),
                                  //   child: Container(
                                  //     alignment: Alignment.bottomCenter,
                                  //     child: FlatButton(
                                  //       shape: RoundedRectangleBorder(
                                  //         borderRadius:
                                  //             BorderRadius.circular(3),
                                  //       ),
                                  //       padding: EdgeInsets.symmetric(
                                  //           vertical: 0, horizontal: 25),
                                  //       onPressed: () {
                                  //         // check();
                                  //       },
                                  //       color: Color(0xffe3724b),
                                  //       child: Text("Lihat PDF",
                                  //           style: TextStyle(
                                  //             color: Colors.white,
                                  //             fontSize: 17,
                                  //             fontFamily: "Poppins Regular",
                                  //           )),
                                  //     ),
                                  //   ),
                                  // ),
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
