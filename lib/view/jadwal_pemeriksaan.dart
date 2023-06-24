import 'package:aplikasiklinik/controller/jadwal_Pemeriksaan.dart';
import 'package:aplikasiklinik/themes/custom_colors.dart';
import 'package:aplikasiklinik/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class JadwalPemeriksaanPages extends StatefulWidget {
  String? uid;
  JadwalPemeriksaanPages({
    Key? key,
    this.uid,
  }) : super(key: key);

  @override
  State<JadwalPemeriksaanPages> createState() => _JadwalPemeriksaanPagesState();
}

class _JadwalPemeriksaanPagesState extends State<JadwalPemeriksaanPages> {
  var jadwalPemeriksaan = JadwalPemeriksaan();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: colorHome,
      appBar: AppBar(
        title: Text(titleJadwalPemeriksaan),
      ),
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Stack(
          children: [buildBackground(size), buildImageBottom()],
        ),
      ),
    );
  }

  Widget buildBackground(Size size) {
    return Container(
        margin: const EdgeInsets.all(24),
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24), color: Colors.white),
        child: StreamBuilder(
            stream: jadwalPemeriksaan.streamAntrianUsers,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                    return Container(
                      padding: const EdgeInsets.all(8),
                      child: ListTile(
                        title: Text("poli ${data['poli']}".toUpperCase(),
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
                                    "${data['no antrian']}",
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
                                  Text("Tanggal"),
                                  Text(
                                    "${data['tanggal antrian']}",
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
                                  Text("Jam"),
                                  Text(
                                    "${data['waktu antrian']}",
                                    style: TextStyle(
                                        color: colorPinkText,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                            Divider()
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Hapus Data"),
                                  content: Text(
                                      "Apakah Anda yakin ingin menghapus data ini?"),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text("Batal"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: Text("Hapus"),
                                      onPressed: () {
                                        jadwalPemeriksaan.deleteData(data.id);
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ),
                    );
                  }).toList(),
                );
              }
            }));
  }

  Widget buildImageBottom() {
    return Positioned(
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          child: Image.asset("assets/image/suster3.png"),
        ),
      ),
    );
  }
}
