import 'package:aplikasiklinik/controller/auth_controller.dart';
import 'package:aplikasiklinik/view/home_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RolesPages extends StatefulWidget {
  const RolesPages({super.key});

  @override
  State<RolesPages> createState() => _RolesPagesState();
}

class _RolesPagesState extends State<RolesPages> {
  final authCtr = AuthController();
  String? uid;
  String? nama;
  String? email;
  String? role;
  String? nomorHp;
  String? jekel;
  String? tglLahir;
  String? alamat;
  String? poli;

  Future<dynamic> getUser() async {
    await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((result) {
      if (result.docs.isNotEmpty) {
        setState(() {
          uid = result.docs[0].data()['uid'];
          nama = result.docs[0].data()['nama'];
          email = result.docs[0].data()['email'];
          role = result.docs[0].data()['role'];
          nomorHp = result.docs[0].data()['nomor hp'];
          tglLahir = result.docs[0].data()['tanggal lahir'];
          alamat = result.docs[0].data()['alamat'];
          poli = result.docs[0].data()['poli'];
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    if (role.toString() == "pasien") {
      return HomePages();
    } else if (role.toString() == "dokter") {
      return HomePages();
    }

    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}