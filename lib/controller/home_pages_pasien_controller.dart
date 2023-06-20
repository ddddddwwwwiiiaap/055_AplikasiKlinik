import 'dart:async';

import 'package:aplikasiklinik/model/users_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class HomePagesPasienController{
  final userCollection = FirebaseFirestore.instance.collection('pasien');
  
  final StreamController<List<DocumentSnapshot>> streamController =
      StreamController<List<DocumentSnapshot>>.broadcast();

  Stream<List<DocumentSnapshot>> get stream => streamController.stream;

  Future addUser(UsersModel um) async{
    final user = um.toMap();

    final DocumentReference docref = await userCollection.add(user);

    final String docId = docref.id;

    final UsersModel userModel = UsersModel(
      uId: docId,
      nama: um.nama,
      email: um.email,
      role: um.role,
      nomorhp: um.nomorhp,
      jeniskelamin: um.jeniskelamin,
      tanggallahir: um.tanggallahir,
      alamat: um.alamat,
    );
    await docref.update(userModel.toMap());
  }

  Future getUser() async{
    final user = await userCollection.get();
    streamController.add(user.docs);
    return user.docs;
  }
}