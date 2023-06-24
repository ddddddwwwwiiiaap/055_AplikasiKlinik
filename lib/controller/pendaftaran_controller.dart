import 'dart:async';

import 'package:aplikasiklinik/controller/poli_controller.dart';
import 'package:aplikasiklinik/model/pendaftaranpasien_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PendaftaranController {
  String? uId;
  String? nama;
  var poliController = PoliController();
  String? noantrian;
  String? status;
  String? namaPoli;

  final TextEditingController tanggalantrian = TextEditingController();
  final TextEditingController waktuantrian = TextEditingController();

  final contactCollection =
      FirebaseFirestore.instance.collection('antrian pasien');

  final StreamController<List<DocumentSnapshot>> streamController =
      StreamController<List<DocumentSnapshot>>.broadcast();

  Stream<List<DocumentSnapshot>> get stream => streamController.stream;

  DateTime selectedDate = DateTime.now();

  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  String? hour, minute, time;

  Future<void> addPendaftaran(PendaftaranPasienModel ppmc) async {
    final pendaftaran = ppmc.toMap();

    final DocumentReference docRef = await contactCollection.add(pendaftaran);

    final String docId = docRef.id;

    final PendaftaranPasienModel pendaftaranPasienModel =
        PendaftaranPasienModel(
      uId: docId,
      noantrian: pendaftaran['noantrian'] as int,
      status: pendaftaran['status'] as String,
      waktuantrian: pendaftaran['waktuantrian'] as String,
      tanggalantrian: pendaftaran['tanggalantrian'] as String,
      poli: pendaftaran['poli'] as String,
    );
    await docRef.update(pendaftaranPasienModel.toMap());
  }

  //Future untuk mengambil data poli dari firebase agar bisa ditampilkan di dropdown
  Future<List> getPolis() async {
    var polis = await poliController.getPoli();
    return polis;
  }

//berfungsi untuk menghitung jumlah antrian yang sudah diambil oleh user
  Future<dynamic> createAntrianPoli() async {
    try {
      User? users = FirebaseAuth.instance.currentUser;
      QuerySnapshot docUsersAntrian = await FirebaseFirestore.instance
          .collection('users')
          .doc(users!.uid)
          .collection('antrian')
          .get();
      List<DocumentSnapshot> docUserAntrianCount = docUsersAntrian.docs;

      final docId = await FirebaseFirestore.instance
          .collection('users')
          .doc(users.uid)
          .collection('antrian')
          .add({
        'uid pasien': uId.toString(),
        'nama pasien': nama.toString(),
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
        'uid pasien': uId.toString(),
        'doc id': docId.id.toString(),
        'nama pasien': nama.toString(),
        'poli': namaPoli.toString(),
        'tanggal antrian': tanggalantrian.text,
        'waktu antrian': waktuantrian.text,
        'noantrian': docAntrianPasienCount.length + 1,
        'status': 'Menunggu'
      });
      updateDataUsers();
      return docId;
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> updateDataUsers() async {
    var widget;
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
}
