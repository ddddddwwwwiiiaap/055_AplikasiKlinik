import 'dart:async';
import 'package:aplikasiklinik/utils/constants.dart';
import 'package:aplikasiklinik/view/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePagesPasienController {
  final usersCollection = FirebaseFirestore.instance.collection('users');

  final StreamController<List<DocumentSnapshot>> streamController =
      StreamController<List<DocumentSnapshot>>.broadcast();

  Stream<List<DocumentSnapshot>> get stream => streamController.stream;

  // Future addUser(UsersModel um) async{
  //   final user = um.toMap();

  //   final DocumentReference docref = await userCollection.add(user);

  //   final String docId = docref.id;

  //   final UsersModel userModel = UsersModel(
  //     uId: docId,
  //     nama: um.nama,
  //     email: um.email,
  //     role: um.role,
  //     nomorhp: um.nomorhp,
  //     jekel: um.jekel,
  //     tglLahir: um.tglLahir,
  //     alamat: um.alamat,
  //   );
  //   await docref.update(userModel.toMap());
  // }

  Future getUsers() async {
    final users = await usersCollection.get();
    streamController.add(users.docs);
    return users.docs;
  }

  // Future getUser() async{
  //   final user = await usersCollection.get();
  //   streamController.add(user.docs);
  //   return user.docs;
  // }

  // showDialogExitToApp() {
  //   showDialog(
  //     context: context,
  //     builder: (_) {
  //       return AlertDialog(
  //         title: Text(titleLogout),
  //         content: Text(contentLogout),
  //         actions: [
  //           TextButton(onPressed: signOut, child: Text(textYa.toUpperCase())),
  //           TextButton(
  //             onPressed: () => Navigator.pop(context),
  //             child: Text(
  //               textTidak.toUpperCase(),
  //             ),
  //           )
  //         ],
  //       );
  //     },
  //   );
  // }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    // Navigator.pushNamedAndRemoveUntil(
    //   context,
    //   MaterialPageRoute(
    //       builder: ((context) => const Login()), (route) => false),
    // );
  }
}
