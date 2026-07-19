// ignore_for_file: public_member_api_docs, sort_constructors_first


import 'dart:convert';

import 'package:caiemca_app/apis/api.caiemca.dart';
import 'package:caiemca_app/models/abstracts.dart';
import 'package:caiemca_app/models/users/user.dart';
import 'package:dio/dio.dart';

class ServiceCaiemca implements CaiemcaItem<int> {
  @override
   int? id;
   @override
   String? name;
   String? companyId;
   DateTime? createdAt;
   @override 
   String? identification;
  ServiceCaiemca({
    this.id,
    this.name,
    this.companyId,
    this.createdAt,
    this.identification,
  });

    static Future<List<ServiceCaiemca>> get() async {
    try {
      await auth();
      var res = await apiCaiemca.get('/services/all');

      if (res.statusCode == 200) {
        var data = res.data;
        return List.from(
          (data as List<dynamic>).map((e) => ServiceCaiemca.fromMap(e)).toList(),
        );
      }
      return [];
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? e.error.toString();
    }
  }
  Future<ServiceCaiemca?> create()async{
    try{
      await auth();
      var map = toMap();
      map.remove('id');
      map.remove('companyId');
      map.remove('createdAt');
      var res = await apiCaiemca.post('/services/create',data: map);
      if(res.statusCode == 200){
        return ServiceCaiemca.fromMap(res.data);
      }
      return null;
    }on DioException catch(e){
      throw e.response?.data['message'] ?? e.error.toString();
    }
  }

    Future<ServiceCaiemca?> update()async{
    try{
      await auth();
      var map = toMap();
      map.remove('id');
      map.remove('companyId');
      map.remove('createdAt');
      var res = await apiCaiemca.put('/services/update/$id',data: map);
      if(res.statusCode == 200){
        return ServiceCaiemca.fromMap(res.data);
      }
      return null;
    }on DioException catch(e){
      throw e.response?.data['message'] ?? e.error.toString();
    }
  }
  ServiceCaiemca copyWith({
    int? id,
    String? name,
    String? companyId,
    DateTime? createdAt,
    String? identification,
  }) {
    return ServiceCaiemca(
      id: id ?? this.id,
      name: name ?? this.name,
      companyId: companyId ?? this.companyId,
      createdAt: createdAt ?? this.createdAt,
      identification: identification ?? this.identification,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'companyId': companyId,
      'createdAt': createdAt?.toIso8601String()
    };
  }

  factory ServiceCaiemca.fromMap(Map<String, dynamic> map) {
    return ServiceCaiemca(
      id: map['id'],
      name: map['name'] != null ? map['name'] as String : null,
      companyId: map['companyId'] != null ? map['companyId'] as String : null,
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']).toLocal() : null,
      identification: map['identification'] != null ? map['identification'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ServiceCaiemca.fromJson(String source) => ServiceCaiemca.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ServiceCaiemca(id: $id, name: $name, companyId: $companyId, createdAt: $createdAt, identification: $identification)';
  }

  @override
  bool operator ==(covariant ServiceCaiemca other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.name == name &&
      other.companyId == companyId &&
      other.createdAt == createdAt &&
      other.identification == identification;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      companyId.hashCode ^
      createdAt.hashCode ^
      identification.hashCode;
  }
  
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

  @override
  String? roleName;
}
