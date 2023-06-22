import 'package:aplikasiklinik/controller/auth_controller.dart';
import 'package:aplikasiklinik/view/admin/home_pages_d.dart';
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
  String? uId;
  String? nama;
  String? email;
  String? role;
  String? nomorhp;
  String? jekel;
  String? tglLahir;
  String? alamat;

  @override
  void initState() {
    super.initState();
    authCtr.getUser();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Map<String, dynamic>? data = snapshot.data!.data();
          String? role = data!['role'];

          if (role.toString() == "pasien") {
            return const HomePages();
          } else if (role.toString() == "admin") {
            return const HomePagesAdmin();
          }

          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
