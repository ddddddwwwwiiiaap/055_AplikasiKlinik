// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PasienModel {
  String? uId;
  final String nama;
  final String email;
  final String role;
  final String nomorHp;
  final String gender;
  final String date;
  final String alamat;
  PasienModel({
    this.uId,
    required this.nama,
    required this.email,
    required this.role,
    required this.nomorHp,
    required this.gender,
    required this.date,
    required this.alamat,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uId': uId,
      'nama': nama,
      'email': email,
      'role': role,
      'nomorHp': nomorHp,
      'gender': gender,
      'date': date,
      'alamat': alamat,
    };
  }

  factory PasienModel.fromMap(Map<String, dynamic> map) {
    return PasienModel(
      uId: map['uId'] != null ? map['uId'] as String : null,
      nama: map['nama'] as String,
      email: map['email'] as String,
      role: map['role'] as String,
      nomorHp: map['nomorHp'] as String,
      gender: map['gender'] as String,
      date: map['date'] as String,
      alamat: map['alamat'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PasienModel.fromJson(String source) => PasienModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
