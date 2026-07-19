// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:caiemca_app/apis/api.caiemca.dart';
import 'package:dio/dio.dart';

class ResponsibleCaiemca {
  int? id;
  String? identification;
  String? name;
  DateTime? createdAt;
  ResponsibleCaiemca({
    this.id,
    this.identification,
    this.name,
    this.createdAt,
  });
  
  static Future<ResponsibleCaiemca?> findByIdentification({required String identification})async{
    try{
      var res = await apiCaiemca.get('/responsibles/find-by-identification?identification=$identification');
      if(res.statusCode == 200){
        return ResponsibleCaiemca.fromMap(res.data);
      }
      return null;
    } catch(_){
      return null;
    }
  }

  ResponsibleCaiemca copyWith({
    int? id,
    String? identification,
    String? name,
    DateTime? createdAt,
  }) {
    return ResponsibleCaiemca(
      id: id ?? this.id,
      identification: identification ?? this.identification,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'identification': identification,
      'name': name,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  factory ResponsibleCaiemca.fromMap(Map<String, dynamic> map) {
    return ResponsibleCaiemca(
      id: map['id'] != null ? map['id'] as int : null,
      identification: map['identification'] != null ? map['identification'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ResponsibleCaiemca.fromJson(String source) => ResponsibleCaiemca.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ResponsibleCaiemca(id: $id, identification: $identification, name: $name, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant ResponsibleCaiemca other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.identification == identification &&
      other.name == name &&
      other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      identification.hashCode ^
      name.hashCode ^
      createdAt.hashCode;
  }
}
