// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class RiwayatPasienMasukModel {
  String uId;
  String selesaiantrian;
  RiwayatPasienMasukModel({
    required this.uId,
    required this.selesaiantrian,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uId': uId,
      'selesaiantrian': selesaiantrian,
    };
  }

  factory RiwayatPasienMasukModel.fromMap(Map<String, dynamic> map) {
    return RiwayatPasienMasukModel(
      uId: map['uId'] as String,
      selesaiantrian: map['selesaiantrian'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory RiwayatPasienMasukModel.fromJson(String source) => RiwayatPasienMasukModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
