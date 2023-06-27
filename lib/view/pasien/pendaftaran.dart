// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:aplikasiklinik/view/pasien/home_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:aplikasiklinik/controller/pendaftaran_controller.dart';
import 'package:aplikasiklinik/controller/poli_controller.dart';
import 'package:aplikasiklinik/model/pendaftaranpasien_model.dart';
import 'package:aplikasiklinik/themes/custom_colors.dart';
import 'package:aplikasiklinik/themes/material_colors.dart';
import 'package:aplikasiklinik/utils/constants.dart';

class Pendaftaran extends StatefulWidget {
  String? uId;
  String? nama;
  Pendaftaran({
    Key? key,
    this.uId,
    this.nama,
  }) : super(key: key);

  @override
  State<Pendaftaran> createState() => _PendaftaranState();
}

class _PendaftaranState extends State<Pendaftaran> {
  var pendaftaranController = PendaftaranController();
  var poliController = PoliController();
  final _formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();
  String? setDate, setTime;
  String? hour, minute, time;
  TimeOfDay selectedTime = const TimeOfDay(hour: 00, minute: 00);

  int? noantrian;
  String? status;
  final TextEditingController tanggalantrian = TextEditingController();
  final TextEditingController waktuantrian = TextEditingController();
  String? namaPoli;

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null)
      // ignore: curly_braces_in_flow_control_structures
      setState(() {
        selectedDate = picked;
        tanggalantrian.text = DateFormat.yMd().format(selectedDate);
      });
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      // ignore: curly_braces_in_flow_control_structures
      setState(() {
        selectedTime = picked;
        hour = selectedTime.hour.toString();
        minute = selectedTime.minute.toString();
        time = hour! + ' : ' + minute!;
        waktuantrian.text = time!;
        waktuantrian.text = formatDate(
            DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]).toString();
      });
  }

  @override
  void initState() {
    tanggalantrian.text = DateFormat.yMd().format(DateTime.now());

    waktuantrian.text = formatDate(
        DateTime(2019, 08, 1, DateTime.now().hour, DateTime.now().minute),
        [hh, ':', nn, " ", am]).toString();
    super.initState();
  }

  Future<dynamic> createAntrianPoli() async {
    if (_formKey.currentState!.validate()) {
      showAlertDialogLoading(context);
      try {
        User? users = FirebaseAuth.instance.currentUser;
        QuerySnapshot docUsersAntrian = await FirebaseFirestore.instance
            .collection('users')
            .doc(users!.uid)
            .collection('antrian')
            .get();
        List<DocumentSnapshot> docUserAntrianCount = docUsersAntrian
            .docs; //berfungsi untuk menghitung jumlah antrian yang sudah diambil oleh user

        final docId = await FirebaseFirestore.instance
            .collection('users')
            .doc(users.uid)
            .collection('antrian')
            .add({
          'uid pasien': widget.uId.toString(),
          'nama pasien': widget.nama.toString(),
          'poli': namaPoli.toString(),
          'tanggal antrian': tanggalantrian.text,
          'waktu antrian': waktuantrian.text,
          'noantrian': docUserAntrianCount.length + 1
        });

        QuerySnapshot docAntrianPasien =
            await FirebaseFirestore.instance.collection('antrian pasien').get();
        List<DocumentSnapshot> docAntrianPasienCount = docAntrianPasien.docs;

        await FirebaseFirestore.instance
            .collection('antrian pasien')
            .doc(docId.id)
            .set({
          'uid pasien': widget.uId.toString(),
          'doc id': docId.id.toString(),
          'nama pasien': widget.nama.toString(),
          'poli': namaPoli.toString(),
          'tanggal antrian': tanggalantrian.text,
          'waktu antrian': waktuantrian.text,
          'noantrian': docAntrianPasienCount.length + 1,
          'status': 'Menunggu'
        });
        updateDataUsers();
        Navigator.pop(context);
        signUpDialog();
      } catch (e) {
        return e.toString();
      }
    }
  }

  Future<dynamic> updateDataUsers() async {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('users').doc(widget.uId);

    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot documentSnapshot =
          await transaction.get(documentReference);

      if (documentSnapshot.exists) {
        transaction.update(documentReference, <String, dynamic>{
          'noantrian': FieldValue.increment(1),
          'poli': namaPoli.toString()
        });
      }
    });
  }

  showAlertDialogLoading(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          Container(
              margin: const EdgeInsets.only(left: 15),
              child: const Text(
                "Loading...",
                style: TextStyle(fontSize: 12),
              )),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  signUpDialog() {
    return showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text(titleSuccess),
            content: const Text('Antrian Anda Telah Terdaftar!'),
            actions: [
              TextButton(
                  onPressed: () =>
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePages()),
                  ),
                  child: const Text(
                    'OK',
                    style: TextStyle(color: colorPinkText),
                  ))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(titleDaftarAntrian),
      ),
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Column(
          children: [
            buildTextTitle(),
            buildFormAmbilAntrian(size),
            buildButtonDaftar(),
            // buildFooter(size)
          ],
        ),
      ),
    );
  }

  Widget buildTextTitle() {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 40),
        child: Text(textAmbilAntrian,
            style: TextStyle(
                color: colorPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold)));
  }

  Widget buildFormAmbilAntrian(Size size) {
    final format = DateFormat('dd-MM-yyyy');
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Text(
                      "Poli",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  FutureBuilder<List>(
                    future: pendaftaranController.getPolis(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) print(snapshot.error);
                      return snapshot.hasData
                          ? DropdownButtonFormField(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8))),
                              hint: const Text("Pilih Poli"),
                              value: namaPoli,
                              onChanged: (newValue) {
                                setState(() {
                                  namaPoli = newValue.toString();
                                });
                              },
                              items: snapshot.data!
                                  .map((value) => DropdownMenuItem(
                                        child: Text(value['namaPoli']),
                                        value: value['namaPoli'],
                                      ))
                                  .toList(),
                            )
                          : const Center(
                              child: CircularProgressIndicator(),
                            );
                    },
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 16),
                          child: Text(
                            "Tanggal",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            _selectDate(context);
                          },
                          child: Container(
                            width: size.width,
                            margin: const EdgeInsets.only(top: 16),
                            alignment: Alignment.center,
                            decoration:
                                const BoxDecoration(color: colorButtonHome),
                            child: TextFormField(
                              style: const TextStyle(fontSize: 18),
                              enabled: false,
                              keyboardType: TextInputType.text,
                              controller: tanggalantrian,
                              onSaved: (String? val) {
                                setDate = val!;
                              },
                              decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.calendar_month,
                                    color: colorPrimary,
                                  ),
                                  disabledBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide.none),
                                  contentPadding:
                                      const EdgeInsets.only(top: 12)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 16),
                          child: Text(
                            "Waktu",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            _selectTime(context);
                          },
                          child: Container(
                            width: size.width,
                            margin: const EdgeInsets.only(top: 16),
                            alignment: Alignment.center,
                            decoration:
                                const BoxDecoration(color: colorButtonHome),
                            child: TextFormField(
                              style: const TextStyle(fontSize: 18),
                              enabled: false,
                              keyboardType: TextInputType.text,
                              controller: waktuantrian,
                              onSaved: (String? val) {
                                setDate = val!;
                              },
                              decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.calendar_month,
                                    color: colorPrimary,
                                  ),
                                  disabledBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide.none),
                                  contentPadding:
                                      const EdgeInsets.only(top: 12)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButtonDaftar() {
    return ElevatedButton(
        onPressed: createAntrianPoli,
        style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(colorButton),
            shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24)))),
        child: Container(
            width: 120,
            height: 40,
            child: Center(
                child: Text(
              textButtonDaftar,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ))));
  }

  Widget buildFooter(Size size) {
    return Container(
      margin: const EdgeInsets.only(top: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: size.width / 2,
            child: Stack(
              children: [
                Image.asset("assets/ellipse/ellipse4.png"),
                Positioned.fill(
                    left: 0,
                    top: 32,
                    right: 0,
                    bottom: 0,
                    child: Text(
                      "Hy kak ${widget.nama},\n$textInformasiDaftarAntrian",
                      textAlign: TextAlign.center,
                    )),
              ],
            ),
          ),
          Image.asset("assets/image/suster.png")
        ],
      ),
    );
  }
}
