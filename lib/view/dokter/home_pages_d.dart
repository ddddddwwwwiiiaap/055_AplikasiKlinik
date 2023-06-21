import 'package:aplikasiklinik/themes/custom_colors.dart';
import 'package:aplikasiklinik/themes/material_colors.dart';
import 'package:aplikasiklinik/utils/constants.dart';
import 'package:aplikasiklinik/view/dokter/profile_pages_d.dart';
import 'package:aplikasiklinik/view/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class HomePagesDokter extends StatefulWidget {
  const HomePagesDokter({super.key});

  @override
  State<HomePagesDokter> createState() => _HomePagesDokterState();
}

class _HomePagesDokterState extends State<HomePagesDokter> {
  final Stream<QuerySnapshot> _streamAntrianPasien =
      FirebaseFirestore.instance.collection("antrian pasien").snapshots();

  String? _uid;
  String? _nama;
  String? _email;
  String? _role;
  String? _nomorHp;
  String? _jekel;
  String? _tglLahir;
  String? _alamat;
  int? _noAntrian;
  String? _poli;

  Future<dynamic> getUser() async {
    await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((result) {
      if (result.docs.isNotEmpty) {
        setState(() {
          _uid = result.docs[0].data()['uid'];
          _nama = result.docs[0].data()['nama'];
          _email = result.docs[0].data()['email'];
          _role = result.docs[0].data()['role'];
          _nomorHp = result.docs[0].data()['nomor hp'];
          _tglLahir = result.docs[0].data()['tanggal lahir'];
          _alamat = result.docs[0].data()['alamat'];
          _noAntrian = result.docs[0].data()['no antrian'];
          _poli = result.docs[0].data()['poli'];
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  showDialogExitToApp() {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text(titleLogout),
            content: Text(contentLogout),
            actions: [
              TextButton(
                  onPressed: signOut,
                  child: Text(textYa.toUpperCase())),
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(textTidak.toUpperCase()))
            ],
          );
        });
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(titleHome),
        actions: [
          IconButton(
              onPressed: showDialogExitToApp,
              icon: Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ))
        ],
      ),
      drawer: homeDrawer(),
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Stack(
          children: [buildIconHome(), buildTextTitle(), buildItemBody(size)],
        ),
      ),
    );
  }

  Widget homeDrawer() {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
              decoration: BoxDecoration(color: colorPrimary),
              child: Container(
                child: Center(
                  child: ListTile(
                    leading: Image.asset("assets/image/profil.png"),
                    title: Text(
                      "$_nama",
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      "ID dr : ${_uid?.substring(20, 27)}",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              )),
          ListTile(
            onTap: () => Navigator.pushNamed(context, '/homePagesDokter'),
            leading: Image.asset(
              "assets/icon/icon_home.png",
              width: 24,
            ),
            title: Text(
              titleHome,
            ),
          ),
          ListTile(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ProfilePagesDokter(
                        uid: _uid.toString(),
                        nama: _nama.toString(),
                        email: _email.toString(),
                        role: _role.toString(),
                        nomorHp: _nomorHp.toString(),
                        jekel: _jekel.toString(),
                        tglLahir: _tglLahir.toString(),
                        alamat: _alamat.toString(),
                        isEdit: true))),
            leading: Image.asset(
              "assets/icon/icon_profile.png",
              width: 24,
            ),
            title: Text(
              titleProfile,
            ),
          ),
          ListTile(
            onTap: () =>
                Navigator.pushNamed(context, '/daftarAntrianPagesDokter'),
            leading: Image.asset(
              "assets/icon/icon_daftar_antrian.png",
              width: 24,
            ),
            title: Text(
              titleDaftarAntrian,
            ),
          ),
          ListTile(
            onTap: () => Navigator.pushNamed(context, '/riwayatPasienMasuk'),
            leading: Image.asset(
              "assets/icon/icon_history.png",
              width: 24,
            ),
            title: Text(
              titleRiwayatPasienMasuk,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildIconHome() {
    return Positioned(
        child: Align(
            alignment: Alignment.topCenter,
            child: Image.asset("assets/image/hospital.png")));
  }

  Widget buildTextTitle() {
    return Positioned.fill(
      left: 16,
      top: 240,
      right: 0,
      bottom: 0,
      child: Text(
        "$textWelcome\n\nTetap Semangat Dokter\n$_nama",
        style: TextStyle(
            fontSize: 20, color: colorPinkText, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget buildItemBody(Size size) {
    return Positioned(
      child: Align(
        alignment: Alignment.center,
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 16, top: 140),
              width: size.width / 2,
              height: size.height / 7,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colorPinkText)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Jumlah Pasien Hari ini : ",
                    style: TextStyle(
                        color: colorPinkText, fontWeight: FontWeight.bold),
                  ),
                  StreamBuilder<QuerySnapshot>(
                      stream: _streamAntrianPasien,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return const Center(
                            child: Text("Error!"),
                          );
                        } else {
                          int totalAntrianPasien = snapshot.data!.docs.length;
                          return Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Column(
                              children: [
                                Text(
                                  "${int.parse(totalAntrianPasien.toString())}",
                                  style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: colorPinkText),
                                ),
                                Text("Orang", style: TextStyle(color: colorPinkText),)
                              ],
                            ),
                          );
                        }
                      }),
                ],
              ),
            ),
            Container(
                margin: const EdgeInsets.only(left: 24, top: 100),
                child: Image.asset("assets/image/suster.png"))
          ],
        ),
      ),
    );
  }
}
