import 'package:aplikasiklinik/controller/home_pages_pasien_controller.dart';
import 'package:aplikasiklinik/themes/custom_colors.dart';
import 'package:aplikasiklinik/themes/material_colors.dart';
import 'package:aplikasiklinik/utils/constants.dart';
import 'package:aplikasiklinik/view/profile_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePages extends StatefulWidget {
  const HomePages({super.key});

  @override
  State<HomePages> createState() => _HomePagesState();
}

class _HomePagesState extends State<HomePages> {
  var hppc = HomePagesPasienController();
  
  String? uId;
  String? nama;
  String? email;
  String? role;
  String? nomorHp;
  String? jekel;
  String? tglLahir;
  String? alamat;

  @override
  void initState() {
    // TODO: implement initState
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
              //mengambil data signOut dari controller
              TextButton(
                  onPressed: () => hppc.signOut(),
                  child: Text(textYa.toUpperCase())),
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(textTidak.toUpperCase()))
            ],
          );
        });
  }

  Future<dynamic> getUser() async {
    await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((result) {
      if (result.docs.isNotEmpty) {
        setState(() {
          uId = result.docs[0].data()['uid'];
          nama = result.docs[0].data()['nama'];
          email = result.docs[0].data()['email'];
          role = result.docs[0].data()['role'];
          nomorHp = result.docs[0].data()['nomor hp'];
          tglLahir = result.docs[0].data()['tanggal lahir'];
          alamat = result.docs[0].data()['alamat'];
        });
      }
    });
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
            ),
          ),
        ],
      ),
      drawer: homeDrawer(),
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Stack(
          children: [
            buildBackground(size),
            buildHeader(size),
            buildTitleHeader(),
            buildIconHome(),
          ],
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
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "No. Akun : ${uId?.substring(20, 27)}",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              )),
              ListTile(
                //jika di klik akan menuju ke halaman homepages
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => HomePages())),
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
                  builder: (_) => ProfilePages(
                    uid: uId.toString(),
                    nama: nama.toString(),
                    email: email.toString(),
                    role: role.toString(),
                    nomorHp: nomorHp.toString(),
                    jekel: jekel.toString(),
                    tglLahir: tglLahir.toString(),
                    alamat: alamat.toString(),
                    isEdit: true))),
                    leading: Image.asset(
              "assets/icon/icon_profile.png",
              width: 24,
            ),
            title: Text(
              titleProfile,
            ),
          ),
          // ListTile(
          //   onTap: () => Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (_) => DaftarAntrianPages(
          //           uid: uId.toString(),
          //           nama: nama.toString(),
          //         ))),
          //         leading: Image.asset(
          //     "assets/icon/icon_daftar_antrian.png",
          //     width: 24,
          //   ),
          //   title: Text(
          //     titleDaftarAntrian,
          //   ),
          // ),
          // ListTile(
          //   onTap: () => Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //           builder: (_) =>
          //           JadwalPemeriksaanPages(uid: uId.toString()))),
          //           leading: Image.asset(
          //     "assets/icon/icon_jadwal_periksa.png",
          //     width: 24,
          //   ),
          //   title: Text(
          //     titleJadwalPemeriksaan,
          //   ),
          // ),
          // ListTile(
          //   onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RiwayatPemeriksaanPages(
          //     uid: uId.toString(),
          //   ))),
          //   leading: Image.asset(
          //     "assets/icon/icon_history.png",
          //     width: 24,
          //   ),
          //   title: Text(
          //     titleRiwayatPemeriksaan,
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget buildBackground(Size size) {
    return Container(
      width: size.width,
      height: size.height / 3.78,
      color: colorHome,
    );
  }

Widget buildTitleHeader() {
    return Positioned.fill(
        top: 40,
        left: 40,
        right: 0,
        bottom: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Text(
                textWelcome,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24),
              ),
            ),
            Text(
              "Semoga Lekas Sembuh\n$nama",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24),
            )
          ],
        ));
  }

  Widget buildHeader(Size size) {
    return Image.asset(
      "assets/image/vector.png",
      width: size.width,
      height: size.height / 3,
    );
  }

  Widget buildIconHome() {
    return Positioned.fill(
        child: Align(
            alignment: Alignment.center,
            child: Container(
                margin: const EdgeInsets.only(bottom: 90),
                child: Image.asset("assets/image/home_doctor.png"))));
  }

  // Widget buildButtonAmbilNoAntrian() {
  //   return Positioned(
  //     child: Align(
  //       alignment: Alignment.bottomCenter,
  //       child: Container(
  //         margin: const EdgeInsets.only(bottom: 90),
  //         child: ElevatedButton(
  //             onPressed: () => Navigator.push(
  //                 context,
  //                 MaterialPageRoute(
  //                     // builder: (_) => DaftarAntrianPages(
  //                     //   uid: uId.toString(),
  //                     //   nama: nama.toString(),
  //                     )),
  //                     style: ButtonStyle(
  //                 backgroundColor: MaterialStatePropertyAll(colorButtonHome),
  //                 shape: MaterialStatePropertyAll(RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(24)))),
  //             child: Padding(
  //               padding:
  //                   const EdgeInsets.symmetric(vertical: 8, horizontal: 40),
  //               child: Text(
  //                 textButtonAntrian,
  //                 style: TextStyle(
  //                   color: colorPrimary,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //             )),
  //       ),
  //     ),
  //   );
  // }

  Widget buildButtonLihatAntrian(Size size) {
    return Positioned(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
                margin: const EdgeInsets.only(bottom: 120),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Image.asset("assets/ellipse/ellipse8.png"),
                    Image.asset("assets/image/suster.png"),
                  ],
                )),
            Container(
                width: size.width / 1.4,
                margin: const EdgeInsets.only(bottom: 160),
                child: Row(
                  children: [
                    Text(
                      titleNoAntrian,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                )),
            Container(
                width: size.width / 2.5,
                margin: const EdgeInsets.only(bottom: 80),
                child: Row(
                  children: [
                    Text(
                      "A-001",
                      style:
                          TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                    ),
                  ],
                )),
            // Container(
            //   margin: const EdgeInsets.only(top: 120),
            //   child: ElevatedButton(
            //       onPressed: () => Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //               builder: (_) => AntrianPages(
            //                 noAntrian: "A-001", poli: poli))),
            //                 style: ButtonStyle(
            //           backgroundColor:
            //               MaterialStatePropertyAll(colorButtonHome),
            //           shape: MaterialStatePropertyAll(RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(24)))),
            //       child: Padding(
            //         padding:
            //             const EdgeInsets.symmetric(vertical: 8, horizontal: 40),
            //         child: Text(
            //           textButtonLihatAntrian,
            //           style: TextStyle(
            //             color: colorPrimary,
            //             fontWeight: FontWeight.bold,
            //           ),
            //         ),
            //       )),
            // ),
          ],
        ),
      ),
    );
  }
}
