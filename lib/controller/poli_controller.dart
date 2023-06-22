import 'dart:async';

import 'package:aplikasiklinik/model/poli_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PoliController {
  final poliCollection = FirebaseFirestore.instance.collection('poli');

  final StreamController<List<DocumentSnapshot>> streamController =
      StreamController<List<DocumentSnapshot>>.broadcast();

  Stream<List<DocumentSnapshot>> get stream => streamController.stream;

  Future<void> addPoli(PoliModel pmmodel) async {
    final poli = pmmodel.toMap();

    final DocumentReference docref = await poliCollection.add(poli);

    final String docId = docref.id;

    final PoliModel poliModel = PoliModel(
      uId: docId,
      namaPoli: pmmodel.namaPoli
    );
    await docref.update(poliModel.toMap());
  }

  Future getPoli() async {
    final poli = await poliCollection.get();
    streamController.add(poli.docs);
    return poli.docs;
  }

  Future<void> updatePoli(PoliModel pmmodel) async {
    final poli = pmmodel.toMap();

    await poliCollection.doc(pmmodel.uId).update(poli);
  }

  Future<void> deletePoli(String uId) async {
    await poliCollection.doc(uId).delete();
    await getPoli();
    print('Delete poli with ID: $uId');
  }
}
