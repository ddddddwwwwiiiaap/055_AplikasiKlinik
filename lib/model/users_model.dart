// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';

class UsersModel {
  String? uId;
  String nama;
  String email;
  String role;
  String nomorhp;
  String jeniskelamin;
  String tanggallahir;
  String alamat;
  UsersModel({
    this.uId,
    required this.nama,
    required this.email,
    required this.role,
    required this.nomorhp,
    required this.jeniskelamin,
    required this.tanggallahir,
    required this.alamat,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uId': uId,
      'nama': nama,
      'email': email,
      'role': role,
      'nomorhp': nomorhp,
      'jeniskelamin': jeniskelamin,
      'tanggallahir': tanggallahir,
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
      jeniskelamin: map['jeniskelamin'] as String,
      tanggallahir: map['tanggallahir'] as String,
      alamat: map['alamat'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UsersModel.fromJson(String source) => UsersModel.fromMap(json.decode(source) as Map<String, dynamic>);

  static UsersModel? fromFirebase(User user) {}
}
