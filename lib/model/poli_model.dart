// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PoliModel {
  String? uId;
  final String namaPoli;
  PoliModel({
    this.uId,
    required this.namaPoli,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uId': uId,
      'namaPoli': namaPoli,
    };
  }

  factory PoliModel.fromMap(Map<String, dynamic> map) {
    return PoliModel(
      uId: map['uId'] != null ? map['uId'] as String : null,
      namaPoli: map['namaPoli'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PoliModel.fromJson(String source) => PoliModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
