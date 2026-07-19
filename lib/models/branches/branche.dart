// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:caiemca_app/apis/api.caiemca.dart';
import 'package:caiemca_app/models/abstracts.dart';
import 'package:caiemca_app/models/users/user.dart';
import 'package:dio/dio.dart';

class BrancheCaiemca implements CaiemcaItem<int> {
  @override
  int? id;
  @override
  String? name;
  String? clientId;
  String? companyId;
  DateTime? createdAt;
  BrancheCaiemca({
    this.id,
    this.name,
    this.clientId,
    this.companyId,
    this.createdAt,
  });
   static Future<List<BrancheCaiemca>> get({String? clientId}) async {
    try {
      await auth();

      var params = '';

      var query = [];

      if(clientId != null){
        query.add('clientId=$clientId');
      }

      params = '?${query.join('&')}';


      var res = await apiCaiemca.get('/branches/all$params');

      if (res.statusCode == 200) {
        var data = res.data;
        return List.from(
          (data as List<dynamic>).map((e) => BrancheCaiemca.fromMap(e)).toList(),
        );
      }
      return [];
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? e.error.toString();
    }
  }

      Future<BrancheCaiemca?> create()async{
    try{
      await auth();
      var map = toMap();
      map.remove('id');
      map.remove('companyId');
      map.remove('createdAt');
      var res = await apiCaiemca.post('/branches/create',data: map);
      if(res.statusCode == 200){
        return BrancheCaiemca.fromMap(res.data);
      }
      return null;
    }on DioException catch(e){
      throw e.response?.data['message'] ?? e.error.toString();
    }
  }

    Future<BrancheCaiemca?> update()async{
    try{
      await auth();
      var map = toMap();
      map.remove('id');
      map.remove('companyId');
      map.remove('createdAt');
      var res = await apiCaiemca.put('/branches/update/$id',data: map);
      if(res.statusCode == 200){
        return BrancheCaiemca.fromMap(res.data);
      }
      return null;
    }on DioException catch(e){
      throw e.response?.data['message'] ?? e.error.toString();
    }
  }
  BrancheCaiemca copyWith({
    int? id,
    String? name,
    String? clientId,
    String? companyId,
    DateTime? createdAt,
  }) {
    return BrancheCaiemca(
      id: id ?? this.id,
      name: name ?? this.name,
      clientId: clientId ?? this.clientId,
      companyId: companyId ?? this.companyId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'clientId': clientId,
      'companyId': companyId,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  factory BrancheCaiemca.fromMap(Map<String, dynamic> map) {
    return BrancheCaiemca(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] != null ? map['name'] as String : null,
      clientId: map['clientId'] != null ? map['clientId'] as String : null,
      companyId: map['companyId'] != null ? map['companyId'] as String : null,
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory BrancheCaiemca.fromJson(String source) => BrancheCaiemca.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'BrancheCaiemca(id: $id, name: $name, clientId: $clientId, companyId: $companyId, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant BrancheCaiemca other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.name == name &&
      other.clientId == clientId &&
      other.companyId == companyId &&
      other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      clientId.hashCode ^
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
