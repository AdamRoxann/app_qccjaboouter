import 'package:flutter/material.dart';
import 'package:qccjaboouter/in_app/Class/dihapuskan_class.dart';

class KondisiSiteForm extends StatefulWidget {
  @override
  _KondisiSiteFormState createState() => _KondisiSiteFormState();
}

class _KondisiSiteFormState extends State<KondisiSiteForm> {
  String _mySelection;

  List<DihapuskanCategory> categories = [
    DihapuskanCategory(
      '1',
      'Terlambat Cover',
    ),
  ];

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

  Future<void> _selectDateShareCover(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDateShareCover,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDateShareCover)
      setState(() {
        selectedDateShareCover = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
          // key: key,
          child: ListView(
        children: [
          Padding(
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
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 8.0, bottom: 20.0),
                          child: Text(
                            "Forms Jenis Kondisi Site",
                            style: TextStyle(
                                fontFamily: "Poppins Bold", fontSize: 20.0),
                          ),
                        ),
                        Divider(
                          height: 2,
                          color: Colors.black,
                          thickness: 0.5,
                        ),
                        TextFormField(
                          // onSaved: (e) => address_name = e,
                          validator: (e) {
                            if (e.isEmpty) {
                              return "Field tidak boleh kosong";
                            }
                          },
                          // controller: catOngkir,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: InputDecoration(
                              // labelText: 'Contoh: Sambalnya dipisah ya!',
                              labelStyle: TextStyle(
                                color: Color(0xFFBDC3C7),
                                fontSize: 15,
                                fontFamily: 'Poppins Regular',
                              ),
                              hintText: "ID TIKET"
                              // enabledBorder: OutlineInputBorder(
                              //   borderRadius: BorderRadius.circular(10),
                              //   borderSide: BorderSide(
                              //     color: Color(0xFF7F8C8D),
                              //   ),
                              // ),
                              // focusedBorder: OutlineInputBorder(
                              //   borderRadius: BorderRadius.circular(10),
                              //   borderSide: BorderSide(color: Colors.black),
                              // ),
                              ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButtonHideUnderline(
                              // child: DropdownButton<Cat>(
                              //   hint: new Text("Category"),
                              //   value: selectedCat,
                              //   onChanged: (Cat newValue) {
                              //     setState(() {
                              //       selectedCat = newValue;
                              //     });
                              //   },
                              //   items: users.map(
                              //     (Cat cat) {
                              //       return new DropdownMenuItem<Cat>(
                              //         value: cat,
                              //         child: new Text(
                              //           cat.name,
                              //           style: new TextStyle(
                              //             color: Colors.black,
                              //           ),
                              //         ),
                              //       );
                              //     },
                              //   ).toList(),
                              // ),
                              child: Container(
                            width: double.infinity,
                            child: DropdownButton<String>(
                              hint: new Text("Alasan"),
                              items: <String>['Terlambat Cover']
                                  .map((String value) {
                                return DropdownMenuItem<String>(
                                  value: _mySelection,
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
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          validator: (e) {
                            if (e.isEmpty) {
                              return "Field tidak boleh kosong";
                            }
                          },
                          // onSaved: (e) => nama_jalan = e,
                          // controller: catResi,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: InputDecoration(
                              // labelText: 'Contoh: Sambalnya dipisah ya!',
                              labelStyle: TextStyle(
                                color: Color(0xFFBDC3C7),
                                fontSize: 15,
                                fontFamily: 'Poppins Regular',
                              ),
                              // border: InputBorder.none,
                              // focusedBorder: InputBorder.none,
                              // enabledBorder: InputBorder.none,
                              // errorBorder: InputBorder.none,
                              // disabledBorder: InputBorder.none,
                              hintText: "Alasan Lebih Lanjut :"
                              // enabledBorder: OutlineInputBorder(
                              //   borderRadius: BorderRadius.circular(10),
                              //   borderSide: BorderSide(
                              //     color: Color(0xFF7F8C8D),
                              //   ),
                              // ),
                              // focusedBorder: OutlineInputBorder(
                              //   borderRadius: BorderRadius.circular(10),
                              //   borderSide: BorderSide(color: Colors.black),
                              // ),
                              ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 20.0, bottom: 10.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Tanggal Open",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontFamily: 'Poppins Regular',
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20.0, bottom: 20.0),
                                  child: InkWell(
                                      onTap: () {
                                        _selectDateOpen(context);
                                      },
                                      child: Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black)),
                                          child: Text(
                                              "${selectedDateOpen.toLocal()}"
                                                  .split(' ')[0]))),
                                ),
                                Text(
                                  "Tanggal Close",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontFamily: 'Poppins Regular',
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20.0, bottom: 20.0),
                                  child: InkWell(
                                      onTap: () {
                                        _selectDateClose(context);
                                      },
                                      child: Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black)),
                                          child: Text(
                                              "${selectedDateClose.toLocal()}"
                                                  .split(' ')[0]))),
                                ),
                                Text(
                                  "Tanggal Close Revisi",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontFamily: 'Poppins Regular',
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20.0, bottom: 20.0),
                                  child: InkWell(
                                      onTap: () {
                                        _selectDateShareCover(context);
                                      },
                                      child: Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black)),
                                          child: Text(
                                              "${selectedDateShareCover.toLocal()}"
                                                  .split(' ')[0]))),
                                ),
                                Text(
                                  "Tanggal Pengajuan",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontFamily: 'Poppins Regular',
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20.0, bottom: 20.0),
                                  child: InkWell(
                                      onTap: () {
                                        _selectDateShareCover(context);
                                      },
                                      child: Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black)),
                                          child: Text(
                                              "${selectedDateShareCover.toLocal()}"
                                                  .split(' ')[0]))),
                                ),
                              ],
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
                          padding: const EdgeInsets.only(right: 8.0, top: 15.0),
                          child: Container(
                            alignment: Alignment.bottomCenter,
                            child: FlatButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3),
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
                              color: Colors.grey[400],
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
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Container(
                            alignment: Alignment.bottomCenter,
                            child: FlatButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3),
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 25),
                              onPressed: () {
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
                                // setState(() {
                                //   order_idNya = widget.order_id;
                                // });
                                // check();
                              },
                              color: Color(0xffe3724b),
                              child: Text("Simpan",
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
          ),
        ],
      )),
    );
  }
}
