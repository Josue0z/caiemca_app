// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:caiemca_app/apis/api.caiemca.dart';
import 'package:caiemca_app/models/abstracts.dart';
import 'package:caiemca_app/models/users/user.dart';
import 'package:dio/dio.dart';

class ModelCaiemca implements CaiemcaItem<int> {
  @override
  int? id;
  @override
  String? name;
  int? brandId;
  String? brandName;
  DateTime? createdAt;
  String? companyId;
  int? airTypeId;
  String? airTypeName;
  ModelCaiemca({
    this.id,
    this.name,
    this.brandId,
    this.brandName,
    this.createdAt,
    this.companyId,
    this.airTypeId,
    this.airTypeName
  });

  static Future<List<ModelCaiemca>> get({int? brandId}) async {
    try {
      await auth();

      var params = '';

      var query = [];

      if (brandId != null) {
        query.add('brandId=$brandId');
      }

      params = '?${query.join('&')}';

      var res = await apiCaiemca.get('/models/all$params');

      if (res.statusCode == 200) {
        var data = res.data;
        return List.from(
          (data as List<dynamic>).map((e) => ModelCaiemca.fromMap(e)).toList(),
        );
      }
      return [];
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? e.error.toString();
    }
  }

    Future<ModelCaiemca?> create()async{
    try{
      await auth();
      var map = toMap();
      map.remove('id');
      map.remove('companyId');
      map.remove('createdAt');
      map.remove('brandName');
      var res = await apiCaiemca.post('/models/create',data: map);
      if(res.statusCode == 200){
        return ModelCaiemca.fromMap(res.data);
      }
      return null;
    }on DioException catch(e){
      throw e.response?.data['message'] ?? e.error.toString();
    }
  }

    Future<ModelCaiemca?> update()async{
    try{
      await auth();
      var map = toMap();
      map.remove('id');
      map.remove('companyId');
      map.remove('createdAt');
      map.remove('brandName');
      var res = await apiCaiemca.put('/models/update/$id',data: map);
      if(res.statusCode == 200){
        return ModelCaiemca.fromMap(res.data);
      }
      return null;
    }on DioException catch(e){
      throw e.response?.data['message'] ?? e.error.toString();
    }
  }

  ModelCaiemca copyWith({
    int? id,
    String? name,
    int? brandId,
    String? brandName,
    DateTime? createdAt,
    String? companyId,
    int? airTypeId,
  }) {
    return ModelCaiemca(
      id: id ?? this.id,
      name: name ?? this.name,
      brandId: brandId ?? this.brandId,
      brandName: brandName ?? this.brandName,
      createdAt: createdAt ?? this.createdAt,
      companyId: companyId ?? this.companyId,
      airTypeId: airTypeId ?? this.airTypeId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'brandId': brandId,
      'brandName': brandName,
      'createdAt': createdAt?.toIso8601String(),
      'companyId': companyId,
      'airTypeId': airTypeId,
    };
  }

  factory ModelCaiemca.fromMap(Map<String, dynamic> map) {
    return ModelCaiemca(
      id: map['id'],
      name: map['name'] != null ? map['name'] as String : null,
      brandId: map['brandId'] != null ? map['brandId'] as int : null,
      brandName: map['brandName'] != null ? map['brandName'] as String : null,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt']).toLocal()
          : null,
      companyId: map['companyId'] != null ? map['companyId'] as String : null,
      airTypeId: map['airTypeId'] != null ? map['airTypeId'] as int : null,
      airTypeName: map['airTypeName']
    );
  }

  String toJson() => json.encode(toMap());

  factory ModelCaiemca.fromJson(String source) =>
      ModelCaiemca.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ModelCaiemca(id: $id, name: $name, brandId: $brandId, brandName: $brandName, createdAt: $createdAt, companyId: $companyId, airTypeId: $airTypeId, airTypeName: $airTypeName)';
  }

  @override
  bool operator ==(covariant ModelCaiemca other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.brandId == brandId &&
        other.brandName == brandName &&
        other.createdAt == createdAt &&
        other.companyId == companyId &&
        other.airTypeId == airTypeId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        brandId.hashCode ^
        brandName.hashCode ^
        createdAt.hashCode ^
        companyId.hashCode ^
        airTypeId.hashCode;
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
