import 'package:aplikasiklinik/model/users_model.dart';
import 'package:aplikasiklinik/themes/custom_colors.dart';
import 'package:aplikasiklinik/themes/material_colors.dart';
import 'package:aplikasiklinik/utils/constants.dart';
import 'package:aplikasiklinik/view/admin/profile_pages_a.dart';
import 'package:aplikasiklinik/view/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePagesAdmin extends StatefulWidget {
  const HomePagesAdmin({super.key});

  @override
  State<HomePagesAdmin> createState() => _HomePagesAdminState();
}

class _HomePagesAdminState extends State<HomePagesAdmin> {
  final Stream<QuerySnapshot> _streamAntrianPasien =
      FirebaseFirestore.instance.collection("antrian pasien").snapshots();

  String? uId;
  String? nama;
  String? email;
  String? role;
  String? nomorhp;
  String? jekel;
  String? tglLahir;
  String? alamat;
  int? noAntrian;
  String? poli;

  Future<UsersModel?> getUser() async {
    await FirebaseFirestore.instance
        .collection('users')
        .where('uId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then(
      (result) {
        if (result.docs.isNotEmpty) {
          setState(
            () {
              uId = result.docs[0].data()['uId'];
              nama = result.docs[0].data()['nama'];
              email = result.docs[0].data()['email'];
              role = result.docs[0].data()['role'];
              nomorhp = result.docs[0].data()['nomorhp'];
              tglLahir = result.docs[0].data()['tGLlahir'];
              alamat = result.docs[0].data()['alamat'];
              //_noAntrian = result.docs[0].data()['noantrian'];
              //_poli = result.docs[0].data()['poli'];
            },
          );
        }
      },
    );
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
            TextButton(onPressed: signOut, child: Text(textYa.toUpperCase())),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                textTidak.toUpperCase(),
              ),
            )
          ],
        );
      },
    );
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
              icon: const Icon(
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
                      "$nama",
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      "ID dr : ${uId?.substring(20, 27)}",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              )),
          ListTile(
            onTap: () => Navigator.pushNamed(context, '/homePagesAdmin'),
            leading: Image.asset(
              "assets/icon/icon_home.png",
              width: 24,
            ),
            title: const Text(
              titleHome,
            ),
          ),
          ListTile(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProfilePagesAdmin(
                    uid: uId.toString(),
                    nama: nama.toString(),
                    email: email.toString(),
                    role: role.toString(),
                    nomorHp: nomorhp.toString(),
                    jekel: jekel.toString(),
                    tglLahir: tglLahir.toString(),
                    alamat: alamat.toString(),
                    isEdit: true),
              ),
            ),
            leading: Image.asset(
              "assets/icon/icon_profile.png",
              width: 24,
            ),
            title: Text(
              titleProfile,
            ),
          ),
          //poli
          ListTile( 
            onTap: () => 
                Navigator.pushNamed(context, '/poliPagesAdmin'),
            leading: Image.asset(
              "assets/icon/icon_daftar_antrian.png",
              width: 24,
            ),
            title: const Text(
              titlePoli,
            ),
          ),
          ListTile(
            onTap: () =>
                Navigator.pushNamed(context, '/daftarAntrianPagesAdmin'),
            leading: Image.asset(
              "assets/icon/icon_daftar_antrian.png",
              width: 24,
            ),
            title: const Text(
              titleDaftarAntrian,
            ),
          ),
          ListTile(
            onTap: () => Navigator.pushNamed(context, '/riwayatPasienMasuk'),
            leading: Image.asset(
              "assets/icon/icon_history.png",
              width: 24,
            ),
            title: const Text(
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
        child: Image.asset("assets/image/hospital.png"),
      ),
    );
  }

  Widget buildTextTitle() {
    return Positioned.fill(
      left: 16,
      top: 240,
      right: 0,
      bottom: 0,
      child: Text(
        "$textWelcome\n\nTetap Semangat Admin\n$nama",
        style: const TextStyle(
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
                  const Text(
                    "Jumlah Pasien Hari ini : ",
                    style: TextStyle(
                        color: colorPinkText, fontWeight: FontWeight.bold),
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: _streamAntrianPasien,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
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
                                style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: colorPinkText),
                              ),
                              const Text(
                                "Orang",
                                style: TextStyle(color: colorPinkText),
                              )
                            ],
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 24, top: 100),
              child: Image.asset("assets/image/suster.png"),
            )
          ],
        ),
      ),
    );
  }
}
