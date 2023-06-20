// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';

class UsersModel {
  String? uId;
  String nama;
  String email;
  String role;
  String nomorhp;
  String jekel;
  String tglLahir;
  String alamat;
  UsersModel({
    this.uId,
    required this.nama,
    required this.email,
    required this.role,
    required this.nomorhp,
    required this.jekel,
    required this.tglLahir,
    required this.alamat,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uId': uId,
      'nama': nama,
      'email': email,
      'role': role,
      'nomorhp': nomorhp,
      'jekel': jekel,
      'tglLahir': tglLahir,
      'alamat': alamat,
    };
  }

  factory UsersModel.fromMap(Map<String, dynamic> map) {
    return UsersModel(
      uId: map['uId'] != null ? map['uId'] as String : null,
      nama: map['nama'] as String,
      email: map['email'] as String,
      role: map['role'] as String,
      nomorhp: map['nomorhp'] as String,
      jekel: map['jekel'] as String,
      tglLahir: map['tglLahir'] as String,
      alamat: map['alamat'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UsersModel.fromJson(String source) => UsersModel.fromMap(json.decode(source) as Map<String, dynamic>);

  static UsersModel? fromFirebase(User user) {}
}
