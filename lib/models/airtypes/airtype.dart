// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:caiemca_app/apis/api.caiemca.dart';
import 'package:caiemca_app/models/abstracts.dart';
import 'package:caiemca_app/models/users/user.dart';
import 'package:dio/dio.dart';

class AirType implements CaiemcaItem<int> {
  @override
  int? id;
  @override
  String? name;
  String? companyId;
  DateTime? createdAt;
  AirType({
    this.id,
    this.name,
    this.companyId,
    this.createdAt,
  });
  static Future<List<AirType>> get() async {
    try {
      await auth();
      var res = await apiCaiemca.get('/airtypes/all');

      if (res.statusCode == 200) {
        var data = res.data;
        return List.from(
          (data as List<dynamic>).map((e) => AirType.fromMap(e)).toList(),
        );
      }
      return [];
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? e.error.toString();
    }
  }
      Future<AirType?> create()async{
    try{
      await auth();
      var map = toMap();
      map.remove('id');
      map.remove('companyId');
      map.remove('createdAt');
      var res = await apiCaiemca.post('/airtypes/create',data: map);
      if(res.statusCode == 200){
        return AirType.fromMap(res.data);
      }
      return null;
    }on DioException catch(e){
      throw e.response?.data['message'] ?? e.error.toString();
    }
  }

    Future<AirType?> update()async{
    try{
      await auth();
      var map = toMap();
      map.remove('id');
      map.remove('companyId');
      map.remove('createdAt');
      var res = await apiCaiemca.put('/airtypes/update/$id',data: map);
      if(res.statusCode == 200){
        return AirType.fromMap(res.data);
      }
      return null;
    }on DioException catch(e){
      throw e.response?.data['message'] ?? e.error.toString();
    }
  }
  AirType copyWith({
    int? id,
    String? name,
    String? companyId,
    DateTime? createdAt,
  }) {
    return AirType(
      id: id ?? this.id,
      name: name ?? this.name,
      companyId: companyId ?? this.companyId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'companyId': companyId,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  factory AirType.fromMap(Map<String, dynamic> map) {
    return AirType(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] != null ? map['name'] as String : null,
      companyId: map['companyId'] != null ? map['companyId'] as String : null,
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AirType.fromJson(String source) => AirType.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AirType(id: $id, name: $name, companyId: $companyId, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant AirType other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.name == name &&
      other.companyId == companyId &&
      other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      companyId.hashCode ^
      createdAt.hashCode;
  }
  
  @override
  String? identification;
  
  @override
  String? roleName;
  
  @override
  String? workerAddress;
  
  @override
  String? workerEmail;
  
  @override
  String? workerIdentification;
  
  @override
  String? workerName;
  
  @override
  String? workerPhone;
  
  @override
  String? workerRoleName;
}
