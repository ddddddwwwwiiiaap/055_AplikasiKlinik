import 'package:cloud_firestore/cloud_firestore.dart';

class RiwayatPemeriksaan{
  
    final Stream<QuerySnapshot> streamRiwayatPasienMasuk =
      FirebaseFirestore.instance.collection("riwayat pasien masuk").snapshots();
}