import 'package:aplikasiklinik/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../themes/custom_colors.dart';

class DaftarAntrianPagesAdmin extends StatefulWidget {
  const DaftarAntrianPagesAdmin({super.key});

  @override
  State<DaftarAntrianPagesAdmin> createState() =>
      _DaftarAntrianPagesAdminState();
}

class _DaftarAntrianPagesAdminState extends State<DaftarAntrianPagesAdmin> {
  final Stream<QuerySnapshot> _streamAntrianPasien =
      FirebaseFirestore.instance.collection("antrian pasien").snapshots();

  List _listStatusAntrian = ["Menunggu", "Proses", "Selesai", "Batal"];

  String? _selectedStatusAntrian;

  DateTime dtNow = DateTime.now();

  showEditStatus(docId, namaPasien, noAntrian, poli, status, tglAntrian,
      uidPasien, waktuAntrian) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return StatefulBuilder(builder: (_, setState) {
            return AlertDialog(
              title: Text("Edit Status Antrian"),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Status :"),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    child: DropdownButton(
                      items: _listStatusAntrian
                          .map((value) => DropdownMenuItem(
                                child: Text(
                                  value,
                                ),
                                value: value,
                              ))
                          .toList(),
                      onChanged: (selected) {
                        setState(() {
                          _selectedStatusAntrian = selected as String;
                        });
                      },
                      value: _selectedStatusAntrian,
                      isExpanded: true,
                      hint: const Text(
                        'Pilih Status Antrian',
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Batal")),
                ElevatedButton(
                    onPressed: () {
                      DocumentReference documentReference = FirebaseFirestore
                          .instance
                          .collection('antrian pasien')
                          .doc(docId);

                      FirebaseFirestore.instance
                          .runTransaction((transaction) async {
                        DocumentSnapshot documentSnapshot =
                            await transaction.get(documentReference);

                        if (documentSnapshot.exists) {
                          transaction
                              .update(documentReference, <String, dynamic>{
                            'status': _selectedStatusAntrian.toString(),
                          });
                        }
                      });
                      createRiwayatPasienMasuk(docId, namaPasien, noAntrian,
                          poli, status, tglAntrian, uidPasien, waktuAntrian);
                      if (_selectedStatusAntrian.toString() == "Proses") {
                        updateNoAntrianSedangDilayani(noAntrian);
                      }
                      Navigator.pop(context);
                      infoUpdate();
                    },
                    style: ButtonStyle(
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)))),
                    child: Text("Simpan")),
              ],
            );
          });
        });
  }

  Future<dynamic> createRiwayatPasienMasuk(uId, namaPasien, noAntrian, poli,
      status, tglAntrian, uidPasien, waktuAntrian) async {
    String timeNow = DateFormat.jm().format(dtNow);
    try {
      User? users = FirebaseAuth.instance.currentUser;

      await FirebaseFirestore.instance
          .collection('riwayat pasien masuk')
          .doc(uId)
          .set({
        'doc id': uId.toString(),
        'uid pasien': uidPasien.toString(),
        'nama pasien': namaPasien.toString(),
        'poli': poli.toString(),
        'tanggal antrian': tglAntrian.toString(),
        'waktu antrian': waktuAntrian.toString(),
        'selesai antrian': timeNow,
        'noantrian': noAntrian,
        'status': _selectedStatusAntrian.toString()
      });
    } catch (e) {
      return e.toString();
    }
  }

  updateNoAntrianSedangDilayani(noAntrian) {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('sedang dilayani').doc('avpg6d1x7v6iAnmkVERw');

    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot documentSnapshot =
          await transaction.get(documentReference);

      if (documentSnapshot.exists) {
        transaction.update(documentReference, <String, dynamic>{
          'noantrian': noAntrian,
        });
      }
    });
  }

  infoUpdate() {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text(titleSuccess),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  "Status Antrian Berhasil di Perbarui",
                ),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "OK",
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
        title: Text(titleDaftarAntrian),
      ),
      body: SizedBox(
          width: size.width,
          height: size.height,
          child: buildListAntrian(size)),
    );
  }

  Widget buildListAntrian(Size size) {
    return StreamBuilder(
        stream: _streamAntrianPasien,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("Error!"),
            );
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("Belum Ada Data!"),
            );
          } else {
            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot data) {
                return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  child: Container(
                       padding: const EdgeInsets.all(8),
                      child: ListTile(
                        title: Text(
                            "${data['uid pasien']}"
                                .toUpperCase()
                                .substring(20, 27),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            )),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 12, bottom: 4),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("No. Antrian"),
                                  Text(
                                    "${data['noantrian']}",
                                    style: TextStyle(
                                        color: colorPinkText,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Nama Pemesan"),
                                  Text(
                                    "${data['nama pasien']}",
                                    style: TextStyle(
                                        color: colorPinkText,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Waktu Pemeriksaan"),
                                  Text(
                                    "${data['waktu antrian']}",
                                    style: TextStyle(
                                        color: colorPinkText,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 16, bottom: 4),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Status"),
                                  GestureDetector(
                                    onTap: () => showEditStatus(
                                      data['doc id'],
                                      data['nama pasien'],
                                      data['noantrian'],
                                      data['poli'],
                                      data['status'],
                                      data['tanggal antrian'],
                                      data['uid pasien'],
                                      data['waktu antrian'],
                                    ),
                                    child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4, horizontal: 8),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: Colors.blue.shade100),
                                        child: Row(
                                          children: [
                                            Text(
                                              "${data['status']}",
                                              style: TextStyle(
                                                  color: Colors.blueAccent,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Icon(Icons.arrow_drop_down)
                                          ],
                                        )),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),
                );
              }).toList(),
            );
          }
        });
  }
}
