import 'package:aplikasiklinik/themes/custom_colors.dart';
import 'package:aplikasiklinik/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfileControllerAdmin extends StatefulWidget {
  String? uid;
  String? nama;
  String? email;
  String? role;
  String? nomorHp;
  String? jekel;
  String? tglLahir;
  String? alamat;
  final bool isEdit;
  ProfileControllerAdmin(
      {Key? key,
      this.uid,
      this.nama,
      this.email,
      this.role,
      this.nomorHp,
      this.jekel,
      this.tglLahir,
      this.alamat,
      required this.isEdit})
      : super(key: key);

  final TextEditingController _nama = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _nomorHp = TextEditingController();
  final TextEditingController _tglLahir = TextEditingController();
  final TextEditingController _alamat = TextEditingController();

    String _jekel = "";

      Future<dynamic> updateData() async {  
    if (_nama.text.isEmpty ||
        _email.text.isEmpty ||
        _nomorHp.text.isEmpty ||
        _jekel.isEmpty ||
        _tglLahir.text.isEmpty ||
        _alamat.text.isEmpty) {
      var context;
      var widget;
      DocumentReference documentReference =
          FirebaseFirestore.instance.collection('users').doc(widget.uid);

      FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot documentSnapshot =
            await transaction.get(documentReference);

        if (documentSnapshot.exists) {
          transaction.update(documentReference, <String, dynamic>{
            'nama': _nama.text,
            'email': _email.text,
            'nomor hp': _nomorHp.text,
            'jenis kelamin': _jekel,
            'tanggal lahir': _tglLahir.text,
            'alamat': _alamat.text
          });
        }
      });

      infoUpdate();
    }
  }

  infoUpdate() {
    var context;
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text(titleSuccess),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  "Data Pribadi Anda Berhasil di Perbarui",
                ),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, '/homePagesAdmin'),
                  child: Text(
                    "OK",
                    style: TextStyle(color: colorPinkText),
                  ))
            ],
          );
        });
  }
  
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}