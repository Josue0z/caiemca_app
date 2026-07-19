// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:caiemca_app/apis/api.caiemca.dart';
import 'package:caiemca_app/models/abstracts.dart';
import 'package:caiemca_app/models/users/user.dart';
import 'package:dio/dio.dart';

class BrandCaiemca implements CaiemcaItem<int> {
  @override
  int? id;
  @override
  String? name;
  String? companyId;
  DateTime? createdAt;
  BrandCaiemca({
    this.id,
    this.name,
    this.companyId,
    this.createdAt,
  });
  static Future<List<BrandCaiemca>> get() async {
    try {
      await auth();
      var res = await apiCaiemca.get('/brands/all');

      if (res.statusCode == 200) {
        var data = res.data;
        return List.from(
          (data as List<dynamic>).map((e) => BrandCaiemca.fromMap(e)).toList(),
        );
      }
      return [];
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? e.error.toString();
    }
  }

    Future<BrandCaiemca?> create()async{
    try{
      await auth();
      var map = toMap();
      map.remove('id');
      map.remove('companyId');
      map.remove('createdAt');
      var res = await apiCaiemca.post('/brands/create',data: map);
      if(res.statusCode == 200){
        return BrandCaiemca.fromMap(res.data);
      }
      return null;
    }on DioException catch(e){
      throw e.response?.data['message'] ?? e.error.toString();
    }
  }

    Future<BrandCaiemca?> update()async{
    try{
      await auth();
      var map = toMap();
      map.remove('id');
      map.remove('companyId');
      map.remove('createdAt');
      var res = await apiCaiemca.put('/brands/update/$id',data: map);
      if(res.statusCode == 200){
        return BrandCaiemca.fromMap(res.data);
      }
      return null;
    }on DioException catch(e){
      throw e.response?.data['message'] ?? e.error.toString();
    }
  }

  BrandCaiemca copyWith({
    int? id,
    String? name,
    String? companyId,
    DateTime? createdAt,
  }) {
    return BrandCaiemca(
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

  factory BrandCaiemca.fromMap(Map<String, dynamic> map) {
    return BrandCaiemca(
      id: map['id'],
      name: map['name'] != null ? map['name'] as String : null,
      companyId: map['companyId'] != null ? map['companyId'] as String : null,
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory BrandCaiemca.fromJson(String source) => BrandCaiemca.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'BrandCaiemca(id: $id, name: $name, companyId: $companyId, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant BrandCaiemca other) {
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
