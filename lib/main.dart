import 'package:aplikasiklinik/themes/material_colors.dart';
import 'package:aplikasiklinik/utils/constants.dart';
import 'package:aplikasiklinik/view/admin/add_poli.dart';
import 'package:aplikasiklinik/view/admin/daftar_antrian_d.dart';
import 'package:aplikasiklinik/view/admin/home_pages_d.dart';
import 'package:aplikasiklinik/view/admin/poli.dart';
import 'package:aplikasiklinik/view/admin/riwayat_pasien_masuk.dart';
import 'package:aplikasiklinik/view/home_pages.dart';
import 'package:aplikasiklinik/view/jadwal_pemeriksaan.dart';
import 'package:aplikasiklinik/view/login.dart';
import 'package:aplikasiklinik/view/next_pages.dart';
import 'package:aplikasiklinik/view/pendaftaran.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: titleApp,
        theme: ThemeData(
          primarySwatch: colorPrimary,
        ),
        routes: {
          '/loginPages': (_) => Login(),
          '/homePages': (_) => HomePages(),
          '/jadwalPemeriksaanPages': (_) => JadwalPemeriksaanPages(),
          '/homePagesAdmin': (_) => HomePagesAdmin(),
          '/daftarAntrianPagesAdmin': (_) => DaftarAntrianPagesAdmin(),
          '/riwayatPasienMasuk': (_) => RiwayatPasienMasuk(),
          '/poliPagesAdmin': (_) => Poli(),
        },
        home: Login());
  }
}
